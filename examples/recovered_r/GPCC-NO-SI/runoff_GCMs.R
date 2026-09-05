# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\runoff_GCMs.R
# Source SHA256: F0F7DEAE840600C145ECA4E7EC91FDAEFD05FEC6A5C859318F3D674E95F28483
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
evt_sheets_name_f2r8 <- dir('<LOCAL_PATH_REDACTED>',pattern = 'evt_')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T,pattern = 'evt_') %>% map(read.table,sep='',skip=2,header=T,stringsAsFactors=F)
names(dt) <- evt_sheets_name_f2r8
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
evt_base <- data.frame()
runoff_100_f2r8 <- list()
# only extracting specific columns from evt list
for (i in 1:725){
  evt[[i]] <- evt[[i]][,c(1:5,13)]
  evt[[i]][,c(1)] <- as.character(evt[[i]][,c(1)])
  evt[[i]][,c(2)] <- as.character(evt[[i]][,c(2)])
  evt[[i]][,c(3)] <- as.character(evt[[i]][,c(3)])
  evt[[i]] %>% left_join(df,by='year')%>%
    mutate(date = paste(day,mon,n_year,sep = '-')) -> evt[[i]]
  evt[[i]]$date<-as.Date(as.POSIXct(evt[[i]]$date,format='%d-%m-%Y'))
  evt[[i]]$month <- factor(month(evt[[i]]$date),ordered = T)
  evt[[i]][,c(8,1,2,9,3,7,4,5,6)] -> evt[[i]]
  evt[[i]]$name <- names(evt[i])
  df %>% left_join(evt[[i]],by='n_year') %>% select(n_year,Runoff,Soilloss)%>% mutate(across(everything(),~replace_na(.x,0))) %>% 
    group_by(n_year)%>% summarise(Total_Soil_Loss = round(sum(Soilloss)*80/1600,3),
                                  Total_Runoff = sum(Runoff)) -> runoff_100_f2r8[[i]]
  evt_base <- rbind(evt_base,runoff_100_f2r8[[i]])
}
names(runoff_100_f2r8) <- evt_sheets_name_f2r8

runoff_GCMs_f2r8 <- data.frame()
for (i in 1:length(runoff_100_f2r8)) {
  runoff_100_f2r8[[i]] %>% mutate(Tillage = case_when(
    grepl('evt_C',names(runoff_100_f2r8[i])) ~ 'CT',
    grepl('evt_D',names(runoff_100_f2r8[i])) ~ 'DT',
    grepl('evt_N',names(runoff_100_f2r8[i])) ~ 'NT',
    grepl('evt_R',names(runoff_100_f2r8[i])) ~ 'RT',
    TRUE ~ 'None'),
    Crop = case_when(
      grepl('-ca-a',names(runoff_100_f2r8[i])) ~ 'Ca-alf',
      grepl('-ca',names(runoff_100_f2r8[i])) ~ 'Ca',
      grepl('-ct-a',names(runoff_100_f2r8[i])) ~ 'Ct-alf',
      grepl('-ct',names(runoff_100_f2r8[i])) ~ 'Ct',
      grepl('-sb-a',names(runoff_100_f2r8[i])) ~ 'Sb-alf',
      grepl('-sb',names(runoff_100_f2r8[i])) ~ 'Sb',
      grepl('-sg-a',names(runoff_100_f2r8[i])) ~ 'Sg-alf',
      grepl('-sg',names(runoff_100_f2r8[i])) ~ 'Sg',
      grepl('-wt-a',names(runoff_100_f2r8[i])) ~ 'Wt-alf',
      grepl('-wt-D',names(runoff_100_f2r8[i])) ~ 'Wt_double',
      grepl('-wt',names(runoff_100_f2r8[i])) ~ 'Wt',
      TRUE ~ 'None'),
    GCMs = str_extract(names(runoff_100_f2r8[i]),'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'),
    Climate = c('f2r8.5')
  ) -> runoff_100_f2r8[[i]]
  runoff_GCMs_f2r8 <- rbind(runoff_GCMs_f2r8,runoff_100_f2r8[[i]])
}
head(runoff_GCMs_f2r8)
