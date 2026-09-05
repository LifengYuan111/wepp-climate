# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\evt_GCMs_100.R
# Source SHA256: C3CF1241007B79E566C76784FAE2F13534BD2311398087E3002DA28BA9381ECE
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
evt_sheets_name_f1r4_1 <- dir('<LOCAL_PATH_REDACTED>',pattern = 'evt_')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T,pattern = 'evt_') %>% map(read.table,sep='',skip=2,header=T,stringsAsFactors=F)
names(dt) <- evt_sheets_name_f1r4_1
length(dt)
evt <- dt

x1 <- 1:100
y1 <- 1950:2049
df_f1r4_1 <- data.frame(year=x1,n_year=y1)
df_f1r4_1$year <- as.character(df_f1r4_1$year)
df_f1r4_1$n_year <- as.character(df_f1r4_1$n_year)
str(df_f1r4_1)

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
  evt[[i]] %>% left_join(df_f1r4_1,by='year')%>%
    mutate(date = paste(day,mon,n_year,sep = '-')) -> evt[[i]]
  evt[[i]]$date<-as.Date(as.POSIXct(evt[[i]]$date,format='%d-%m-%Y'))
  evt[[i]]$month <- factor(month(evt[[i]]$date),ordered = T)
  evt[[i]][,c(8,1,2,9,3,7,4,5,6)] -> evt[[i]]
}

head(evt[[1]])

evt_f1r4_1 <- list()
evt_df_f1r4_1 <- data.frame()
# calculate 100-year average runoff and soil loss 
for (i in 1:length(evt)){
  evt[[i]] %>% summarise(day = day,
                         mon = mon,
                        year = year,
                        n_year = n_year,
                        Precp = sum(Precp)/100,
                        Run = sum(Runoff)/100,
                        Soil = sum(Soilloss) * 80/160000) -> evt_f1r4_1[[i]]
  evt_f1r4_1[[i]] <- evt_f1r4_1[[i]] %>% mutate(name = names(evt[i]),
                                            GCMs = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'),
                                            Climate = c('f1r4_1.5'))
}
names(evt_f1r4_1) <- evt_sheets_name_f1r4_1

head(evt_f1r4_1)
tail(evt_f1r4_1)

for (i in 1:length(evt_f1r4_1)) {
  evt_df_f1r4_1 <- rbind(evt_df_f1r4_1, evt_f1r4_1[[i]])
}

head(evt_df_f1r4_1)
tail(evt_df_f1r4_1)

evt_df_f1r4_1 %>% select(name,day,mon,year,n_year,Precp,Run,Soil,GCMs,Climate) -> evt_df_f1r4_1

evt_df_f1r4_1 %>% group_by(GCMs,year) %>% summarise(soil = mean(Soil))  

head(runoff_100_f1r4)
runoff_GCMs_f1r4$Climate <-gsub('f1r4.5','F1R4.5',runoff_GCMs_f1r4$Climate)
runoff_GCMs_f1r8$Climate <-gsub('f1r8.5','F1R8.5',runoff_GCMs_f1r8$Climate)
runoff_GCMs_f2r4$Climate <-gsub('f2r4.5','F2R4.5',runoff_GCMs_f2r4$Climate)
runoff_GCMs_f2r8$Climate <-gsub('f2r8.5','F2R8.5',runoff_GCMs_f2r8$Climate)

runoff_GCMs_all <- rbind(runoff_GCMs_f1r4,
                         runoff_GCMs_f1r8,
                         runoff_GCMs_f2r4,
                         runoff_GCMs_f2r8)
head(runoff_GCMs_all)
tail(runoff_GCMs_all)

# extract runoff on wheat fields
runoff_GCMs_wheat <- runoff_GCMs_all %>% filter(Crop == 'Wt'|
                             Crop == 'Wt-alf'|
                             Crop == 'Wt_double')


