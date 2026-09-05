# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-NO-SI\res_analysis.R
# Source SHA256: B164518F25F7D76B79C13B56BC152CB25793035E9D57025037990CE8CC341EB8
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
getwd()
setwd("<LOCAL_PATH_REDACTED>")
rm(list=ls())
# load readxl,openxlsx,tidyverse,hydroTSM, and zoo packages to support this analysis
library(tidyverse)
library(readxl)
library(openxlsx)
library(lubridate)
library(hydroTSM)
library(stringr)
library(zoo)
library(ggsci)

## deal with crop out from wepp
crop <- read.csv('..//..//output//result analysis//crp_out_sum_pre.txt',header = F,sep = ':',
                 stringsAsFactors = F)
colnames(crop) <- c('Name','Product')
crop <- as.data.frame(crop)
crop
class(crop)

crop %>% mutate(Tillage = case_when(
  grepl('crp_C',Name) ~ 'CT',
  grepl('crp_D',Name) ~ 'DT',
  grepl('crp_N',Name) ~ 'NT',
  grepl('crp_R',Name) ~ 'RT',
  TRUE ~ 'None'),
  Crop = case_when(
    grepl('-ca-a',Name) ~ 'Ca-alf',
    grepl('-ca',Name) ~ 'Ca',
    grepl('-ct-a',Name) ~ 'Ct-alf',
    grepl('-ct',Name) ~ 'Ct',
    grepl('-sb-a',Name) ~ 'Sb-alf',
    grepl('-sb',Name) ~ 'Sb',
    grepl('-sg-a',Name) ~ 'Sg-alf',
    grepl('-sg',Name) ~ 'Sg',
    grepl('-wt-a',Name) ~ 'Wt-alf',
    grepl('-wt-D',Name) ~ 'Wt_double',
    grepl('-wt',Name) ~ 'Wt',
    TRUE ~ 'None'),
  Climate = str_sub(Name,-10,-7),
  Harvest = as.numeric(str_extract(Product,'\\d{2,3}')),
  Yield = as.numeric(str_extract_all(Product,'0\\.\\d{3}')),
  Yealy_Yield = ifelse(grepl('-a_',Name) & (Harvest >= 100),round(Yield*Harvest/(100-33),3),Yield)
)

str(crop)
crop
write.table(crop,file = '..//..//output//result analysis//crop_pres.csv',sep = ',',col.names = TRUE,row.names = FALSE)
class(crop)
crop %>% group_by(Tillage) %>%
  summarise(mean(Yield))


## deal with storm event output at present climate level from wepp

evt_sheets_name <- openxlsx::getSheetNames('.//all_event_out_present.xlsx')
length(evt_sheets_name)
# read each sheet in a entire event excel file
event.workbook <- lapply(excel_sheets('all_event_out_present.xlsx'),function (x) read_excel(path='all_event_out_present.xlsx',sheet = x,skip=2))
event.workbook
names(event.workbook) <- evt_sheets_name

evt <- event.workbook
evt

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

evt_out_sum <- data.frame()
sumry <- list()
df1 <- list()
# analyze Average Annual Sediment Leaving Profile
for (i in 1:length(evt)){
  evt[[i]] %>% summarise(name = names(evt[i]),
                      event_records = n(),
                      unique_year = n_distinct(year),
                      Ave_Ann_Precp = round(sum(Precp)/100,3),
                      Ave_Ann_Runoff = round(sum(Runoff)/100,3),
                      Ave_Ann_Sed_Width = round(sum(Soilloss)/100,3),
                      Ave_Ann_Sed_Profile_Width = round(Ave_Ann_Sed_Width * 80,3),
                      Total_Soil_Loss =round(Ave_Ann_Sed_Profile_Width/1600,3),
                      Ave_Ann_Soil_Loss = round(sum(Soilloss),3)) -> sumry[[i]]
  evt[[i]] %>% arrange(month) %>%
    group_by(month)%>%
    summarise(soil = round(sum(Soilloss)*8/16000,3))%>%
    select(soil)%>%
    t() -> df1[[i]]
  # deal with the situation with 10 months in a year
  if (i == 9 | i == 16){
    df1[[i]] <- cbind(c(0),c(0),df1[[i]]) 
  }
  colnames(df1[[i]]) <- month.abb
  row.names(df1[[i]]) <- NULL
  temp <- cbind(sumry[[i]],df1[[i]])
  evt_out_sum <- rbind(evt_out_sum,temp)
}

evt_out_sum %>% mutate(Tillage = case_when(
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
    TRUE ~ 'None') 
) -> evt_out_sum



write.csv(evt_out_sum,file='evt_out_sum_present.csv')

evt_out_sum <- as.data.frame(evt_out_sum)
str(evt_out_sum)
library(reshape)
p_data <- reshape2::melt(evt_out_sum,id='name')
head(p_data)
p_data$variable <- factor(as.character(p_data$variable))
pd<- subset(p_data,variable=='Jan'|
              variable=='Feb'|
              variable=='Mar'|
              variable=='Apr'|
              variable=='May'|
              variable=='Jun'|
              variable=='Jul'|
              variable=='Aug'|
              variable=='Sep'|
              variable=='Oct'|
              variable=='Nov'|
              variable=='Dec') 
