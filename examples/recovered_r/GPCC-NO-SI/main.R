# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\main.R
# Source SHA256: E547F0C8747F88F79FF385008AA16A76AD1828EDBD64FACA2F162A5D19305B64
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

##################################################################################
#  This R script was developed to analyze some basic elements for climate change,#
#  such as precipitation, maximum and minimum temperature by monthly or yearly.  #
#  It supports the WEPP project at USDA-ARS Grazinglands Research Center, El Reno#
#  Oklahoma.                                                                     #
#                                                                                #
#  Author: Lifeng Yuan   Contact: <EMAIL_REDACTED>                             #   
#  Date: Nov. 2020                                                               #
##################################################################################


# load required library
library(tidyverse)
library(reshape2)
library(lubridate)
library(scales)
library(ggthemes)
library(ggsci)

# load font library from the computer
library(extrafont)
#font_import()
loadfonts(device = "win")
# options('install.lock = F')

getwd()
# load the observed precipitation from Weatherfort station (1950-2019)
obs_rain <- read.csv('Weatherford_OBS_Daily_Weather_1950-2019.csv',header = T,stringsAsFactors = T)
# using tidyverse to load .csv file for convenient
obs_rain <- read_csv('Weatherford_OBS_Daily_Weather_1950-2019.csv',T)

head(obs_rain)
colnames(obs_rain) <- c('Year','Month','Day','Tmax','Tmin','Precp')
str(obs_rain)
obs_rain %>% select(Year,Month,Day,Precp) -> obs_rain
head(obs_rain)
tail(obs_rain)
obs_rain$Climate <- c('Observed')
head(obs_rain)
tail(obs_rain)

obs_rain025 <- obs_rain %>% filter(Precp > 0.25)
head(obs_rain025)
tail(obs_rain025)
obs_rain025 %>% summarise(Median = quantile(.$Precp,0.5),
                 p90 = quantile(.$Precp,0.9),
                 p95 = quantile(.$Precp,0.95),
                 p99 = quantile(.$Precp,0.99),
                 p999 = quantile(.$Precp,0.999),
                 Mean = mean(.$Precp),
                 SD = sd(.$Precp)) -> obs_rain
#write.csv(Obs_rain,'Obs_rain.csv',row.names = F)
obs_rain
head(obs_rain)

RainQu(obs_rain025$Precp)
quantile(obs_rain025$Precp,c(0.05,0.1,0.25,0.5,0.75,0.9,0.95,0.99,0.999),getOption("digits") - 3)
mean(obs_rain025$Precp)
sd(obs_rain025$Precp)

# build the baseline daily precipitation data
base_rain <- rain_pres_daily %>% select(year,mon,day,precp)
colnames(base_rain) <- c('year','Month','Day','Precp')
base_rain$Climate <- c('Baseline')
head(base_rain)
tail(base_rain)
nrow(base_rain)


base_rain %>% add_column(Date = seq(as.Date('1950/01/01'),as.Date('2049/12/31'),'days'),
                         Year = year(Date)) %>% select(Year,Month,Day,Precp,Climate) %>%
              filter(Year >= 1950 & Year <= 2019,
                     Precp > 0.25)-> base_rain
head(base_rain)
tail(base_rain)
nrow(base_rain)
Obs_base_rain <- rbind(obs_rain025,base_rain)
head(Obs_base_rain)
tail(Obs_base_rain)

# plotting comparison of annual precipitation between observed and downscaled baseline rainfall
library(ggpubr)
Obs_base_rain %>% group_by(Climate,Year) %>% 
  ggplot(aes(x=Precp,y=Precp)) + geom_point(aes(group=Climate,color=Climate),shape=1,size=2.5) +
  stat_cor(label.x = 800,label.y=400,size=5) +
  geom_abline(slope = 1,intercept = 0) +
  xlab('Observed annual precipitation (mm)') +
  ylab('Downscaled baseline annual precipitation (mm)') +
  # scale_y_continuous(expand = c(0,0),
  #                    limits = c(0,1500)) +
  # scale_x_continuous(expand = c(0,0),
  #                    limits = c(0,1500)) +
  scale_color_discrete() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='red'),
         axis.text.y = element_text(size = 13,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         axis.line = element_line(color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0.98,0),
         legend.justification = c(0.98,0),
         legend.text = element_text(size=14),
         legend.background = element_rect(fill ='green'),
         panel.background = element_blank()
  )
