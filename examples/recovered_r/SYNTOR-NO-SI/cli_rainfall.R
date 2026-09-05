# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-NO-SI\cli_rainfall.R
# Source SHA256: A04B7152C40542C890640A63622B7B9276BBB42E2A027882D91F3406584EF18D
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

#rain_sheet_name_f2r8 <- dir('<LOCAL_PATH_REDACTED>')
rain_sheet_name_pres<- dir('<LOCAL_PATH_REDACTED>')

#dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_pres
length(dt)
rainfall<- NULL
rainfall <- dt
rainfall

# only read precipitation, maximum temperature, and minimum temperature from the corresponding excel files
for (i in 1:length(rainfall)){
  rainfall[[i]] <- as.data.frame(rainfall[[i]])
  rainfall[[i]] <- rainfall[[i]][,c(1,2,3,4)]  
  colnames(rainfall[[i]]) <- c('day','mon','year','prcp')
}

str(rainfall)
rainfall <- as.data.frame(rainfall)
head(rainfall)
colnames(rainfall) <- c('day','mon','year','prcp')
rainfall$year <- as.character(rainfall$year)

rain_median_pres <- rainfall %>% filter(prcp >= 0.25) %>% summarise(rain_median = median(prcp,na.rm = T)) 
rain_90_pres <- rainfall %>% filter(prcp >= 0.25) %>% summarise(rain_90 = quantile(prcp,probs=0.90,na.rm=TRUE)) 
rain_95_pres <- rainfall %>% filter(prcp >= 0.25) %>% summarise(rain_95 = quantile(prcp,probs=0.95,na.rm=TRUE)) 
rain_99_pres <- rainfall %>% filter(prcp >= 0.25) %>% summarise(rain_99 = quantile(prcp,probs=0.99,na.rm=TRUE)) 
rain_999_pres <- rainfall %>% filter(prcp >= 0.25) %>% summarise(rain_999 = quantile(prcp,probs=0.999,na.rm=TRUE)) 
rain_mean_pres <- rainfall %>% filter(prcp >= 0.25) %>% summarise(rain_mean = mean(prcp,na.rm=TRUE)) 
rain_sd_pres <- rainfall %>% filter(prcp >= 0.25) %>% summarise(rain_sd = sd(prcp,na.rm=TRUE)) 

mean(rain_sd_pres$rain_sd)

# calculate F1R4 precipitation at percentiles
rain_sheet_name_f1r4 <- dir('<LOCAL_PATH_REDACTED>')
dt_f1r4 <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)

names(dt_f1r4) <- rain_sheet_name_f1r4
length(dt_f1r4)
rainfall_f1r4 <- dt_f1r4 
rainfall_f1r4 

for (i in 1:length(rainfall_f1r4)){
  rainfall_f1r4[[i]] <- rainfall_f1r4[[i]][,c(1,2,3,4)]  
}
rainfall_f1r4
stat_f1r4 <- NULL

for (i in 1:length(rainfall_f1r4)){
  colnames(rainfall_f1r4[[i]]) <- c('day','mon','year','prcp')
  rainfall_f1r4[[i]] <- as.data.frame(rainfall_f1r4[[i]])
  rainfall_f1r4[[i]]$year <- as.character(rainfall_f1r4[[i]]$year)
  rainfall_f1r4[[i]] %>% filter(prcp >= 0.25) %>% 
    summarise(rain_med = median(prcp,na.rm=T),
              rain_90 = quantile(prcp,probs=0.90,na.rm=TRUE),
              rain_95 = quantile(prcp,probs=0.95,na.rm=TRUE),
              rain_99 = quantile(prcp,probs=0.99,na.rm=TRUE),
              rain_999 = quantile(prcp,probs=0.999,na.rm=TRUE),
              rain_mean = mean(prcp,na.rm=TRUE),
              rain_sd = sd(prcp,na.rm=TRUE),)-> stat_f1r4[[i]]
}

stat_f1r4
df_f1r4_med <- NULL
df_f1r4_90 <- NULL
df_f1r4_95 <- NULL
df_f1r4_99 <- NULL
df_f1r4_999 <- NULL
df_f1r4_mean <- NULL
df_f1r4_sd <- NULL

