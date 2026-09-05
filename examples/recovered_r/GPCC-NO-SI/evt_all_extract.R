# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\evt_all_extract.R
# Source SHA256: A4E7B6020B0B85C087FBF8DCB112D1CF94325A63F9EE29F7E4B7E7D038E098E5
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
evt_sheets_name_f2r8 <- dir('<LOCAL_PATH_REDACTED>',pattern = 'evt_')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T,pattern = 'evt_') %>% map(read.table,sep='',skip=2,header=T,stringsAsFactors=F)
names(dt) <- evt_sheets_name_f2r8
length(dt)
evt <- dt

x1 <- 1:100
y1 <- 1950:2049
df_f2r8 <- data.frame(year=x1,n_year=y1)
df_f2r8$year <- as.character(df_f2r8$year)
df_f2r8$n_year <- as.character(df_f2r8$n_year)
str(df_f2r8)

for (i in 1:length(evt)){
  evt[[i]] <- as.data.frame(evt[[i]])
  colnames(evt[[i]]) <- c('day','mon','year','Precp','Runoff','Irrigation Detachment',
                          'Average Detachment','Maximum Detachment','Point','Average Deposition',
                          'Maximum Deposition','Point','Soilloss','ER')
}


# only extracting specific columns from evt list
for (i in 1:725){
  evt[[i]] <- evt[[i]][,c(1:5,13)]
  evt[[i]][,c(1)] <- as.character(evt[[i]][,c(1)])
  evt[[i]][,c(2)] <- as.character(evt[[i]][,c(2)])
  evt[[i]][,c(3)] <- as.character(evt[[i]][,c(3)])
  evt[[i]] %>% left_join(df_f2r8,by='year')%>%
    mutate(date = paste(day,mon,n_year,sep = '-')) -> evt[[i]]
  evt[[i]]$date<-as.Date(as.POSIXct(evt[[i]]$date,format='%d-%m-%Y'))
  evt[[i]]$month <- factor(month(evt[[i]]$date),ordered = T)
  evt[[i]][,c(8,1,2,9,3,7,4,5,6)] -> evt[[i]]
}


head(evt)
evt_f2r8 <- list()
evt_df_f2r8 <- data.frame()
# calculate 100-year average runoff and soil loss 
for (i in 1:length(evt)){
  evt[[i]] %>% summarise(Precp = sum(Precp)/100,
                         Run = sum(Runoff)/100,
                         Soil = sum(Soilloss) * 80/160000) -> evt_f2r8[[i]]
  evt_f2r8[[i]] <- evt_f2r8[[i]] %>% mutate(name = names(evt[i]),
                                            Tillage = case_when(
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
                                            GCMs = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'),
                                            Climate = c('f2r8.5'))
}
names(evt_f2r8) <- evt_sheets_name_f2r8

for (i in 1:length(evt_f2r8)) {
  evt_df_f2r8 <- rbind(evt_df_f2r8, evt_f2r8[[i]])
}

evt_df_f2r8 %>% select(name,Precp,Run,Soil,Tillage,Crop,GCMs,Climate) -> evt_df_f2r8

#calculate runoff and soil loss from each GCM 
evt_df_f2r8 %>% group_by(GCMs) %>% summarise(runoff = mean(Run),
                                            soilloss = mean(Soil)) %>%
  summarise(avg_GCM_runoff = mean(runoff),
            avg_GCM_soilloss = mean(soilloss))

evt_df_f2r8 %>% group_by(GCMs) %>% summarise( Precp = mean(Precp),
                                              runoff = mean(Run),
                                             soilloss = mean(Soil))

evt_all <- rbind(evt_df_f1r4,evt_df_f1r8,evt_df_f2r4,evt_df_f2r8)
head(evt_all)
tail(evt_all)
evt_all$downscale <- c('GPCC-NO-SI')

write.csv(evt_all, 'evt_all_gpcc-no-si.csv',row.names = F)