#ggsave('1-1 line.tiff',device = 'tiff',dpi=300)
# plotting cumulative distribution frequency comparison between baseline and observed daily precipitation
Obs_base_rain %>% ggplot(aes(x=Precp,col=Climate)) + 
  stat_ecdf(aes(group=Climate),geom = 'step',size=0.8) +
  xlab('Daily precipitation (mm)') +
  ylab('Cumulative distribution frequency') +
  scale_y_continuous(expand = c(0,0),
                     limits = c(0,1),
                     breaks = seq(0,1,0.05)) +
  scale_x_continuous(limits = c(0,200)) +
  scale_color_discrete() +
  theme( axis.title.x = element_text(size = 20),
         axis.title.y = element_text(size = 20),
         axis.text.x = element_text(size = 18,color='black'),
         axis.text.y = element_text(size = 18,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0.98,0),
         legend.justification = c(0.98,0),
         legend.text = element_text(size=20),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank()
  )
#ggsave('cumulative.tiff',device = 'tiff',dpi=300)
#making a daily precipitation data set for baseline
rain_sheet_name_pres<- dir('<LOCAL_PATH_REDACTED>')
dt<- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
rainfall <- dt
rainfall <- rainfall[[1]][1:4]
rainfall$GCMs <- c('GPCC-NO-SI')
rainfall$Climate <- c('GPCC_Baseline')
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
rain_daily_25 <- rain_daily%>% filter(precp > 0.25)
nrow(rain_daily_25)
write.csv(rain_daily_25,'daily_precp_GPCC-NO-SI.csv',row.names = F)

rain_daily <- read.csv('daily_precp_25GCM.csv',header = T)
str(rain_daily)
rain_daily <- rain_daily[2:7]
is.data.frame(rain_daily)
rain_daily$Climate <- gsub('GPCC_Baseline','Baseline',rain_daily$Climate)
colnames(rain_daily)

#making annual precipitation during 1 to 100 simulated year
rain_daily %>% group_by(Climate,GCMs,year) %>% 
  summarise(ann_rain = sum(precp)) %>% filter(Climate == 'RCP4.5 (2021-2050)')  # The simplest way to calculate annual precipitation for each GCM and from 1 to 100 year

