# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-SI\cli_rainfal.R
# Source SHA256: 468E43182151F87D89DFED2D900FA14E897454CE4E95CD8ED985362201EAC651
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================

#rain_sheet_name_f2r8 <- dir('<LOCAL_PATH_REDACTED>')
rain_sheet_name_pres<- dir('<LOCAL_PATH_REDACTED>')

#dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_pres
length(dt)
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

rain_median_pres <- rainfall %>% group_by(year) %>% filter(prcp >= 0.25) %>% summarise(rain_median = median(prcp,na.rm = T)) 
rain_90_pres <- rainfall %>% group_by(year) %>% filter(prcp >= 0.25) %>% summarise(rain_90 = quantile(prcp,probs=0.90,na.rm=TRUE)) 
rain_95_pres <- rainfall %>% group_by(year) %>% filter(prcp >= 0.25) %>% summarise(rain_95 = quantile(prcp,probs=0.95,na.rm=TRUE)) 
rain_99_pres <- rainfall %>% group_by(year) %>% filter(prcp >= 0.25) %>% summarise(rain_99 = quantile(prcp,probs=0.99,na.rm=TRUE)) 
rain_999_pres <- rainfall %>% group_by(year) %>% filter(prcp >= 0.25) %>% summarise(rain_999 = quantile(prcp,probs=0.999,na.rm=TRUE)) 
rain_mean_pres <- rainfall %>% group_by(year) %>% filter(prcp >= 0.25) %>% summarise(rain_mean = mean(prcp,na.rm=TRUE)) 
rain_sd_pres <- rainfall %>% group_by(year) %>% filter(prcp >= 0.25) %>% summarise(rain_sd = sd(prcp,na.rm=TRUE)) 


rain_sheet_name_f1r4 <- dir('<LOCAL_PATH_REDACTED>')
dt_f1r4 <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)

names(dt_f1r4) <- rain_sheet_name_f1r4
length(dt_f1r4)
rainfall_f1r4 <- dt_f1r4 
rainfall_f1r4 

for (i in 1:length(rainfall_f1r4)){
  rainfall_f1r4[[i]] <- rainfall_f1r4[[i]][,c(1,2,3,4)]  
}

stat_f1r4 <- NULL

for (i in 1:length(rainfall_f1r4)){
  colnames(rainfall_f1r4[[i]]) <- c('day','mon','year','prcp')
  rainfall_f1r4[[i]] <- as.data.frame(rainfall_f1r4[[i]])
  rainfall_f1r4[[i]]$year <- as.character(rainfall_f1r4[[i]]$year)
  rainfall_f1r4[[i]] %>% group_by(year) %>% filter(prcp >= 0.25) %>% 
    summarise(rain_med = median(prcp,na.rm=T),
              rain_90 = quantile(prcp,probs=0.90,na.rm=TRUE),
              rain_95 = quantile(prcp,probs=0.95,na.rm=TRUE),
              rain_99 = quantile(prcp,probs=0.99,na.rm=TRUE),
              rain_999 = quantile(prcp,probs=0.999,na.rm=TRUE),
              rain_mean = mean(prcp,na.rm=TRUE),
              rain_sd = sd(prcp,na.rm=TRUE),)->stat_f1r4[[i]]
}

df_f1r4_med <- data.frame(1:100)
df_f1r4_90 <- data.frame(1:100)
df_f1r4_95 <- data.frame(1:100)
df_f1r4_99 <- data.frame(1:100)
df_f1r4_999 <- data.frame(1:100)
df_f1r4_mean <- data.frame(1:100)
df_f1r4_sd <- data.frame(1:100)
for (i in 1:length(stat_f1r4)){
  df_f1r4_med <- cbind(df_f1r4_med,stat_f1r4[[i]][,2])
  df_f1r4_90 <- cbind(df_f1r4_90,stat_f1r4[[i]][,3])
  df_f1r4_95 <- cbind(df_f1r4_95,stat_f1r4[[i]][,4])
  df_f1r4_99 <- cbind(df_f1r4_99,stat_f1r4[[i]][,5])
  df_f1r4_999 <- cbind(df_f1r4_999,stat_f1r4[[i]][,6])
  df_f1r4_mean <- cbind(df_f1r4_mean,stat_f1r4[[i]][,7])
  df_f1r4_sd <- cbind(df_f1r4_sd,stat_f1r4[[i]][,8])
}

colnames(df_f1r4_med) <- c('No',rain_sheet_name_f1r4)
colnames(df_f1r4_90) <- c('No',rain_sheet_name_f1r4)
colnames(df_f1r4_95) <- c('No',rain_sheet_name_f1r4)
colnames(df_f1r4_99) <- c('No',rain_sheet_name_f1r4)
colnames(df_f1r4_999) <- c('No',rain_sheet_name_f1r4)
colnames(df_f1r4_mean) <- c('No',rain_sheet_name_f1r4)
colnames(df_f1r4_sd) <- c('No',rain_sheet_name_f1r4)

df_f1r4_med %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli) %>% 
  mutate(avg25=round(rowMeans(.),2)) -> df_f1r4_med