for (i in 1:length(stat_f1r4)){
  df_f1r4_med <- rbind(df_f1r4_med,stat_f1r4[[i]][,1])
  df_f1r4_90 <- rbind(df_f1r4_90,stat_f1r4[[i]][,2])
  df_f1r4_95 <- rbind(df_f1r4_95,stat_f1r4[[i]][,3])
  df_f1r4_99 <- rbind(df_f1r4_99,stat_f1r4[[i]][,4])
  df_f1r4_999 <- rbind(df_f1r4_999,stat_f1r4[[i]][,5])
  df_f1r4_mean <- rbind(df_f1r4_mean,stat_f1r4[[i]][,6])
  df_f1r4_sd <- rbind(df_f1r4_sd,stat_f1r4[[i]][,7])
}

colnames(df_f1r4_med) <- c('Median')
colnames(df_f1r4_90) <- c('90th')
colnames(df_f1r4_95) <- c('95th')
colnames(df_f1r4_99) <- c('99th')
colnames(df_f1r4_999) <- c('999th')
colnames(df_f1r4_mean) <- c('Mean')
colnames(df_f1r4_sd) <- c('SD')

mean(df_f1r4_med)
mean(df_f1r4_90) 
mean(df_f1r4_95)
mean(df_f1r4_99) 
mean(df_f1r4_999) 
mean(df_f1r4_mean) 
mean(df_f1r4_sd) 


t.test(mu=5.8,df_f1r4_med,alternative = 'two.sided')
t.test(mu=28.7,df_f1r4_90,alternative = 'two.sided')
t.test(mu=41.9,df_f1r4_95,alternative = 'two.sided')
t.test(mu=76.89,df_f1r4_99,alternative = 'two.sided')
t.test(mu=151.15,df_f1r4_999,alternative = 'two.sided')
t.test(mu=11.55,df_f1r4_mean,alternative = 'two.sided')
t.test(mu=16.08,df_f1r4_sd,alternative = 'two.sided')


# monthly precipitation one sample t.test baseline values
rain_pres1 <- rainfall
rain_pres1$days <- 1:36525
rain_pres1 %>% select(days,prcp) -> rain_pres1
typeof(rain_pres1)
str(rain_pres1)
rain_pres1 <- as.data.frame(rain_pres1)
rain_pres1_median <- rain_pres1 %>% filter(.$prcp >= 0.25) %>% {median(.$prcp)}
rain_pres1_90 <- rain_pres1 %>% filter(.$prcp >= 0.25) %>% {quantile(.$prcp,probs = 0.9)}
rain_pres1_95 <- rain_pres1 %>% filter(.$prcp >= 0.25) %>% {quantile(.$prcp,probs = 0.95)}
rain_pres1_99 <- rain_pres1 %>% filter(.$prcp >= 0.25) %>% {quantile(.$prcp,probs = 0.99)}
rain_pres1_999 <- rain_pres1 %>% filter(.$prcp >= 0.25) %>% {quantile(.$prcp,probs = 0.999)}
rain_pres1_mean <- rain_pres1 %>% filter(.$prcp >= 0.25) %>% {mean(.$prcp)}
rain_pres1_sd <- rain_pres1 %>% filter(.$prcp >= 0.25) %>% {sd(.$prcp)}


rain_f2r8<- data.frame(day=1:36525)

for (i in 1:length(rainfall)){
  rain_f2r8<- cbind(rain_f2r8, prcp =rainfall[[i]][,c(4)])
}
colnames(rain_f2r8) <- c('day',rain_sheet_name_f2r8)
head(rain_f2r8,50)
nrow(rain_f2r8)
ncol(rain_f2r8)

rain_f2r8%>% slice_head(n=10)


rain_f2r8%>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
  add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% 
  gather(BCC_BCCA_85_2.cli:NORESM_LOCA_85_2.cli,key = 'GCMs',value='precp') %>%
  group_by(year,GCMs) %>% summarise(ann_rain = sum(precp)) %>% spread(GCMs,ann_rain) -> r_f2r8   #%>% {colMeans(.)} 

write.csv(r_f2r8,'rain_f2r8.csv')
write.csv(rain_f2r8_100,'rain_f2r8_100.csv')

rain_pres%>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
  add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% 
  gather(SYNTOR_BASELINE.cli,key = 'GCMs',value='precp') %>%
  group_by(GCMs) %>% summarise(ann_rain = sum(precp)) %>% spread(GCMs,ann_rain) -> a_rain_f1r4

