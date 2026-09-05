# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-NO-SI\Table 5S.R
# Source SHA256: 82EB4E43678E72B99248E17C955B2F0C2BCFB5BB95D48F3A94A69CFAF958F2A7
#
# Sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific Windows absolute paths and email addresses were redacted.
# R regular-expression strings are preserved exactly; they are not interpreted
# as UNC/network paths.
#
# Scientific statements/calculations are retained as historical provenance.
# This script may require historical data objects, working directories,
# package versions, and upstream workflow state that are not distributed here.
# ============================================================================
#water_sheets_name <- dir('..//..//output//Present//Water//')
water_sheets_name <- dir('<LOCAL_PATH_REDACTED>',pattern = 'wat_')
#wd <- dir('..//..//output//Present//Water//',full.names = T) %>% map(read.table,sep='',skip = 23,header=F,stringsAsFactors=F)
wd <- dir('<LOCAL_PATH_REDACTED>',pattern = 'wat_',full.names = T) %>% map(read.table,sep='',skip = 23,header=F,stringsAsFactors=F)
names(wd) <- water_sheets_name
length(wd)
water_f2r8 <- wd

x1 <- 1:100
#y1 <- 1950:2049
#y1<- 2021:2120
y1<- 1950:2049
df <- data.frame(year=x1,n_year=y1)
df$year <- as.numeric(df$year)
df$n_year <- as.numeric(df$n_year)

for (i in 1:length(water_f2r8)){
  water_f2r8[[i]] <- as.data.frame(water_f2r8[[i]])
  colnames(water_f2r8[[i]]) <- c('OFE#','JulianDay','year','Precp','RM','Runoff','EP',
                                 'ES','ER','DP','UpStrmQ','SubRIn','latqcc','Total_Soil_Water',
                                 'frozwt','SnowWater','QOFE','Tile','Irr','Area')
  water_f2r8[[i]] %>% select(JulianDay,year,Precp,Runoff,EP,ES,ER,DP,Total_Soil_Water) %>% 
    left_join(df,by='year')%>% mutate(temp = paste(n_year,JulianDay,sep = '-')) %>%
    mutate(Date = strptime(temp,'%Y-%j'))%>% mutate(mon = as.character(month(Date)),
                                                    ET = EP + ES + ER) %>%
    select(Date,JulianDay,mon,year,n_year,Precp,Runoff,ET,DP,Total_Soil_Water,-temp)-> water_f2r8[[i]]
}

water_df_f2r8 <- data.frame()
water_f2r8_sum <- list()

for (i in 1:length(water_f2r8)){
  water_f2r8_sum[[i]] <- water_f2r8[[i]] %>% summarise(name = names(water_f2r8[i]),
                                                       Ave_Ann_ET = round(sum(ET)/100,2),
                                                       Ave_Ann_DP = round(sum(DP)/100,3),
                                                       Ave_Ann_Soilwater = round(mean(Total_Soil_Water),2))
  water_df_f2r8 <- rbind(water_df_f2r8,water_f2r8_sum[[i]])
}

water_df_f2r8

water_df_f2r8 %>% mutate(Tillage = case_when(
  grepl('wat_C',name) ~ 'CT',
  grepl('wat_D',name) ~ 'DT',
  grepl('wat_N',name) ~ 'NT',
  grepl('wat_R',name) ~ 'RT',
  TRUE ~ 'None'),
  Crop = case_when(
    grepl('-ca-a',name) ~ 'Ca-alf',
    grepl('-ca',name) ~ 'Ca',
    grepl('-ct-a',name) ~ 'Ct-alf',
    grepl('-ct',name) ~ 'Ct',
    grepl('-sb-a',name) ~ 'Sb-alf',
    grepl('-sb',name) ~ 'Sb',
    grepl('-sg-a',name) ~ 'Sg-alf',
    grepl('-sg',name) ~ 'Sg',
    grepl('-wt-a',name) ~ 'Wt-alf',
    grepl('-wt-D',name) ~ 'Wt_double',
    grepl('-wt',name) ~ 'Wt',
    TRUE ~ 'None'),
  Climate = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}')
) -> water_f2r8_out_sum

nrow(water_f2r8_out_sum)
head(water_f2r8_out_sum)
tail(water_f2r8_out_sum)
water_f2r8_out_sum %>% group_by(Tillage) %>% 
  summarise(ET = round(mean(Ave_Ann_ET,na.rm = T),1),
            SW = round(mean(Ave_Ann_Soilwater,na.rm = T),1),
            DP = round(mean(Ave_Ann_DP,na.rm = T),3))%>% arrange(desc(ET)) -> water_temp
write.csv(water_temp,'water_f2r8.csv')