rain_daily %>% group_by(Climate,GCMs) %>% 
  summarise(ann_rain = sum(precp)/100) %>% 
  mutate(GCM = str_extract(GCMs,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}')) -> rain_gcm

view(rain_gcm)
write.csv(rain_gcm,'rain_gcm.csv',row.names = F)

# calculate mean, sd, median of average annual rainfall
rain_daily %>% group_by(Climate,GCMs,year) %>% 
  summarise(ann_rain = sum(precp)) %>%
  summarise(y_rain = mean(ann_rain),
            med_rain = median(ann_rain),
            sd_rain = sd(ann_rain)) %>%
  summarise(avg_rain = mean(y_rain),
            m_rain = mean(med_rain),
            sd_rain = mean(sd_rain))

head(rain_daily)
#calculate selected descriptive statistics and high percentiles of daily rainfall
rain_daily%>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% summarise(p50 = quantile(precp,0.5),
                                                                            p90 = quantile(precp,0.9),
                                                                            p95 = quantile(precp,0.95),
                                                                            p99 = quantile(precp,0.99),
                                                                            p999 = quantile(precp,0.999),
                                                                            avg = mean(precp),
                                                                            sd = sd(precp)) -> gpcc_baseline


rain_daily%>% filter(Climate == 'F1R4.5',precp > 0.25) %>% group_by(GCMs) %>% summarise(p50 = quantile(precp,0.5),
                                                                                        p90 = quantile(precp,0.9),
                                                                                        p95 = quantile(precp,0.95),
                                                                                        p99 = quantile(precp,0.99),
                                                                                        p999 = quantile(precp,0.999),
                                                                                        avg = mean(precp),
                                                                                        sd = sd(precp)) %>%
  summarise(p50 = mean(p50),
            p90 = mean(p90),
            p95 = mean(p95),
            p99 = mean(p99),
            p999 = mean(p999),
            mean = mean(avg),
            sd = mean(sd)) -> gpcc_f1r4

rain_daily%>% filter(Climate == 'F1R8.5',precp > 0.25) %>% group_by(GCMs) %>% summarise(p50 = quantile(precp,0.5),
                                                                                        p90 = quantile(precp,0.9),
                                                                                        p95 = quantile(precp,0.95),
                                                                                        p99 = quantile(precp,0.99),
                                                                                        p999 = quantile(precp,0.999),
                                                                                        avg = mean(precp),
                                                                                        sd = sd(precp)) %>%
  summarise(p50 = mean(p50),
            p90 = mean(p90),
            p95 = mean(p95),
            p99 = mean(p99),
            p999 = mean(p999),
            mean = mean(avg),
            sd = mean(sd)) -> gpcc_f1r8


rain_daily%>% filter(Climate == 'F2R4.5',precp > 0.25) %>% group_by(GCMs) %>% summarise(p50 = quantile(precp,0.5),
                                                                                        p90 = quantile(precp,0.9),
                                                                                        p95 = quantile(precp,0.95),
                                                                                        p99 = quantile(precp,0.99),
                                                                                        p999 = quantile(precp,0.999),
                                                                                        avg = mean(precp),
                                                                                        sd = sd(precp)) %>%
  summarise(p50 = mean(p50),
            p90 = mean(p90),
            p95 = mean(p95),
            p99 = mean(p99),
            p999 = mean(p999),
            mean = mean(avg),
            sd = mean(sd)) -> gpcc_f2r4

rain_daily%>% filter(Climate == 'F2R8.5',precp > 0.25) %>% group_by(GCMs) %>% summarise(p50 = quantile(precp,0.5),
                                                                                        p90 = quantile(precp,0.9),
                                                                                        p95 = quantile(precp,0.95),
                                                                                        p99 = quantile(precp,0.99),
                                                                                        p999 = quantile(precp,0.999),
                                                                                        avg = mean(precp),
                                                                                        sd = sd(precp)) %>%
  summarise(p50 = mean(p50),
            p90 = mean(p90),
            p95 = mean(p95),
            p99 = mean(p99),
            p999 = mean(p999),
            mean = mean(avg),
            sd = mean(sd)) -> gpcc_f2r8


rain_daily%>% filter(precp > 0.25) %>%
  group_by(Climate)%>% summarise(p50 = round(quantile(precp,0.5),1),
                                                p90 = round(quantile(precp,0.9),1),
                                                p95 = round(quantile(precp,0.95),1),
                                                p99 = round(quantile(precp,0.99),1),
                                                p999 = round(quantile(precp,0.999),1),
                                                avg = round(mean(precp),1),
                                                sd = round(sd(precp),1)) -> desc_stats
head(desc_stats)
write.csv(desc_stats,'desc_statis.csv',row.names = F)

# finally plot selected descriptive statistics and high precentiles of daily precipitation series > 0.25 mm
library(wesanderson)
library(scales)
col4 <- wes_palette('Rushmore1')
x_lab <- c('Mean','Median','90%','95%','99%','99.9%','Standard deviation')

rain_daily%>% filter(precp > 0.25) %>%
  group_by(Climate)%>% summarise(p50 = round(quantile(precp,0.5),1),
                                 p90 = round(quantile(precp,0.9),1),
                                 p95 = round(quantile(precp,0.95),1),
                                 p99 = round(quantile(precp,0.99),1),
                                 p999 = round(quantile(precp,0.999),1),
                                 avg = round(mean(precp),1),
                                 sd = round(sd(precp),1)) %>%
  gather(p50:sd,key = 'percentile',value = 'Precipitation') %>%
  ggplot(aes(x=Climate)) +
  geom_tile(aes(y=percentile,fill=Precipitation)) +
  geom_text(aes(y=percentile,label = scales::comma(Precipitation,digits = 1))) +
  scale_fill_gradientn(colours = col4,
                       name='Precipitation (mm)') +
  scale_y_discrete(labels = x_lab) +
  coord_flip() +
  xlab('Climate scenarios') +
  ylab('Selected descriptive statistics and high percentiles of daily precipitation series (>0.25 mm)') +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title.align = 0.5
  )

ggsave('rain_percentiles.tif',device = 'tiff',dpi=600)



head(rain_daily)
# t-test for significance of daily rainfall series at selected high percentile
# test median percentile
t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(median(.$precp),2)},
       rain_daily%>% filter(Climate == 'RCP4.5 (2021-2050)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = median(precp)) %>% {.$med},
       alternative = 'greater')

t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(median(.$precp),2)},
       rain_daily%>% filter(Climate == 'RCP8.5 (2021-2050)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = median(precp)) %>% {.$med},
       alternative = 'greater')