rain_pres_100 <- as.data.frame(rain_pres_100)
rain_f1r4_100 <- as.data.frame(rain_f1r4_100)
rain_f2r8_100 <- as.data.frame(rain_f2r8_100)
rain_f2r4_100 <- as.data.frame(rain_f2r4_100)
rain_f2r8_100 <- as.data.frame(rain_f2r8_100)

rain_pres_100$Climate <- c('Baseline')
rain_pres_100$GCMs <- c('SYNTOR')
colnames(rain_pres_100) <- c('year','Rainfall','Climate','GCMs')
rain_pres_100 <- rain_pres_100 %>% select(year,Climate,GCMs,Rainfall)

rain_f1r4_100$Climate <- c('F1R4.5')
rain_f1r8_100$Climate <- c('F1R8.5')
rain_f2r4_100$Climate <- c('F2R4.5')
rain_f2r8_100$Climate <- c('F2R8.5')

rain_f1r4_100 <- rain_f1r4_100 %>% gather(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli,key = 'GCMs',value='Rainfall')
rain_f1r8_100 <- rain_f1r8_100 %>% gather(BCC_BCCA_85_1.cli:NORESM_LOCA_85_1.cli,key = 'GCMs',value='Rainfall')
rain_f2r4_100 <- rain_f2r4_100 %>% gather(BCC_BCCA_45_2.cli:NORESM_LOCA_45_2.cli,key = 'GCMs',value='Rainfall')
rain_f2r8_100 <- rain_f2r8_100 %>% gather(BCC_BCCA_85_2.cli:NORESM_LOCA_85_2.cli,key = 'GCMs',value='Rainfall')

library(plyr)
rain100 <- NULL
rain100 <- rbind.fill(rain_pres_100,rain_f1r4_100,rain_f1r8_100,rain_f2r4_100,rain_f2r8_100)
str(rain100)
rain100$year <- as.character(rain100$year)

ggsave('AverageRainBoxplot.jpeg',device = 'jpeg', dpi = 300)
# finally plot average annual precipitation between baseline and future GCMs
rain100 %>% group_by(Climate,GCMs) %>% summarise(Avg_ann_precp= mean(Rainfall,na.rm = T)) %>%
  ggplot(aes(x=Climate,y=Avg_ann_precp)) + stat_boxplot(aes(group=Climate,color=Climate),geom = 'errorbar',width =0.35,show.legend = T) + 
  geom_boxplot(aes(color=Climate),width = 0.55) + 
  geom_jitter(alpha = 0.1,outlier.color = NA) +
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(450,900,50),
                     limits = c(450,900)) +
  theme_agile(plot_grid = T) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.96,0.96),
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_rect(),
         panel.grid.major.x = element_line(size = 0.5, linetype = 'solid',
                                         color = "white"), 
         panel.grid.minor.x = element_line(size = 0.25, linetype = 'solid',
                                         color = "white")
  )

ggsave('violin_trim_alpha.jpeg',device = 'jpeg',dpi=300)

# plotting violin plot for baseline and GCMs precipitation
rain100 %>% group_by(Climate,GCMs) %>% summarise(Avg_ann_precp= median(Rainfall,na.rm = T)) %>%
  ggplot(aes(x=Climate,y=Avg_ann_precp)) + #stat_boxplot(aes(group=Climate,color=Climate),geom = 'errorbar',width =0.35,show.legend = T) + 
  geom_violin(aes(color=Climate),draw_quantiles = NULL,trim = T,alpha=0.2) +
  geom_boxplot(aes(color=Climate),width = 0.1) + 
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(450,900,50),
                     limits = c(450,900)) +
  coord_flip() +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(1,0),
         legend.justification = c(1,0),
         legend.text = element_text(size=20),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major.x = element_line(size = 0.5, linetype = 'solid',
                                           color = "white"), 
         panel.grid.minor.x = element_line(size = 0.25, linetype = 'solid',
                                           color = "white")
  )

write.csv(rain100,'rain100.csv')

dev.off()
rain100 %>% group_by(Climate,GCMs) %>% summarise(Avg_ann_precp= median(Rainfall,na.rm = T),
                                                 n = n())