df_f1r4_90 %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli) %>% 
  mutate(avg25=round(rowMeans(.),2)) -> df_f1r4_90
df_f1r4_95 %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli) %>% 
  mutate(avg25=round(rowMeans(.),2)) -> df_f1r4_95
df_f1r4_99 %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli) %>% 
  mutate(avg25=round(rowMeans(.),2)) -> df_f1r4_99
df_f1r4_999 %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli) %>% 
  mutate(avg25=round(rowMeans(.),2)) -> df_f1r4_999
df_f1r4_mean %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli) %>% 
  mutate(avg25=round(rowMeans(.),2)) -> df_f1r4_mean
df_f1r4_sd %>% select(BCC_BCCA_45_1.cli:NORESM_LOCA_45_1.cli) %>% 
  mutate(avg25=round(rowMeans(.),2)) -> df_f1r4_sd

t.test(rain_median_pres$rain_median,df_f1r4_med$avg25,alternative = 'two.sided')
t.test(rain_90_pres$rain_90,df_f1r4_90$avg25,alternative = 'two.sided')
t.test(rain_95_pres$rain_95,df_f1r4_95$avg25,alternative = 'two.sided')
t.test(rain_99_pres$rain_99,df_f1r4_99$avg25,alternative = 'two.sided')
t.test(rain_999_pres$rain_999,df_f1r4_999$avg25,alternative = 'two.sided')
t.test(rain_mean_pres$rain_mean,df_f1r4_mean$avg25,alternative = 'two.sided')
t.test(rain_sd_pres$rain_sd,df_f1r4_sd$avg25,alternative = 'two.sided')



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

# finally plotting violin plot for baseline and GCMs precipitation
rain100 %>% group_by(Climate,GCMs) %>% summarise(Avg_ann_precp= median(Rainfall,na.rm = T)) %>%
  ggplot(aes(x=Climate,y=Avg_ann_precp)) + #stat_boxplot(aes(group=Climate,color=Climate),geom = 'errorbar',width =0.35,show.legend = T) + 
  geom_violin(aes(color=Climate),draw_quantiles = NULL,trim = T,alpha=0.2) +
  geom_boxplot(aes(color=Climate),width = 0.1) + 
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(450,900,50),
                     limits = c(450,900)) +
  coord_flip() +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(1,0),
         legend.justification = c(1,0),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major.x = element_line(size = 0.5, linetype = 'solid',
                                           color = "white"), 
         panel.grid.minor.x = element_line(size = 0.25, linetype = 'solid',
                                           color = "white")
  )

ggsave('SF2S.tiff',device='tiff',dpi=300)

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
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=12),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank()
  )

#write.csv(rain,file = 'monthly_rain.csv')
ggsave('SF1S.tiff',device = 'tiff',dpi=300)
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
head(GCMs_rain)
tail(GCMs_rain)
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


library(ggsci)
Rain_all %>% group_by(Month) %>% gather(Baseline:F2R8.5,key = 'GCMs',value = 'mon_rain') %>% 
  ggplot(aes(x= factor(as.character(Month),levels = c(1:12),ordered = T),y=mon_rain,color=GCMs,fill=GCMs)) +
  stat_summary(geom='bar',fun.y = mean, position = 'dodge',color='black') +
  stat_summary(geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  scale_fill_discrete() +
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


3ggsave('Rain_Percent_Change.jpeg',device = 'jpeg',dpi=300)
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


#*******************************************************
#*******************************************************
# load required library
library(tidyverse)
library(ggthemes)
library(ggsci)
library(reshape2)
library(lubridate)


getwd()
# load the observed precipitation from Weatherfort station (1950-2019)
obs_rain <- read.csv('Weatherford_OBS_Daily_Weather_1950-2019.csv',header = T,stringsAsFactors = T)
head(obs_rain)
colnames(obs_rain) <- c('Year','Month','Day','Tmax','Tmin','Precp')
str(obs_rain)
obs_rain %>% select(Year,Month,Day,Precp) -> obs_rain
obs_rain$Climate <- c('Observed')
head(obs_rain)
tail(obs_rain)

obs_rain025 <- obs_rain %>% filter(Precp > 0.25)
RainQu(obs_rain025$Precp)
quantile(obs_rain025$Precp,c(0.05,0.1,0.25,0.5,0.75,0.9,0.95,0.99,0.999),getOption("digits") - 3)
mean(obs_rain025$Precp)
sd(obs_rain025$Precp)
getOption("digits")
options(digits = 10)
# build the baseline daily precipitation data
base_rain <- rain_pres_daily %>% select(year,mon,day,precp)
colnames(base_rain) <- c('year','Month','Day','Precp')
base_rain$Climate <- c('Baseline')
head(base_rain)
tail(base_rain)
nrow(base_rain)
library(lubridate)
base_rain %>% add_column(Date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),
                         Year = year(Date)) %>% select(Year,Month,Day,Precp,Climate) %>%
  filter(Year >= 1950 & Year <= 2019)-> base_rain

