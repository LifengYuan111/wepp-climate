# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-SI\tmax_tmin_calculate.R
# Source SHA256: 077CFAFBF8557A8598C3CF5F6C7668CB71AA30F4B1F5ECBE7917AD18CEAAEAAB
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
#  consider GPCC baseline as a reference

rain_sheet_name_pres<- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_pres
dt
cli_pres <- dt
cli_pres <- lapply(cli_pres, function(x) cli_pres = x[,c(1:4,8,9)])
nrow(cli_pres[[1]])
colnames(cli_pres[[1]]) <- c('day','mon','year','prcp','tmax','tmin')
cli <- data.frame(date=seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'))
for (i in 1:length(cli_pres)){
  cli_pres[[i]] <- cli_pres[[i]] %>% mutate(tmean = round((tmax+tmin)/2,2))
  cli <- cbind(cli,cli_pres[[i]][7])
}

library(lubridate)
data_ref <- cli_pres[[1]] %>% add_column(date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0) %>% 
  mutate(month = month(date,label = T),
         new_year = year(date)) %>% filter(new_year >= 1990, new_year <= 2019) %>% group_by(month) %>% summarise(ref_tmax = mean(tmax,na.rm=T),
                                                                                                                 ref_tmin = mean(tmin,na.rm=T),
                                                                                                                 ref_tmean = mean(tmean,na.rm = T))                                                                                                                

# calculate maximum and minimum temperature anomly
rain_sheet_name_f1r4<- dir('<LOCAL_PATH_REDACTED>')
dt_f1r4 <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt_f1r4) <- rain_sheet_name_f1r4
dt_f1r4
cli_f1r4 <- dt_f1r4
head(cli_f1r4)
cli_f1r4 <- lapply(cli_f1r4,function(x) cli_f1r4 = x[c(1:4,8,9)])
# add a column standing for mean temperature
for (i in 1:length(cli_f1r4)){
  colnames(cli_f1r4[[i]]) <- c('day','mon','year','prcp','tmax','tmin')
  cli_f1r4[[i]]$tmean <- (cli_f1r4[[i]]$tmax + cli_f1r4[[i]]$tmin)/2
}
head(cli_f1r4)

# calculate max,min,mean temperature for each GCM and group them into a dataframe
data <- list()
temp <- list()
total <- data.frame()
for (i in 1:25) {
  cli_f1r4[[i]] %>% add_column(date = seq(as.Date('2021/01/01'),as.Date('2121/01/01'),'days'),.after = 0) %>% 
    mutate(month = month(date,label = T),
           new_year = year(date)) %>% group_by(new_year,month) %>% summarise(avg_mon_tmax = mean(tmax,na.rm = T),
                                                                             avg_mon_tmin = mean(tmin,na.rm = T),
                                                                             avg_mon_tmean = mean(tmean,na.rm = T)) -> data[[i]]
  data[[i]]%>% left_join(data_ref,by='month') %>% mutate(Date = str_c(new_year,as.numeric(month),1,sep = '-') %>% ymd(),
                                                         tmax_anom = avg_mon_tmax - ref_tmax,
                                                         tmin_anom = avg_mon_tmin - ref_tmin,
                                                         tmean_anom = avg_mon_tmean - ref_tmean) -> data[[i]]
  data[[i]] %>% group_by(new_year) %>% summarise(anom_max = mean(tmax_anom),
                                                 anom_min = mean(tmin_anom),
                                                 anom_mean = mean(tmean_anom)) %>% summarise(anom_tmax = mean(anom_max),
                                                                                             anom_tmin = mean(anom_min),
                                                                                             anom_tmean = mean(anom_mean)) -> temp[[i]]
  
  total <- rbind(total, temp[[i]])
}
total
names(temp) <- rain_sheet_name_f1r4
temp

temp_GCMs <- NULL
temp_GCMs <- data.frame()
for (i in 1:length(temp)){
  temp_GCMs <- rbind(temp_GCMs,temp[[i]])
}
temp_GCMs$name <- names(temp)
temp_GCMs
write.csv(temp_GCMs,'temp_anom_f1r4.csv',row.names = F)

# calculate temperature anomaly
total %>% summarise(tmax = mean(anom_tmax),
                    tmin = mean(anom_tmin),
                    tmean = mean(anom_tmean))