# plot average annual precipitation between baseline and future GCMs
rain100 %>% ggplot(aes(x=Climate,y=Rainfall)) + stat_boxplot(aes(group=Climate),geom = 'errorbar',width =0.35) + 
  geom_boxplot() + 
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(100,1300,100)) +
  theme_agile(plot_grid = T) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )


# significant test and analysis of 100-year annual rainfall series 
p.value <- NULL
p.value <- list()
df <- data.frame()
for (i in 2:26) {
  p.value[[i]] <- round(t.test(rain_pres_100[,2],rain_f2r8_100[,i,drop=T],
                               alternative = 'two.sided',conf.level = 0.999,paired = TRUE)$p.value,3)
}
names(p.value) <- c('Null',rain_sheet_name_f2r8)
p.value

for (i in 2:26) {
  temp.df <- data.frame(p.value = p.value[[i]],name = names(p.value[i]))
  df <- rbind(df,temp.df)
}

df %>% mutate(sig = ifelse(p.value <= 0.001,1,0)) -> df
df
write.csv(df,'sig_f2r8_999.csv')


annual_rain <- cbind(pres= rain_pres_100$SYNTOR_BASELINE.cli,f1r4 = a_rain_f1r4,f1r8 = a_rain_f1r8,f2r4 = a_rain_f2r4,f2r8=a_rain_f2r8)
annual_rain <- as.data.frame(annual_rain)
annual_rain

write.csv(annual_rain,'annual_rainfall.csv')


rain_f2r8 %>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
  add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% 
  gather(BCC_BCCA_85_2.cli:NORESM_LOCA_85_2.cli,key = 'GCMs',value='precp') %>%
  group_by(mon,GCMs) %>% summarise(mon_rain = sum(precp)/100) 


rain_pres$climate <- c('Baseline')
rain_f2r8$climate <- c('f2r8.5')
rain_f2r8$climate <- c('f2r8.5')
rain_f2r8$climate <- c('f2r8.5')
rain_f2r8$climate <- c('f2r8.5')

rain_pres <- as.data.frame(rain_pres)
rain_f1r4 <- as.data.frame(rain_f1r4)
rain_f1r8 <- as.data.frame(rain_f1r8)
rain_f2r4 <- as.data.frame(rain_f2r4)
rain_f2r8 <- as.data.frame(rain_f2r8)

rain_f2r8<- rain_f2r8 %>% select(mon,GCMs,mon_rain,climate)

head(rain_f2r8,12)
sum(rain_pres$mon_rain)
rain_f2r8 %>% group_by(mon) %>% 

rain <- rbind(rain_pres,rain_f2r8,rain_f2r8,rain_f2r8,rain_f2r8)
nrow(rain)
tail(rain)

# load a monthly rain from a csv file
rain.csv <- read.csv('monthly_rain.csv',header = T)
rain.csv$X <- NULL
rain <- rain.csv
nrow(rain)

rain %>% add_column(month = month.abb[.$mon],.after = 0) %>%
  group_by(climate) %>% 
  summarise(avg_rain = mean(mon_rain)) %>% 
  ggplot(aes(x=factor(month,levels = month.abb,ordered = T),y= avg_rain,fill=climate)) + 
  stat_summary(aes(group=climate),geom = 'bar',position = 'dodge') + theme_bw()

ggsave(filename = 'monthly precpitation with error bar.jpeg',device = jpeg,dpi=300)
# plotting a comparison of monthly precipitation between baseline and future scenarios
rain %>% 
  add_column(month = month.abb[.$mon],.after = 1) %>% 
  ggplot(aes(x= factor(month,levels = month.abb,ordered = T),y = mon_rain,fill=climate)) + 
  # stat_boxplot(aes(group=month),geom = 'errorbar',width=0.3,position='dodge') +
  # stat_boxplot(aes(group=month),width=0.5,position='dodge') +
  stat_summary(aes(group=climate,pattern=climate,pattern_angle = climate),
               fill = 'white',color = 'black',pattern_spacing = 0.01,pattern_color = 'black',
               geom ='bar_pattern',fun.y = mean, position = 'dodge',color='black',alpha=0.4) +
  stat_summary(aes(group=climate),geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  scale_y_continuous(expand = c(0,0),
                     breaks = c(0,20,40,60,80,100,120,140)) +
  coord_cartesian(ylim = c(0,140)) +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )


head(rain)
tail(rain)