Obs_base_rain <- rbind(obs_rain,base_rain)
head(Obs_base_rain)
tail(Obs_base_rain)

#making a daily precipitation data set for baseline
rain_sheet_name_pres<- dir('<LOCAL_PATH_REDACTED>')
dt<- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
rainfall <- dt
rainfall <- rainfall[[1]][1:4]
rainfall$GCMs <- c('SYNTOR')
rainfall$Climate <- c('SYNTOR_Baseline')
rain_pres_daily <- rainfall
colnames(rain_pres_daily)<-c('day','mon','year','precp','GCMs','Climate')
rain_pres_daily
#calculate average annual precipitation in baseline
rain_pres_daily %>% group_by(year) %>% summarise(annrain = sum(precp)) %>%
  summarise(ave_ann_rain = mean(annrain),
            med_ann_rain = median(annrain),
            sd_ann_rain = sd(annrain))

#calculate 100-year annual precipitation 
rain_pres_daily %>% group_by(year) %>% summarise(ann_rain = round(sum(precp),0))->rain_pres_100
rain_pres_100


#load future precipitation data  - f1r4.5
rain_sheet_name_f1r4 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f1r4
length(dt)
rainfall <- dt
rainfall

#making a daily precipitation data set 
rain_f1r4_daily <- data.frame()
for (i in 1:length(rainfall)) {
  rainfall[[i]] <- rainfall[[i]][,1:4]
  colnames(rainfall[[i]]) <- c('day','mon','year','precp')
  rainfall[[i]] <- rainfall[[i]]%>% add_column(names(rainfall[i]),.after = 4)
  rain_f1r4_daily <- rbind(rain_f1r4_daily,rainfall[[i]])
}

#load future precipitation data  - f1r8.5
rain_sheet_name_f1r8 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f1r8
length(dt)
rainfall <- dt
rainfall

#making a daily precipitation data set 
rain_f1r8_daily <- data.frame()
for (i in 1:length(rainfall)) {
  rainfall[[i]] <- rainfall[[i]][,1:4]
  colnames(rainfall[[i]]) <- c('day','mon','year','precp')
  rainfall[[i]] <- rainfall[[i]]%>% add_column(names(rainfall[i]),.after = 4)
  rain_f1r8_daily <- rbind(rain_f1r8_daily,rainfall[[i]])
}

#load future precipitation data  - f2r4.5
rain_sheet_name_f2r4 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f2r4
length(dt)
rainfall <- dt
rainfall

#making a daily precipitation data set 
rain_f2r4_daily <- data.frame()
for (i in 1:length(rainfall)) {
  rainfall[[i]] <- rainfall[[i]][,1:4]
  colnames(rainfall[[i]]) <- c('day','mon','year','precp')
  rainfall[[i]] <- rainfall[[i]]%>% add_column(names(rainfall[i]),.after = 4)
  rain_f2r4_daily <- rbind(rain_f2r4_daily,rainfall[[i]])
}

#load future precipitation data  - f2r8.5
rain_sheet_name_f2r8 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f2r8
length(dt)
rainfall <- dt
rainfall

#making a daily precipitation data set 
rain_f2r8_daily <- data.frame()
for (i in 1:length(rainfall)) {
  rainfall[[i]] <- rainfall[[i]][,1:4]
  colnames(rainfall[[i]]) <- c('day','mon','year','precp')
  rainfall[[i]] <- rainfall[[i]]%>% add_column(names(rainfall[i]),.after = 4)
  rain_f2r8_daily <- rbind(rain_f2r8_daily,rainfall[[i]])
}

# add Climate column and rename all fields
rain_f1r4_daily$Climate <- c('F1R4.5')
colnames(rain_f1r4_daily)<-c('day','mon','year','precp','GCMs','Climate')

rain_f1r8_daily$Climate <- c('F1R8.5')
colnames(rain_f1r8_daily)<-c('day','mon','year','precp','GCMs','Climate')

rain_f2r4_daily$Climate <- c('F2R4.5')
colnames(rain_f2r4_daily)<-c('day','mon','year','precp','GCMs','Climate')

rain_f2r8_daily$Climate <- c('F2R8.5')
colnames(rain_f2r8_daily)<-c('day','mon','year','precp','GCMs','Climate')

# calculate average annual precipitation for each GCM during each scenario 

rain_f1r4_daily %>% group_by(GCMs,year) %>% summarise(ann_rain = sum(precp)) %>%
  summarise(rain = mean(ann_rain)) -> AnnRain_25GCM_f1r4
write.csv(AnnRain_25GCM_f1r4,'AnnRain_25GCM_f1r4.csv')

rain_f1r8_daily %>% group_by(GCMs,year) %>% summarise(ann_rain = sum(precp)) %>%
  summarise(rain = mean(ann_rain)) -> AnnRain_25GCM_f1r8
write.csv(AnnRain_25GCM_f1r8,'AnnRain_25GCM_f1r8.csv')

rain_f2r4_daily %>% group_by(GCMs,year) %>% summarise(ann_rain = sum(precp)) %>%
  summarise(rain = mean(ann_rain)) -> AnnRain_25GCM_f2r4