t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(median(.$precp),2)},
       rain_daily%>% filter(Climate == 'RCP4.5 (2051-2080)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = median(precp)) %>% {.$med},
       alternative = 'greater')

t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(median(.$precp),2)},
       rain_daily%>% filter(Climate == 'RCP8.5 (2051-2080)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = median(precp)) %>% {.$med},
       alternative = 'greater')
# test 90 percentile
t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)},
       rain_daily%>% filter(Climate == 'RCP4.5 (2021-2050)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = quantile(precp,0.9)) %>% {.$med},
       alternative = 'greater')

t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)},
       rain_daily%>% filter(Climate == 'RCP8.5 (2021-2050)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = quantile(precp,0.9)) %>% {.$med},
       alternative = 'greater')

t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)},
       rain_daily%>% filter(Climate == 'RCP4.5 (2051-2080)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = quantile(precp,0.9)) %>% {.$med},
       alternative = 'greater')

t.test(mu= rain_daily %>% filter(Climate == 'GPCC_Baseline',precp > 0.25) %>% {round(quantile(.$precp,0.9),2)},
       rain_daily%>% filter(Climate == 'RCP8.5 (2051-2080)',precp > 0.25) %>% group_by(GCMs) %>% summarise(med = quantile(precp,0.9)) %>% {.$med},
       alternative = 'greater')




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
#ggsave('stats1.tiff',device='tiff',dpi=300) 

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

t.test(rain100$Baseline,rain100$F1R4.5,alternative = 'less')
t.test(rain100$Baseline,rain100$F1R8.5,alternative = 'less')
t.test(rain100$Baseline,rain100$F2R4.5,alternative = 'less')
t.test(rain100$Baseline,rain100$F2R8.5,alternative = 'less')

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

# plotting annual precipitation boxplot
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


ggsave('violin_trim_alpha.tiff',device = 'tiff',dpi=600)

# finally plotting violin plot for baseline and GCMs precipitation
avgrain <- rain_daily %>% group_by(Climate,GCMs,year) %>% summarise(rain = sum(precp)) %>%
  summarise(medrain = median(rain),
            avgrain = mean(rain)) %>%
  group_by(Climate) %>%
  summarise(medrain = median(medrain),
            avgrain = mean(avgrain))

head(avgrain)


library(ggsci)
rain_daily %>% filter (precp >= 0.25) %>% group_by(Climate,GCMs,year) %>% summarise(rain = sum(precp)) %>%
  summarise(medrain = median(rain),
            avgrain = mean(rain)) %>%
  ggplot(aes(x=Climate,y=medrain)) + 
  geom_violin(aes(color=Climate),draw_quantiles = NULL,trim = F,show.legend = F) +
  geom_boxplot(aes(color=Climate),width = 0.1) + 
  geom_text(data=avgrain,aes(x=Climate,y=medrain,label=round(medrain,0)),hjust=-0.6) +
  geom_segment(data=avgrain,aes(x=0.95,xend = 1.05,y=736,yend=736),color='red') +
  geom_segment(data=avgrain,aes(x=1.95,xend = 2.05,y=719,yend=719),color='red') +
  geom_segment(data=avgrain,aes(x=2.95,xend = 3.05,y=721,yend=721),color='red') +
  geom_segment(data=avgrain,aes(x=3.95,xend = 4.05,y=717,yend=717),color='red') +
  geom_segment(data=avgrain,aes(x=4.95,xend = 5.05,y=713,yend=713),color='red') +
  geom_text(data= avgrain,aes(x=Climate,y=avgrain,label=round(avgrain,0)),hjust=-0.6) +
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(500,1000,50),
                     limits = c(500,1000)) +
  #scale_color_manual(values = rep('grey80',5)) +
  #coord_flip() +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(1,0.95),
         legend.justification = c(1,0.85),
         legend.text = element_text(size=12),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.grid = element_blank(),
         panel.border = element_blank()
  )

library(wesanderson)
library(ggpubr)
comp <- list(c('GPCC_Baseline','RCP4.5 (2021-2050)'),
             c('GPCC_Baseline','RCP8.5 (2021-2050)'),
             c('GPCC_Baseline','RCP4.5 (2051-2080)'),
             c('GPCC_Baseline','RCP8.5 (2051-2080)'))

