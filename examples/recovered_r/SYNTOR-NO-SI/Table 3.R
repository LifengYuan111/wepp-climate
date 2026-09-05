# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-NO-SI\Table 3.R
# Source SHA256: 75F3779C296F189030F11FAB2E977D012B253D0AE0E3C93B7FC731D55CC87200
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
rain_sheet_name_f1r4<- dir('<LOCAL_PATH_REDACTED>')
dt_f1r4 <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt_f1r4) <- rain_sheet_name_f1r4
dt_f1r4
cli_f1r4 <- dt_f1r4
head(cli_f1r4)
cli_f1r4 <- lapply(cli_f1r4,function(x) cli_f1r4 = x[c(1:4,8,9)])
for (i in 1:length(cli_f1r4)){
  colnames(cli_f1r4[[i]]) <- c('day','mon','year','prcp','tmax','tmin')
}
head(cli_f1r4)

data <- list()
temp <- list()
total <- data.frame()
for (i in 1:25) {
  cli_f1r4[[i]] %>% add_column(date = seq(as.Date('2021/01/01'),as.Date('2121/01/01'),'days'),.after = 0) %>% 
    mutate(month = month(date,label = T),
           new_year = year(date)) %>% group_by(new_year,month) %>% summarise(avg_mon_tmax = mean(tmax,na.rm = T),
                                                                             avg_mon_tmin = mean(tmin,na.rm = T)) -> data[[i]]
  data[[i]]%>% left_join(data_ref,by='month') %>% mutate(Date = str_c(new_year,as.numeric(month),1,sep = '-') %>% ymd(),
                                                         tmax_anom = avg_mon_tmax - ref_tmax,
                                                         tmin_anom = avg_mon_tmin - ref_tmin,
                                                         flag_tmax = ifelse(tmax_anom > 0,'positive','negative'),
                                                         flag_tmin = ifelse(tmin_anom >0, 'positive','negative')) -> data[[i]]
  data[[i]] %>% group_by(new_year) %>% summarise(anom_max = mean(tmax_anom),
                                                 anom_min = mean(tmin_anom)) %>% summarise(anom_tmax = mean(anom_max),
                                                                                           anom_tmin = mean(anom_min)) -> temp[[i]]
  
  total <- rbind(total, temp[[i]])
}
total

total %>% summarise(tmax = mean(anom_tmax),
                    tmin = mean(anom_tmin))
t.test(mu=0,total$anom_tmax,alternative = 'two.sided')
t.test(mu=0,total$anom_tmin,alternative = 'two.sided')