runoff_GCMs_wheat %>% group_by(Climate,GCMs) %>%
  summarise(Runoff100=mean(Total_Runoff),
            Soil100 = mean(Total_Soil_Loss)) %>%
  select(GCMs,Runoff100,Soil100,Climate) %>%
  mutate(Climate = case_when(
    Climate == 'f1r4.5'~'RCP4.5 (2021-2050)',
    Climate == 'f1r8.5'~'RCP8.5 (2021-2050)',
    Climate == 'f2r4.5'~'RCP4.5 (2051-2080)',
    Climate == 'f2r8.5'~'RCP8.5 (2051-2080)',
  )) -> runoff_GCMs_wheat

head(runoff_GCMs_wheat)
tail(runoff_GCMs_wheat)
nrow(runoff_GCMs_wheat)

write.csv(runoff_GCMs_wheat,'runoff_GCMs_wheat.csv',row.names = F)


runoff_GCMs_wheat %>% group_by(Climate)%>%
  summarise(Runoff = mean(Runoff100),
            Soil = mean(Soil100))


unique(runoff_GCMs_all$Crop)

runoff_GCMs_all$downscale <- c('GPCC-NO-SI')
write.csv(runoff_GCMs_all,'runoff_GCMs_all_GNS.csv',row.names = F)

runoff_GCMs_all_GS <- read.csv('runoff_GCMs_all_GS.csv',header=T)
runoff_GCMs_all_SS <- read.csv('runoff_GCMs_all_SS.csv',header=T)
runoff_GCMs_all_SNS <- read.csv('runoff_GCMs_all_SNS.csv',header=T)
runoff_GCMs_all_GNS <- read.csv('runoff_GCMs_all_GNS.csv',header=T)
head(runoff_GCMs_all_GNS)
head(runoff_GCMs_all_GS)
head(runoff_GCMs_all_SS)
head(runoff_GCMs_all_SNS)
evt_GCMs_100 <- rbind(runoff_GCMs_all,runoff_GCMs_all_GS,
                      runoff_GCMs_all_SS,runoff_GCMs_all_SNS)

head(evt_GCMs_100)
evt_GCMs_100$Climate <- gsub('f1r4.5','F1R4.5',evt_GCMs_100$Climate)
evt_GCMs_100$Climate <- gsub('f1r8.5','F1R8.5',evt_GCMs_100$Climate)
evt_GCMs_100$Climate <- gsub('f2r4.5','F2R4.5',evt_GCMs_100$Climate)
evt_GCMs_100$Climate <- gsub('f2r8.5','F2R8.5',evt_GCMs_100$Climate)

evt_GCMs_100 %>% filter(downscale == 'GPCC-SI',
                        Climate =='F2R8.5') %>% group_by(GCMs) %>%
  summarise(Soil = mean(Total_Soil_Loss),
            Run = mean(Total_Runoff)) %>% summarise(Soil = mean(Soil),
                                                    Runoff = mean(Run))


evt_GCMs_100 %>% filter(downscale == 'GPCC-SI',
                        Climate =='F2R8.5') %>% group_by(GCMs) %>%
  summarise(Soil = mean(Total_Soil_Loss),
            Run = mean(Total_Runoff)) %>% {range(.$Soil)}

length(unique(evt_GCMs_100$GCMs))
evt_GCMs_100 %>% filter(GCMs == 'MI_L')
view(a)
head(evt_GCMs_100)
evt_GCMs_100$GCMs <- gsub('MI_L','MR_L',evt_GCMs_100$GCMs)

evt_GCMs_100 %>% group_by(downscale,Climate,GCMs) %>%
  summarise(SD = sd(Total_Soil_Loss),
            ran = max(Total_Soil_Loss)-min(Total_Soil_Loss),
            Avg_soil = mean(Total_Soil_Loss),
            SD_R =sd(Total_Runoff),
            ran_r = max(Total_Runoff)-min(Total_Runoff),
            Avg_run = mean(Total_Runoff)) %>% summarise(Avg_SD_Soil = mean(SD),
                                                        Avg_Range_soil = mean(ran),
                                                        Avg_SD_Run = mean(SD_R),
                                                        Avg_Range_Run = mean(ran_r),
                                                        Avg_Soilloss = mean(Avg_soil),
                                                        Avg_Runoff = mean(Avg_run)) 
-> stats_evt

write.csv(stats_evt,'stats_evt.csv',row.names = F)