rain_daily %>% filter (precp >= 0.25) %>% group_by(Climate,GCMs,year) %>% summarise(rain = sum(precp)) %>%
  summarise(Medrain = median(rain),
            Avgrain = mean(rain)) %>%
  ggviolin(x='Climate',y= 'Medrain',fill='Climate',
           palette = c( "#FF0000", "#00A08A", "#F2AD00", "#F98400",
                        "#5BBCD6"),
           add = 'boxplot',add.params = list(fill='white')) +
  stat_compare_means(comparisons = comp) +
  stat_compare_means(method = 't.test') +
  #stat_compare_means() +
  geom_text(data=avgrain,aes(x=Climate,y=medrain,label=round(medrain,0)),hjust=-0.7) +
  geom_segment(data=avgrain,aes(x=0.90,xend = 1.10,y=736,yend=736),color='red') +
  geom_segment(data=avgrain,aes(x=1.90,xend = 2.10,y=719,yend=719),color='red') +
  geom_segment(data=avgrain,aes(x=2.90,xend = 3.10,y=721,yend=721),color='red') +
  geom_segment(data=avgrain,aes(x=3.90,xend = 4.10,y=717,yend=717),color='red') +
  geom_segment(data=avgrain,aes(x=4.90,xend = 5.10,y=713,yend=713),color='red') +
  geom_text(data= avgrain,aes(x=Climate,y=avgrain,label=round(avgrain,0)),hjust=-0.7) +
  xlab('Climate scenarios') + ylab('Average annual precipitation (mm)') +
  scale_y_continuous(breaks = seq(500,1000,50),
                     limits = c(500,1000)) +
  #scale_color_manual(values = rep('grey80',5)) +
  #coord_flip() +
  theme_agile(plot_grid = F) +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = 'top',
         legend.justification = c(1,0.85),
         legend.text = element_text(size=12),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.grid = element_blank(),
         panel.border = element_blank()
  )

ggsave('ggviolin.png',device = 'png',dpi = 400)
# finally calculate average annual precipitation between baseline and future GCMs
rain_100year <-rain_daily %>% group_by(Climate,GCMs,year) %>% summarise(rain = sum(precp)) 
head(rain_100year)
temp_100year
head(temp_100year)

rain_temp <- merge(rain_100year,temp_100year,by=c('Climate','GCMs','year'))
head(rain_temp)
unique(rain_temp$Climate)

rain_temp %>% ggplot(aes(x = rain,y=avg_ann_tmean)) +
  geom_point(aes(group=Climate,col=Climate)) +
  theme_bw()

rain_temp %>% right_join(evt_wheat_rs_100,by=c('Climate','GCMs','year')) %>%
  group_by(Climate) %>%
  ggplot(aes(x=year, y=ann_runoff))+
  geom_point(aes(group=Crop,col=Crop))+
  facet_grid(.~Climate)



head(evt_wheat_rs_100)
unique(evt_wheat_rs_100$Climate)
rtrsct <- merge(rain_temp,evt_wheat_rs_100,by=c('Climate','GCMs','year'))
head(rtrsct)
tail(rtrsct)
nrow(rtrsct)
unique(rtrsct$Climate)
rtrsct[!complete.cases(is.na(rtrsct)),]


rtrsct %>% group_by(Climate) %>%
  summarise(soil = mean(ann_soil))
  ggplot(aes(x=year, y=ann_soil))+
  geom_point(aes(group=Crop,col=Crop))+
  facet_wrap(.~Climate,scale='free')

# significant test and analysis of 100-year annual rainfall series of each GCM
p.value <- NULL
p.value <- list()
df <- data.frame()
for (i in 1:25) {
  p.value[[i]] <- round(t.test(rain_pres_100[,2],rain_f1r4[i],
                               alternative = 'greater',conf.level = 0.95)$p.value,3)
}
names(p.value) <- c(rain_sheet_name_f1r4)
p.value

for (i in 1:25) {
  temp.df <- data.frame(p.value = p.value[[i]],name = names(p.value[i]))
  df <- rbind(df,temp.df)
}

df %>% mutate(sig = case_when(
  p.value < 0.001 ~ '***',
  p.value < 0.01 ~ '**',
  p.value < 0.05 ~ '*',
  TRUE ~ 'NA'
)) -> df
df
write.csv(df,'sig_f1r4_95.csv')