pd

a <- pd[which(pd$value >= 3),]
a

ggplot(pd) + geom_boxplot(aes(x=factor(variable,levels = month.abb,ordered = T),y=value,fill=variable)) +
  xlab('Months') +
  ylab('Average Monthly Soil Loss') +
  scale_y_continuous(name = 'Average Monthly Soil Loss (t/ha)',
                     expand = c(0,0)) +
  scale_fill_discrete(limits = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))+
  labs(fill = '') +
  ggtitle('Average Monthly Soil Loss Amount at the SYNTOR baseline Scenario during 100 years') +
  theme_agile(plot_grid = F) +
  theme(plot.title = element_text("Simulated sediment yield modulus proportion",hjust=0.5),
        legend.position = c(0.95,0.95),
        legend.justification = c(1,1),
        legend.title=element_text(size=13),
        legend.background = element_rect(colour = 'white'),
        axis.title.x = element_text(size=13),
        axis.title.y = element_text(size=13)
  )



view(pd)
evt[[1]] %>% arrange(month) %>%
  group_by(month)%>%
  summarise(soil = sum(Soilloss))%>%
  select(soil)%>%
  t()-> df1
colnames(df1) <- month.abb
row.names(df1) <- NULL
a <- cbind(sumry[[1]],df1)
a

df1 <- as.data.frame(df1)
df1$month <- factor(df1$month,ordered = T)
str(df1)
ggplot(df1) + geom_col(aes(x=month,y=soil,fill=month),
                       show.legend = F) +
  scale_fill_discrete()
  
names(evt[1])
head(evt[[1]],14)
tail(evt[[1]],20)
str(evt[[1]])




# event output at future1 and RCP4.5

evt_sheets_name_f1r4 <- dir('..//..//output//future1//RCP45//')

dt <- dir('..//..//output//future1//RCP45//',full.names = T) %>% map(read.table,sep='',skip=2,header=T,stringsAsFactors=F)
names(dt) <- evt_sheets_name_f1r4

length(dt)
x1 <- 1:100
y1 <- 2021:2120
df_f1r4 <- data.frame(year=x1,n_year=y1)
df_f1r4$year <- as.character(df_f1r4$year)
df_f1r4$n_year <- as.character(df_f1r4$n_year)
str(df_f1r4)

for (i in 1:length(dt)){
  dt[[i]] <- as.data.frame(dt[[i]])
  colnames(dt[[i]]) <- c('day','mon','year','Precp','Runoff','Irrigation Detachment',
                          'Average Detachment','Maximum Detachment','Point','Average Deposition',
                          'Maximum Deposition','Point','Soilloss','ER')
}

# only extracting specific columns from evt list
for (i in 1:725){
  dt[[i]] <- dt[[i]][,c(1:5,13)]
  dt[[i]][,c(1)] <- as.character(dt[[i]][,c(1)])
  dt[[i]][,c(2)] <- as.character(dt[[i]][,c(2)])
  dt[[i]][,c(3)] <- as.character(dt[[i]][,c(3)])
  dt[[i]] %>% left_join(df,by='year')%>%
    mutate(date = paste(day,mon,n_year,sep = '-')) -> dt[[i]]
  dt[[i]]$date<-as.Date(as.POSIXct(dt[[i]]$date,format='%d-%m-%Y'))
  dt[[i]]$month <- factor(month(dt[[i]]$date),ordered = T)
  dt[[i]][,c(8,1,2,9,3,7,4,5,6)] -> dt[[i]]
}

evt_f1r4_out_sum <- data.frame()
sumry_f1r4 <- list()
df1_f1r4 <- list()
# analyze Average Annual Sediment Leaving Profile
for (i in 1:length(dt)){
  dt[[i]] %>% summarise(name = names(dt[i]),
                         event_records = n(),
                         unique_year = n_distinct(year),
                         Ave_Ann_Precp = round(sum(Precp)/100,3),
                         Ave_Ann_Runoff = round(sum(Runoff)/100,3),
                         Ave_Ann_Sed_Width = round(sum(Soilloss)/100,3),
                         Ave_Ann_Sed_Profile_Width = round(Ave_Ann_Sed_Width * 80,3),
                         Total_Soil_Loss =round(Ave_Ann_Sed_Profile_Width/1600,3),
                         Ave_Ann_Soil_Loss = round(sum(Soilloss),3)) -> sumry_f1r4[[i]]
  dt[[i]] %>% arrange(month) %>%
    group_by(month)%>%
    summarise(soil = round(sum(Soilloss)*8/16000,3))%>%
    #select(soil)%>%
    t() -> df1_f1r4[[i]]
  # deal with the situation with 10 months in a year

}

df1_f1r4

if (i == 13 | i == 16){
  df1_f1r4[[i]] <- cbind(c(0),c(0),df1_f1r4[[i]]) 
}
colnames(df1_f1r4[[i]]) <- month.abb
row.names(df1_f1r4[[i]]) <- NULL
temp <- cbind(sumry_f1r4[[i]],df1_f1r4[[i]])
evt_f1r4_out_sum <- rbind(evt_f1r4_out_sum,temp)


head(dt)
tail(dt)
summary(dt)
str(dt)