write.csv(AnnRain_25GCM_f2r4,'AnnRain_25GCM_f2r4.csv')

rain_f2r8_daily %>% group_by(GCMs,year) %>% summarise(ann_rain = sum(precp)) %>%
  summarise(rain = mean(ann_rain)) -> AnnRain_25GCM_f2r8
write.csv(AnnRain_25GCM_f2r8,'AnnRain_25GCM_f2r8.csv')

#making a daily precipitation data set for all emission scenarios
rain_daily <- NULL
rain_daily <- rbind(rain_pres_daily,rain_f1r4_daily,
                    rain_f1r8_daily,rain_f2r4_daily,
                    rain_f2r8_daily)
colnames(rain_daily) <- c('day','mon','year',
                          'precp','GCMs','Climate')

head(rain_daily)
tail(rain_daily)
rain_daily_25 <- rain_daily %>% filter(precp > 0.25)
nrow(rain_daily_25)
write.csv(rain_daily_25,'daily_precp_25GCM.csv',row.names = F)

rain_daily <- read.csv('daily_precp_25GCM.csv',header = T)
str(rain_daily)
rain_daily <- rain_daily[2:7]
is.data.frame(rain_daily)
rain_daily$Climate <- gsub('GPCC_Baseline','Baseline',rain_daily$Climate)
colnames(rain_daily)

#making annual precipitation during 1 to 100 simulated year
rain_daily %>% group_by(Climate,GCMs,year) %>% 
  summarise(ann_rain = sum(precp)) %>% filter(Climate == 'F1R4.5')  # The simplest way to calculate annual precipitation for each GCM and from 1 to 100 year

#calculate selected descriptive statistics and high percenties of daily rainfall
rain_daily%>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(median(.$precp),2)}
rain_daily%>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)}
rain_daily%>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.95),2)}
rain_daily%>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.99),2)}
rain_daily%>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.999),2)}
rain_daily%>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(mean(.$precp),2)}
rain_daily%>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(sd(.$precp),2)}

rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% {round(median(.$precp),2)}
rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)}
rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.95),2)}
rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.99),2)}
rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.999),2)}
rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% {round(mean(.$precp),2)}
rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% {round(sd(.$precp),2)}

rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% {round(median(.$precp),2)}
rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)}
rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.95),2)}
rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.99),2)}
rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.999),2)}
rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% {round(mean(.$precp),2)}
rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% {round(sd(.$precp),2)}

rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% {round(median(.$precp),2)}
rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)}
rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.95),2)}
rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.99),2)}
rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% {round(quantile(.$precp,0.999),2)}
rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% {round(mean(.$precp),2)}
rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% {round(sd(.$precp),2)}

rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% {round(median(.$precp),2)}
rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)}
rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.95),2)}
rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.99),2)}
rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% {round(quantile(.$precp,0.999),2)}
rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% {round(mean(.$precp),2)}
rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% {round(sd(.$precp),2)}


rain_base <- rain_daily%>% filter(Climate == 'Baseline',precp > 0.25)
RainQu(rain_base$precp)
newrain_f1r4 <-rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25)
RainQu(newrain_f1r4$precp)
newrain_f1r8 <-rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25)
RainQu(newrain_f1r8$precp)

t.test(mu= rain_daily %>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(median(.$precp),2)},
       rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = median(precp)) %>% {.$med},
       alternative = 'two.sided')

t.test(mu= rain_daily %>% filter(Climate == 'Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.90),2)},
       rain_daily %>% filter(Climate == 'F2R8.5',precp > 0.25) %>% group_by(GCMs) %>% summarise(p90 = quantile(precp,0.90)) %>% {.$p90},
       alternative = 'two.sided')


#plotting daily precipitation with selected descriptive statistics
wdp <- read.csv('Table1-descriptive statistics.csv',header = T)
wdp
colnames(wdp) <- c('Median','90%','95%','99%','99.9%','Mean','Standard deviation',
                   'Climate_scenarios')
wdp$Climate_scenarios <- factor(wdp$Climate_scenarios,ordered = T,
                                levels = c('Baseline (2005-2019)','RCP4.5 (2021-2050)',
                                           'RCP8.5 (2021-2050)','RCP4.5 (2051-2080)',
                                           'RCP8.5 (2051-2080)'))
str(wdp)
head(wdp)
wdp1 <- wdp %>% gather(Median:'Standard deviation',key = 'Statistics',value = Rain)
wdp1 %>% mutate(sig = case_when(
  Climate_scenarios == 'RCP8.5 (2051-2080)' & Rain == 3.80 ~ '***',
  Climate_scenarios == 'RCP8.5 (2051-2080)' & Rain == 48.5 ~ '***',
  Climate_scenarios == 'RCP8.5 (2051-2080)' & Rain == 95.2 ~ '***',
  Climate_scenarios == 'RCP8.5 (2051-2080)' & Rain == 182.68 ~ '***',
  Climate_scenarios == 'RCP4.5 (2051-2080)' & Rain == 90.4 ~ '***',
  Climate_scenarios == 'RCP4.5 (2051-2080)' & Rain == 174.8 ~ '***',
  Climate_scenarios == 'RCP8.5 (2021-2050)' & Rain == 86.6 ~ '**',
  Climate_scenarios == 'RCP8.5 (2021-2050)' & Rain == 161.45 ~ '***', 
  Climate_scenarios == 'RCP4.5 (2021-2050)' & Rain == 88.6 ~ '***', 
  Climate_scenarios == 'RCP4.5 (2021-2050)' & Rain == 170.74 ~ '***', 
)) -> wpd1
wpd1
wdp %>% gather(Median:'Standard deviation',key = 'Statistics',value = Rain) %>% 
  ggplot(aes(x=Climate_scenarios,y=Rain)) +
  geom_col(aes(fill=factor(Statistics,ordered = T,levels = c('Median','90%','95%','99%','99.9%','Mean','Standard deviation'))),position = 'dodge') +
  geom_text(aes(y = Rain,label = round(..y..,1),group=factor(Statistics,ordered = T,levels = c('Median','90%','95%','99%','99.9%','Mean','Standard deviation'))), position = position_dodge(width = 0.9),angle = 90) + 
  geom_text(data = wpd1,aes(label= sig,group=factor(Statistics,ordered = T,levels = c('Median','90%','95%','99%','99.9%','Mean','Standard deviation'))),position =position_dodge(width = 0.9), angle = 90,color='black',hjust= -1) +
  xlab('Climate scenarios') + ylab('Selected descriptive statistics and high percentiles of daily percipitation series (> 0.25 mm)') +
  scale_y_continuous(breaks = c(0,50,100,150,200,250),
                     limits = c(0,250)) +
  scale_fill_discrete() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.8,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )

