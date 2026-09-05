# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-NO-SI\Table2.R
# Source SHA256: 7ACB563E050F6CF074300599C91DA17380A86210598E1AB68EE8450CFF03671A
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
# calculate f2r8 precipitation at percentiles
rain_sheet_name_f2r8 <- dir('<LOCAL_PATH_REDACTED>')
dt_f2r8 <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)

names(dt_f2r8) <- rain_sheet_name_f2r8
length(dt_f2r8)
rainfall_f2r8 <- dt_f2r8 
rainfall_f2r8 

for (i in 1:length(rainfall_f2r8)){
  rainfall_f2r8[[i]] <- rainfall_f2r8[[i]][,c(1,2,3,4)]  
}
rainfall_f2r8
stat_f2r8 <- NULL

for (i in 1:length(rainfall_f2r8)){
  colnames(rainfall_f2r8[[i]]) <- c('day','mon','year','prcp')
  rainfall_f2r8[[i]] <- as.data.frame(rainfall_f2r8[[i]])
  rainfall_f2r8[[i]]$year <- as.character(rainfall_f2r8[[i]]$year)
  rainfall_f2r8[[i]] %>% filter(prcp >= 0.25) %>% 
    summarise(rain_med = median(prcp,na.rm=T),
              rain_90 = quantile(prcp,probs=0.90,na.rm=TRUE),
              rain_95 = quantile(prcp,probs=0.95,na.rm=TRUE),
              rain_99 = quantile(prcp,probs=0.99,na.rm=TRUE),
              rain_999 = quantile(prcp,probs=0.999,na.rm=TRUE),
              rain_mean = mean(prcp,na.rm=TRUE),
              rain_sd = sd(prcp,na.rm=TRUE),)-> stat_f2r8[[i]]
}

stat_f2r8
df_f2r8_med <- NULL
df_f2r8_90 <- NULL
df_f2r8_95 <- NULL
df_f2r8_99 <- NULL
df_f2r8_999 <- NULL
df_f2r8_mean <- NULL
df_f2r8_sd <- NULL

for (i in 1:length(stat_f2r8)){
  df_f2r8_med <- rbind(df_f2r8_med,stat_f2r8[[i]][,1])
  df_f2r8_90 <- rbind(df_f2r8_90,stat_f2r8[[i]][,2])
  df_f2r8_95 <- rbind(df_f2r8_95,stat_f2r8[[i]][,3])
  df_f2r8_99 <- rbind(df_f2r8_99,stat_f2r8[[i]][,4])
  df_f2r8_999 <- rbind(df_f2r8_999,stat_f2r8[[i]][,5])
  df_f2r8_mean <- rbind(df_f2r8_mean,stat_f2r8[[i]][,6])
  df_f2r8_sd <- rbind(df_f2r8_sd,stat_f2r8[[i]][,7])
}

colnames(df_f2r8_med) <- c('Median')
colnames(df_f2r8_90) <- c('90th')
colnames(df_f2r8_95) <- c('95th')
colnames(df_f2r8_99) <- c('99th')
colnames(df_f2r8_999) <- c('999th')
colnames(df_f2r8_mean) <- c('Mean')
colnames(df_f2r8_sd) <- c('SD')

mean(df_f2r8_med)
mean(df_f2r8_90) 
mean(df_f2r8_95)
mean(df_f2r8_99) 
mean(df_f2r8_999) 
mean(df_f2r8_mean) 
mean(df_f2r8_sd) 


t.test(mu=5.8,df_f2r8_med,alternative = 'two.sided')
t.test(mu=28.7,df_f2r8_90,alternative = 'two.sided')
t.test(mu=41.9,df_f2r8_95,alternative = 'two.sided')
t.test(mu=76.89,df_f2r8_99,alternative = 'two.sided')
t.test(mu=151.15,df_f2r8_999,alternative = 'two.sided')
t.test(mu=11.55,df_f2r8_mean,alternative = 'two.sided')
t.test(mu=16.08,df_f2r8_sd,alternative = 'two.sided')
