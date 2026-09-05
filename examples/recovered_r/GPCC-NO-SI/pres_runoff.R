# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\pres_runoff.R
# Source SHA256: 379C1E8AB8A1FFB4A602D4C7A02B5DEB433CCD4F2F06B73E5BACA636A13923FC
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
# load event file for baseline, including runoff and soil loss data
evt_sheets_name_pres <- dir('<LOCAL_PATH_REDACTED>',pattern = 'evt_')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T,pattern = 'evt_') %>% map(read.table,sep='',skip=2,header=T,stringsAsFactors=F)
names(dt) <- evt_sheets_name_pres
length(dt)
evt <- dt

x <- 1:100
y <- 1950:2049
df <- data.frame(year=x,n_year=y)
df$year <- as.character(df$year)
df$n_year <- as.character(df$n_year)
str(df)

for (i in 1:length(evt)){
  evt[[i]] <- as.data.frame(evt[[i]])
  colnames(evt[[i]]) <- c('day','mon','year','Precp','Runoff','Irrigation Detachment',
                          'Average Detachment','Maximum Detachment','Point','Average Deposition',
                          'Maximum Deposition','Point','Soilloss','ER')
}

head(evt)
library(lubridate)
# only extracting specific columns from evt list
for (i in 1:29){
  evt[[i]] <- evt[[i]][,c(1:5,13)]
  evt[[i]][,c(1)] <- as.character(evt[[i]][,c(1)])
  evt[[i]][,c(2)] <- as.character(evt[[i]][,c(2)])
  evt[[i]][,c(3)] <- as.character(evt[[i]][,c(3)])
  evt[[i]] %>% left_join(df,by='year')%>%
    mutate(date = paste(day,mon,n_year,sep = '-')) -> evt[[i]]
  evt[[i]]$date<-as.Date(as.POSIXct(evt[[i]]$date,format='%d-%m-%Y'))
  evt[[i]]$month <- factor(month(evt[[i]]$date),ordered = T)
  evt[[i]][,c(8,1,2,9,3,7,4,5,6)] -> evt[[i]]
}

head(evt)
evt_pres_out_sum <- data.frame()
sumry_pres <- list()
df1_pres <- list()

for (i in 1:length(evt)){
  evt[[i]] %>% summarise( name = names(evt[i]),
                          event_records = n(),
                          unique_year = n_distinct(year),
                          Ave_Ann_Precp = round(sum(Precp)/100,3),
                          Ave_Ann_Runoff = round(sum(Runoff)/100,3),
                          Ave_Ann_Sed_Width = round(sum(Soilloss)/100,3),
                          Ave_Ann_Sed_Profile_Width = round(Ave_Ann_Sed_Width * 80,3),
                          Total_Soil_Loss =round(Ave_Ann_Sed_Profile_Width/1600,3)) -> sumry_pres[[i]]
  evt[[i]] %>% arrange(month) %>%
    group_by(month)%>%
    summarise(mon_Runoff = round(sum(Runoff)/100,3))%>%
    t() -> df1_pres[[i]]
}


num <- 0
a <- list()
for (i in 1:length(df1_pres)) {
  if (ncol(df1_pres[[i]]) != 12) {
    num = num + 1
    print(df1_pres[[i]])
    a <- c(a,df1_pres[i])
  }
}
print(num)


for (i in 1:length(df1_pres)) {
  df1_pres[[i]] <- as.data.frame(df1_pres[[i]],stringsAsFactors = F)
  if (ncol(df1_pres[[i]]) < 12) {
    if (!("1" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='1',soil = 0)),.after = 0)
    }
    if (!("2" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='2',soil = 0)),.after = 1)
    } 
    if (!("3" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='3',soil = 0)),.after = 2)
    }
    if (!("4" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='4',soil = 0)),.after = 3)
    }
    if (!("5" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='5',soil = 0)),.after = 4)
    }
    if (!("6" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='6',soil = 0)),.after = 5)
    }
    if (!("7" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='7',soil = 0)),.after = 6)
    }
    if (!("8" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='8',soil = 0)),.after = 7)
    }
    if (!("9" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='9',soil = 0)),.after = 8)
    }
    if (!("10" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='10',soil = 0)),.after = 9)
    }
    if (!("11" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='11',soil = 0)),.after = 10)
    }
    if (!("12" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='12',soil = 0)),.after = 11)
    }
  } else if (ncol(df1_pres[[i]]) > 12) {
    df1_pres[[i]] %>% select(1:12) -> df1_pres[[i]]
  } else {
    next
  }
}

for (i in 1:length(df1_pres)) {
  colnames(df1_pres[[i]]) <- month.abb
  row.names(df1_pres[[i]]) <- NULL
  temp <- cbind(sumry_pres[[i]],df1_pres[[i]][2,])
  evt_pres_out_sum <- rbind(evt_pres_out_sum,temp)
}

nrow(evt_pres_out_sum)

evt_pres_out_sum %>% mutate(Tillage = case_when(
  grepl('evt_C',name) ~ 'CT',
  grepl('evt_D',name) ~ 'DT',
  grepl('evt_N',name) ~ 'NT',
  grepl('evt_R',name) ~ 'RT',
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
  GCMs = c('GPCC-NO-SI'),
  Climate = c('Baseline')
) -> evt_out_sum


nrow(evt_out_sum)
head(evt_out_sum)
str(evt_out_sum)
evt_out_sum <- as.data.frame(evt_out_sum)
write.csv(evt_out_sum,'evt_pres_runoff_sum.csv')

evt_out_sum %>% filter(Crop == 'Wt' |
                         Crop == 'Wt-alf'|
                         Crop == 'Wt_double') %>%
  select(Jan:Climate) %>%
  gather(Jan:Dec,key='Mon',value = 'Runoff') -> pres_runoff
head(pres_runoff)  
nrow(pres_runoff)
pres_runoff$Runoff <- as.numeric(pres_runoff$Runoff)
pres_runoff %>% group_by(Crop) %>%
  summarise(runoff = mean(Runoff))
pres_runoff$Climate <- 'Baseline'