# finally plot figure1 with statistics
wdp %>% gather(Median:'Standard deviation',key = 'Statistics',value = Rain) %>% 
  ggplot(aes(x=factor(Statistics,ordered = T,levels = c('Median','90%','95%','99%','99.9%','Mean','Standard deviation')),y=Rain)) +
  geom_col(aes(fill=Climate_scenarios),position = 'dodge') +
  geom_text(aes(label = round(..y..,1),group=Climate_scenarios), position = position_dodge(width = 0.9),angle = 90) + 
  geom_text(data = wpd1,aes(x=factor(Statistics,ordered = T,levels = c('Median','90%','95%','99%','99.9%','Mean','Standard deviation')),label= sig,group=Climate_scenarios),position = position_dodge(width = 0.9),angle = 90,hjust=-1) +
  xlab('Selected descriptive statistics and high percentiles of daily percipitation series (> 0.25 mm)') + ylab('Daily precipitation (mm)') +
  scale_y_continuous(breaks = c(0,50,100,150,200,250),
                     limits = c(0,250)) +
  scale_fill_discrete() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(1,1),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )
ggsave('stats1.tiff',device='tiff',dpi=300) 

# get 100-year annual precipitation averaged over 25 GCMs
# f1r4
rain_sheet_name_f1r4 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f1r4
length(dt)
rainfall <- dt
rainfall
rain_f1r4<- data.frame(day=1:36525)
for (i in 1:length(rainfall)){
  rain_f1r4<- cbind(rain_f1r4, prcp =rainfall[[i]][,c(4)])
}
colnames(rain_f1r4) <- c('day',rain_sheet_name_f1r4)
head(rain_f1r4,50)
nrow(rain_f1r4)
ncol(rain_f1r4)

rain_f1r4 %>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
  add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% 
  gather(BCC_BCCA_RCP45_NOSI1.CLI:NORESM_LOCA_RCP45_NOSI1.CLI,key = 'GCMs',value='precp') %>%
  group_by(year,GCMs) %>% summarise(ann_rain = sum(precp)) %>% spread(GCMs,ann_rain) -> rain_f1r4   #%>% {colMeans(.)} 

str(rain_f1r4)
rain_f1r4 <- as.data.frame(rain_f1r4[2:26])

rain_f1r4 %>% mutate(avg25 = round(rowMeans(.),0)) %>% summarise(ann_rain = mean(avg25),
                                                                 med_rain = median(avg25),
                                                                 sd_rain = sd(avg25))

rain_f1r4_100 <- rain_f1r4 %>% transmute(avg25 = round(rowMeans(.),0))
rain_f1r4_100

# f1r8
rain_sheet_name_f1r8 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f1r8
length(dt)
rainfall <- dt
rainfall
rain_f1r8<- data.frame(day=1:36525)
for (i in 1:length(rainfall)){
  rain_f1r8<- cbind(rain_f1r8, prcp =rainfall[[i]][,c(4)])
}
colnames(rain_f1r8) <- c('day',rain_sheet_name_f1r8)
head(rain_f1r8,50)
nrow(rain_f1r8)
ncol(rain_f1r8)

rain_f1r8 %>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
  add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% 
  gather(BCC_BCCA_RCP85_NOSI1.CLI:NORESM_LOCA_RCP85_NOSI1.CLI,key = 'GCMs',value='precp') %>%
  group_by(year,GCMs) %>% summarise(ann_rain = sum(precp)) %>% spread(GCMs,ann_rain) -> rain_f1r8   #%>% {colMeans(.)} 