#5.20 t-test for detecting precipitation change
rain_pres_100
rain_f1r4_100GCM <- rain_f1r4 %>% gather(BCC_BCCA_RCP45_NOSI1.CLI:NORESM_LOCA_RCP45_NOSI1.CLI,
                                         key = name,value = rain) %>%
  mutate(GCMs = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'))
rain_f1r8_100GCM <- rain_f1r8 %>% gather(BCC_BCCA_RCP85_NOSI1.CLI:NORESM_LOCA_RCP85_NOSI1.CLI,
                                         key = name,value = rain) %>%
  mutate(GCMs = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'))
rain_f2r4_100GCM <- rain_f2r4 %>% gather(BCC_BCCA_RCP45_NOSI2.CLI:NORESM_LOCA_RCP45_NOSI2.CLI,
                                         key = name,value = rain) %>%
  mutate(GCMs = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'))
rain_f2r8_100GCM <- rain_f2r8 %>% gather(BCC_BCCA_RCP85_NOSI2.CLI:NORESM_LOCA_RCP85_NOSI2.CLI,
                                         key = name,value = rain) %>%
  mutate(GCMs = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'))

GCMs <- unique(rain_f2r8_100GCM$name)
GCMs
res <- NULL
for (i in GCMs) {
  y <- rain_f2r8_100GCM %>% filter(name == i) %>% {.$rain}
  t_test <- t.test(rain_pres_100$ann_rain,y,alternative = 'two.sided',
                   conf.level = 0.95)
  if (t_test$p.value < 0.001){
    print(paste(i,t_test$p.value,'***',sep = ','))
    res <- rbind(res,paste(i,t_test$p.value,'***',sep = ','))
  } else if (t_test$p.value < 0.01){
    print(paste(i,t_test$p.value,'**',sep = ','))
    res <- rbind(res,paste(i,t_test$p.value,'**',sep = ','))
  } else if (t_test$p.value < 0.05){
    print(paste(i,t_test$p.value,'*',sep = ','))
    res <- rbind(res,paste(i,t_test$p.value,'*',sep = ','))
  }
}



# load a monthly rain from a csv file
rain_daily %>% group_by(Climate,GCMs,mon) %>% summarise(rain = sum(precp)/100) ->monthly_rain_25GCM
write.csv(monthly_rain_25GCM,'monthly_rain_25GCM.csv')

rain.csv <- read.csv('monthly_rain_25GCM.csv',header = T)
rain <- rain.csv
nrow(rain)

ggsave(filename = 'monthly precpitation with error bar.jpeg',device = jpeg,dpi=300)



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

head(rain_daily)
tail(rain_daily)
str(rain_daily)

rain_daily <- rain_daily %>% add_column(month = month.abb[.$mon],.after = 0)
rain_daily$month <- factor(rain_daily$month,ordered = T, levels = month.abb)


# extract the number of storm 99% percentile that occurred in each month
rain_daily %>% filter(precp > 82.34) %>% group_by(Climate,GCMs,month) %>% summarise(n = n()) ->rain99

# extract all wet days > 0.25 and join with storm 
rain_daily %>% filter(precp > 0.25) %>% group_by(Climate,GCMs,month) %>% summarise(n025 = n()) %>%
  full_join(rain99,by=c('Climate','GCMs','month')) -> rain025

view(rain025)
rain025$prop <- rain025$n/rain025$n025
head(rain025)
rain025 <-as.data.frame(rain025)
str(rain025)
rain025 <- rain025%>%filter(!(Climate == 'GPCC_Baseline')) 

# finally plot rainfall probability of occurance
library(ggpattern)
head(rain025)
str(rain025)
rain025<-rain025 %>% filter(!(Climate == 'GPCC_Baseline'))
rain025$Climate <- factor(rain025$Climate,ordered = T,
                          levels = c('RCP4.5 (2021-2050)',
                                     'RCP8.5 (2021-2050)',
                                     'RCP4.5 (2051-2080)',
                                     'RCP8.5 (2051-2080)'))
# 4.29 finally plot the probabitliy of occurance of heavy storm events                                     
rain025%>%
  group_by(Climate,month) %>% summarise(pro = mean(prop,na.rm=T)) %>% 
  ggplot(aes(x= month,y=pro,group=Climate)) + 
  geom_col_pattern(fill = 'white',color='black',pattern = 'stripe',
                   pattern_density = 0.5) +
  ylab('Probability of ocurrence') +
  facet_wrap(.~Climate,scale='free',ncol = 2)+
  scale_y_continuous(expand = c(0,0),
                     limits = c(0,0.03)) +
  scale_y_reverse() +
  theme_bw() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = 'top',
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         strip.text = element_text(size=14)
  )

#ggsave('stormprob.tif',device = 'tiff',dpi = 600)




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