ggsave('MonthPrecp.jpeg',device = 'jpeg',dpi = 300)
# finally plotting mean monthly precipitation with standard error
rain %>% 
  add_column(month = month.abb[.$mon],.after = 1) %>% 
  ggplot(aes(x= factor(month,levels = month.abb,ordered = T),y = mon_rain,fill=climate)) + 
  stat_summary(aes(group=climate),
               geom ='bar',fun.y = mean, position = 'dodge',color='grey20',alpha=0.4) +
  stat_summary(aes(group=climate),geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  scale_y_continuous(expand = c(0,0),
                     breaks = c(0,20,40,60,80,100,120,140)) +
  coord_cartesian(ylim = c(0,140)) +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=12),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank()
  )

write.csv(rain,file = 'monthly_rain.csv')
dev.off()

# grouped by GCMs to reflect the variation of GCMs in the future 100 year
rain %>% group_by(climate,GCMs) %>% mutate(avg_rain = mean(mon_rain),
                                           n=n())
syntor_rain <- rain%>% filter(GCMs == 'SYNTOR_baseline')
syntor_rain <- syntor_rain %>% add_column(month = month.abb[.$mon],.after = 1)

GCMs_rain <- rain %>% filter(!(GCMs == 'SYNTOR_baseline'))

GCMs_rain %>% group_by(mon,climate) %>% mutate(avg_rain = mean(mon_rain),
                                               n=n()) %>%
  add_column(month = month.abb[.$mon],.after = 1) %>% 
  ggplot(aes(x= factor(month,levels = month.abb,ordered = T),y = mon_rain,fill=climate)) + 
  stat_summary(aes(group=climate),
               geom ='bar',fun.y = mean, position = 'dodge',color='grey20',alpha=0.4) +
  stat_summary(aes(group=climate),geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  stat_summary(data=syntor_rain,aes(x=factor(month,levels = month.abb,ordered = T),y=mon_rain),position = position_dodge(width = 0.9),geom = 'bar',alpha=0,color='red') +
  scale_y_continuous(expand = c(0,0),
                     breaks = c(0,20,40,60,80,100,120,140)) +
  coord_cartesian(ylim = c(0,140)) +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=12),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank()
  )


# t.test for significant change of monthly precipitation
rain %>% group_by(climate,mon) %>% summarise(avg_mon = mean(mon_rain))%>%
  spread(mon,avg_mon) -> a
a <- as.matrix(a)
a <- t(a)
a
colnames(a) <- c('Baseline','F1R4','F1R8','F2R4','F2R8')
a <- as.data.frame(a)
a %>% slice(2:13) -> a
a$Baseline <- as.numeric(as.character(a$Baseline))
a$F1R4 <- as.numeric(as.character(a$F1R4))
a$F1R8 <- as.numeric(as.character(a$F1R8))
a$F2R4 <- as.numeric(as.character(a$F2R4))
a$F2R8 <- as.numeric(as.character(a$F2R8))
a
#write.csv(a,'monthlyprcp.csv')
#Figure 2 paired t.test for summer and winter half year
t.test(a$Baseline[c(1:4,11,12)],a$F2R8[c(1:4,11,12)],alternative = 'two.sided',paired = T)




Rain_future <- cbind(f2r8=Rain_f2r8[,3],f2r8=Rain_f2r8[,3],f2r8=Rain_f2r8[,3],f2r8=Rain_f2r8[,3])
colnames(Rain_future) <- c('f2r8.5','f2r8.5','f2r8.5','f2r8.5')
Rain_f2r8<- as.data.frame(Rain_pres)
Rain_all <- NULL
Rain_all <- cbind(Rain_pres,Rain_future)
colnames(Rain_all) <- c('Year','Month','Baseline','f2r8.5','f2r8.5','f2r8.5','f2r8.5')
head(Rain_all)
tail(Rain_all)
str(Rain_all)