str(rain_f1r8)
rain_f1r8 <- as.data.frame(rain_f1r8[2:26])
rain_f1r8 %>% mutate(avg25 = round(rowMeans(.),0)) %>% summarise(ann_rain = mean(avg25),
                                                                 med_rain = median(avg25),
                                                                 sd_rain = sd(avg25))
rain_f1r8_100 <- rain_f1r8 %>% transmute(avg25 = round(rowMeans(.),0))
rain_f1r8_100

# f2r4
rain_sheet_name_f2r4 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f2r4
length(dt)
rainfall <- dt
rainfall
rain_f2r4<- data.frame(day=1:36525)
for (i in 1:length(rainfall)){
  rain_f2r4<- cbind(rain_f2r4, prcp =rainfall[[i]][,c(4)])
}
colnames(rain_f2r4) <- c('day',rain_sheet_name_f2r4)
head(rain_f2r4,50)
nrow(rain_f2r4)
ncol(rain_f2r4)

rain_f2r4 %>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
  add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% 
  gather(BCC_BCCA_RCP45_NOSI2.CLI:NORESM_LOCA_RCP45_NOSI2.CLI,key = 'GCMs',value='precp') %>%
  group_by(year,GCMs) %>% summarise(ann_rain = sum(precp)) %>% spread(GCMs,ann_rain) -> rain_f2r4   #%>% {colMeans(.)} 

str(rain_f2r4)
rain_f2r4 <- as.data.frame(rain_f2r4[2:26])
rain_f2r4 %>% mutate(avg25 = round(rowMeans(.),0)) %>% summarise(ann_rain = mean(avg25),
                                                                 med_rain = median(avg25),
                                                                 sd_rain = sd(avg25))
rain_f2r4_100 <- rain_f2r4 %>% transmute(avg25 = round(rowMeans(.),0))
rain_f2r4_100

# f2r8
rain_sheet_name_f2r8 <- dir('<LOCAL_PATH_REDACTED>')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt) <- rain_sheet_name_f2r8
length(dt)
rainfall <- dt
rainfall
rain_f2r8<- data.frame(day=1:36525)
for (i in 1:length(rainfall)){
  rain_f2r8<- cbind(rain_f2r8, prcp =rainfall[[i]][,c(4)])
}
colnames(rain_f2r8) <- c('day',rain_sheet_name_f2r8)
head(rain_f2r8,50)
nrow(rain_f2r8)
ncol(rain_f2r8)

rain_f2r8 %>% add_column(.,date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),.after = 0)%>%
  add_column(.,year = year(.$date),.after = 1) %>% add_column(.,mon=month(.$date),.after = 2) %>% 
  gather(BCC_BCCA_RCP85_NOSI2.CLI:NORESM_LOCA_RCP85_NOSI2.CLI,key = 'GCMs',value='precp') %>%
  group_by(year,GCMs) %>% summarise(ann_rain = sum(precp)) %>% spread(GCMs,ann_rain) -> rain_f2r8   #%>% {colMeans(.)} 

str(rain_f2r8)
rain_f2r8 <- as.data.frame(rain_f2r8[2:26])
rain_f2r8 %>% mutate(avg25 = round(rowMeans(.),0)) %>% summarise(ann_rain = mean(avg25),
                                                                 med_rain = median(avg25),
                                                                 sd_rain = sd(avg25))
rain_f2r8_100 <- rain_f2r8 %>% transmute(avg25 = round(rowMeans(.),0))
rain_f2r8_100

# 100-year annual precipitation from baseline to F2R8 for Table 3
rain100 <- cbind(rain_pres_100$ann_rain,rain_f1r4_100,rain_f1r8_100,rain_f2r4_100,
                 rain_f2r8_100)
colnames(rain100) <- c('Baseline','F1R4.5','F1R8.5','F2R4.5','F2R8.5')
rain100
write.csv(rain100,'Annual_Rain_100.csv')
# t.test for baseline and future projected precipitation

t.test(rain100$Baseline,rain100$F1R4.5,alternative = 'two.sided')
t.test(rain100$Baseline,rain100$F1R8.5,alternative = 'two.sided')
t.test(rain100$Baseline,rain100$F2R4.5,alternative = 'two.sided')
t.test(rain100$Baseline,rain100$F2R8.5,alternative = 'two.sided')

# calculate Mean annual precipitation with median and standard deviation during 2021-2050 and 2051-2080 as projected by 25 GCMs under future two CO2 concentration levels.

mean(rain100$Baseline)
mean(rain100$F1R4.5)
mean(rain100$F1R8.5)
mean(rain100$F2R4.5)
mean(rain100$F2R8.5)
median(rain100$Baseline)
median(rain100$F1R4.5)
median(rain100$F1R8.5)
median(rain100$F2R4.5)
median(rain100$F2R8.5)
sd(rain100$Baseline)
sd(rain100$F1R4.5)
sd(rain100$F1R8.5)
sd(rain100$F2R4.5)
sd(rain100$F2R8.5)