# comparing baseline precp and future monthly precp
Rain_all %>% add_column(mon = month.abb[.$Month],.after = 1) %>% 
  group_by(mon) %>% 
  gather(F1R4.5:F2R8.5,key = 'GCMs',value='mon_rain') %>% 
  ggplot(aes(x= factor(mon,levels = month.abb,ordered = T),y=mon_rain,fill=GCMs)) +
  stat_summary(geom ='bar',fun.y = mean, position = 'dodge',color='black',alpha=0.4) +
  stat_summary(aes(y=mon_rain),geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  stat_summary(aes(y=Baseline,group=1,shape=''),geom='path',fun.y = mean, position = 'dodge',color='blue',size=1) +
  stat_summary(aes(y=Baseline),geom='point',fun.y = mean, position = 'dodge',size=3,shape=1) +
  #scale_shape_manual('Baseline',values = '') +
  scale_y_continuous(expand = c(0,0),
                     breaks = c(0,20,40,60,80,100,120)) +
  coord_cartesian(ylim = c(0,130)) +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )

# monthly precipitation for 5 emission scenarios
Rain_all %>% add_column(mon = month.abb[.$Month],.after = 1) %>% 
  group_by(mon) %>% 
  gather(Baseline:F2R8.5,key = 'GCMs',value='mon_rain') %>% 
  ggplot(aes(x= factor(mon,levels = month.abb,ordered = T),y=mon_rain,fill=GCMs)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(0,350)) +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )

# plotting the cumulative frequency distribution of 25 GCMs
# rain_f2r8 %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli)%>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
#   add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% gather(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli,key='GCMs',value='rainfall') %>%
#   group_by(year,mon) %>% 
#   summarise(mon_rain = sum(rainfall,na.rm = T)/25) %>% ggplot(aes(x= factor(as.character(mon),levels = c(1:12),ordered = T),y=mon_rain)) +
#   stat_summary(geom='bar',fun.y = mean, position = 'dodge',color = 'black',fill='white') +
#   stat_summary(geom = 'errorbar',fun.data = mean_se,position='dodge',width = 0.45) +
#   scale_fill_brewer(palette = 'OrRd') +
#   xlab('Month') + ylab('Monthly precipitation (mm)') +
#   theme_agile(plot_grid = F) +
#   theme( axis.title.x = element_text(size = 13),
#          axis.title.y = element_text(size = 13),
#          axis.text.x = element_text(size = 12,color='black'),
#          axis.text.y = element_text(size = 12,color='black'),
#          legend.title = element_blank(),
#          legend.direction = 'horizontal',
#          legend.position = c(0.98,0.98),
#          legend.justification = c(1,1),
#          legend.text = element_text(size=10),
#          legend.background = element_blank(),
#          axis.line = element_line(color='black'),
#          panel.background = element_blank()
#   )



Rain_all %>% group_by(Month) %>% gather(Baseline:F2R8.5,key = 'GCMs',value = 'mon_rain') %>% 
  ggplot(aes(x= factor(as.character(Month),levels = c(1:12),ordered = T),y=mon_rain,color=GCMs,fill=GCMs)) +
  stat_summary(geom='bar',fun.y = mean, position = 'dodge',color='black') +
  stat_summary(geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  scale_fill_aaas() +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )

# load rain distribution data from .csv
rain_dist <- read.csv('rain_distr.csv')

colnames(rain_dist) <- c('climate','median','90','95','99',
                         '99.9','mean','sd')

rain_dist %>% gather(median:sd,key='stats',value='value') %>%
  ggplot(aes(x=stats,y=value,group=climate)) +
  geom_col(aes(x=reorder(stats,-value),fill=climate),position = 'dodge',color='black',alpha =0.5)+
  theme_bw()


# load percent change of rainfall 
rain_percent <- read.csv('PercentChange.csv')
rain_percent
colnames(rain_percent) <- c('Model','Climate','Method',
                            'Jan','Feb','Mar',
                            'Apr','May','Jun',
                            'Jul','Aug','Sep',
                            'Oct','Nov','Dec')

ggsave('Rain_Percent_Change.jpeg',device = 'jpeg',dpi=300)
# finally plot the change plot of precipitation
rain_percent %>% gather(Jan:Dec,key = 'Month',value='Change') %>%
  ggplot(aes(x=factor(Month,levels=month.abb,ordered = T),y=Change,fill=factor(Month,levels=month.abb,ordered = T))) +
  geom_boxplot(alpha=0.5) +
  xlab('Month') + ylab(expression(paste('> ',95^{th},'percentile in daily precipitation (%)'))) +
  scale_fill_discrete() +
  facet_wrap(Climate~.) +
  theme_bw() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.text = element_text(size=16),
         panel.background = element_blank()
  )