# plot annual precipitation boxplot for baseline to F2R8 with error bar
rain_daily <- read.csv('daily_precp_25GCM.csv',header = T)
head(rain_daily)
tail(rain_daily)
str(rain_daily)
rain_daily <- rain_daily[2:7]
is.data.frame(rain_daily)
rain_daily$Climate <- gsub('GPCC_Baseline','Baseline',rain_daily$Climate)
colnames(rain_daily)

rain_daily %>% group_by(Climate,GCMs,year) %>% summarise(Rain = sum(precp)) %>%
  group_by(Climate) %>%
  mutate(ymin = min(Rain),ymax=max(Rain)) %>%
  ggplot(aes(x= Climate,y=Rain)) + geom_errorbar(aes(ymin=ymin,
                                                     ymax=ymax,
                                                     color=Climate),width=0.35) +
  geom_boxplot(aes(color=Climate)) +
  scale_y_continuous(breaks = seq(200,2000,100)) +
  xlab('Emission scenarios') + ylab('Annual precipitation (mm)') +
  coord_flip() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=18),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )


ggsave('AverageRainBoxplot.tiff',device = 'tiff', dpi = 300)
# final plot average annual precipitation between baseline and future GCMs
rain_daily %>% group_by(Climate,GCMs,year) %>% summarise(rain = sum(precp)) %>%
  summarise(rain = median(rain)) %>%
  ggplot(aes(x=Climate,y=rain)) + stat_boxplot(aes(group=Climate,color=Climate),geom = 'errorbar',width =0.35,show.legend = T) + 
  geom_boxplot(aes(color=Climate),width = 0.55) + 
  geom_jitter(alpha = 0.1,outlier.color = NA) +
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(450,850,100),
                     limits = c(450,850)) +
  coord_flip() +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.96,1),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_rect(),
         panel.border = element_blank(),
         panel.grid.major.x = element_line(size = 0.5, linetype = 'solid',
                                           color = "white"), 
         panel.grid.minor.x = element_line(size = 0.25, linetype = 'solid',
                                           color = "white")
  )


ggsave('violin_trim_alpha.tiff',device = 'tiff',dpi=300)
# finally plotting violin plot for baseline and GCMs precipitation
rain_daily %>% group_by(Climate,GCMs,year) %>% summarise(rain = sum(precp)) %>%
  summarise(rain = median(rain)) %>%
  ggplot(aes(x=Climate,y=rain)) + #stat_boxplot(aes(group=Climate,color=Climate),geom = 'errorbar',width =0.35,show.legend = T) + 
  geom_violin(aes(color=Climate),draw_quantiles = NULL,trim = T,show.legend = F,alpha=0.2) +
  geom_boxplot(aes(color=Climate),width = 0.1) + 
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(500,800,50),
                     limits = c(500,800)) +
  coord_flip() +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0,0),
         legend.justification = c(0,0),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.grid = element_blank(),
         panel.border = element_blank()
  )

dev.off()

# plot average annual precipitation between baseline and future GCMs
rain_daily %>% group_by(Climate,GCMs,year) %>% summarise(rain = sum(precp)) %>%
  summarise(rain = mean(rain))%>%
  ggplot(aes(x=Climate,y=rain)) + stat_boxplot(aes(group=Climate),geom = 'errorbar',width =0.35) + 
  geom_boxplot() + 
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(500,800,100)) +
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


# significant test and analysis of 100-year annual rainfall series of each GCM
p.value <- NULL
p.value <- list()
df <- data.frame()
for (i in 1:25) {
  p.value[[i]] <- round(t.test(rain_pres_100[,2],rain_f1r4[i],
                               alternative = 'two.sided',conf.level = 0.95)$p.value,3)
}
names(p.value) <- c(rain_sheet_name_f1r4)
p.value

for (i in 1:25) {
  temp.df <- data.frame(p.value = p.value[[i]],name = names(p.value[i]))
  df <- rbind(df,temp.df)
}

df %>% mutate(sig = case_when(
  p.value < 0.01 ~ '***',
  p.value < 0.05 ~ '**',
  p.value < 0.1 ~ '*',
  TRUE ~ 'NA'
)) -> df
df
write.csv(df,'sig_f1r4_95.csv')


# load a monthly rain from a csv file
rain_daily %>% group_by(Climate,GCMs,mon) %>% summarise(rain = sum(precp)/100) ->monthly_rain_25GCM
write.csv(monthly_rain_25GCM,'monthly_rain_25GCM.csv')

rain.csv <- read.csv('monthly_rain_25GCM.csv',header = T)
rain <- rain.csv
nrow(rain)

ggsave(filename = 'monthly precpitation with error bar.jpeg',device = jpeg,dpi=300)
# plotting a comparison of monthly precipitation between baseline and future scenarios
library(ggpattern)
rain_daily %>% group_by(Climate,GCMs,mon) %>% summarise(rain = sum(precp)/100) %>% 
  add_column(month = month.abb[.$mon],.after = 0) %>%
  ggplot(aes(x= factor(month,levels = month.abb,ordered = T),y = rain,fill=Climate)) + 
  stat_summary(aes(group=Climate,pattern=Climate,pattern_angle = Climate),
               fill = 'white',color = 'black',pattern_spacing = 0.01,pattern_color = 'black',
               geom ='bar_pattern',fun.y = mean, position = 'dodge',color='black',alpha=0.4) +
  stat_summary(aes(group=Climate),geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
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


ggsave('MonthPrecp.tiff',device = 'tiff',dpi = 300)
# plotting mean annual precipitation with standard error
library(wesanderson)
col <- wes_palette("Zissou1", 5, type = "discrete")
rain_daily %>% group_by(Climate,GCMs,mon) %>% summarise(rain = sum(precp)/100) %>% 
  add_column(month = month.abb[.$mon],.after = 0) %>%
  ggplot(aes(x= factor(month,levels = month.abb,ordered = T),y = rain,fill=Climate)) + 
  stat_summary(aes(group=Climate),geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  stat_summary(aes(group=Climate),
               geom ='bar',fun.y = mean, position = 'dodge',color='black') +
  scale_y_continuous(expand = c(0,0),
                     breaks = c(0,20,40,60,80,100,120,140,160)) +
  scale_fill_manual(values = col) +
  coord_cartesian(ylim = c(0,160)) +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank()
  )

# monthly precipitation for 5 emission scenarios
mon_rain <- rain_daily %>% group_by(Climate,GCMs,mon) %>% summarise(rain = sum(precp)/100) %>%
  group_by(Climate,mon) %>% summarise(rain = mean(rain)) %>% add_column(month = month.abb[.$mon],.after = 0)

mon_rain$month <- factor(mon_rain$month,ordered = T,levels = month.abb)
str(mon_rain)                                                                       
mon_rain <- as.data.frame(mon_rain)
mon_rain %>% ggplot(aes(x=month,y=rain)) +
  geom_tile(aes(color = Climate))

colors2 <- c('#009e73','#ff7f00','#c51b8a','#fb9a99','#1f7864')
rain_daily %>% group_by(Climate,GCMs,mon) %>% summarise(rain = sum(precp)/100) %>% 
  add_column(month = month.abb[.$mon],.after = 0) %>%
  ggplot(aes(x= factor(month,levels = month.abb,ordered = T),y=rain)) +
  stat_summary(aes(group=Climate),geom = 'errorbar',fun.data = mean_se,position=position_dodge(width = 0.9),width=0.45) +
  #geom_col(aes(fill=Climate),position  = 'dodge') +
  geom_boxplot(color='grey50',alpha =0.5) +
  #geom_tile(data=mon_rain,aes(x=factor(month,levels = month.abb,ordered = T),y=rain,color=Climate),size=1) +
  #geom_encircle(aes(x=month,y=rain),color='red') +
  geom_line(data=mon_rain,aes(x=factor(month,levels = month.abb,ordered = T),y=rain,group=Climate,color=Climate)) +
  coord_cartesian(ylim = c(0,250)) +
  scale_y_continuous(breaks = seq(0,250,by=50),
                     expand = c(0,0)) +
  scale_color_brewer(palette = 'Spectral') +
  scale_fill_brewer(palette = 'Spectral') +
  xlab('Month') + ylab('Monthly precipitation (mm)') +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0.98,0.98),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank()
  )


dev.off()

#-------------This is customized function for percentile calculation ----------
RainQu <- function(x){
  PRwn_min <- min(x)
  PRwn5 <- quantile(x,probs=0.05,na.rm=TRUE)
  PRwn10 <- quantile(x,probs=0.10,na.rm=TRUE)
  PRwn25 <- quantile(x,probs=0.25,na.rm=TRUE)
  PRwn50 <- quantile(x,probs=0.50,na.rm=TRUE)
  PRwn75 <- quantile(x,probs=0.75,na.rm=TRUE)
  PRwn90 <- quantile(x,probs=0.90,na.rm=TRUE)
  PRwn95 <- quantile(x,probs=0.95,na.rm=TRUE)
  PRwn99 <- quantile(x,probs=0.99,na.rm=TRUE)
  PRwn99.9 <- quantile(x,probs=0.999,na.rm=TRUE)
  PRwn_max <- max(x)
  PRwn_mean <- mean(x,na.rm = T)
  PRwn_sd <- sd(x,na.rm = T)
  print(paste('Min is',PRwn_min))
  print(paste('5% Qu. is',PRwn5))
  print(paste('10% Qu. is',PRwn10))
  print(paste('25% Qu. is',PRwn25))
  print(paste('50% Qu. is',PRwn50))
  print(paste('75% Qu. is',PRwn75))
  print(paste('90% Qu. is',PRwn90))
  print(paste('95% Qu. is',PRwn95))
  print(paste('99% Qu. is',PRwn99))
  print(paste('99.9% Qu. is',PRwn99.9))
  print(paste('Max is',PRwn_max))
  print(paste('Mean is',PRwn_mean))
  print(paste('SD is ',PRwn_sd))
} 

# options('install.lock = F')



