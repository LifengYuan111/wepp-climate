# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-NO-SI\Prec_runoff.R
# Source SHA256: 643A0C791FD6FA377FD0925DF01E0C70EAE7563ECDB2B6F636A82A951FADB088
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

## deal with storm event output at present climate level from wepp

evt_sheets_name <- openxlsx::getSheetNames('.//all_event_out_present.xlsx')
length(evt_sheets_name)
# read each sheet in a entire event excel file
event.workbook <- lapply(excel_sheets('all_event_out_present.xlsx'),function (x) read_excel(path='all_event_out_present.xlsx',sheet = x,skip=2))
event.workbook
names(event.workbook) <- evt_sheets_name

evt <- event.workbook

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
                         Ave_Ann_Runoff = round(sum(Runoff)/100,3))  -> sumry[[i]]

  evt[[i]] %>% arrange(month) %>%
    group_by(month)%>%
    summarise(runoff = round(sum(Runoff),3))%>%
    select(runoff)%>%
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

names(df1) <- evt_sheets_name
df1
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



write.csv(evt_out_sum,file='runoff_evt_sum_present.csv')


evt_out_sum <- as.data.frame(evt_out_sum)
evt_out_sum$Tillage <- factor(evt_out_sum$Tillage)
evt_out_sum$Crop <- factor(evt_out_sum$Crop)
str(evt_out_sum)



evt_out_sum%>%select(name,Jan:Dec,Tillage,Crop)%>%
  gather(Jan:Dec,key = 'Month', value = 'Mon_Runoff')%>%
  group_by(Tillage,Month)%>%
  mutate(avg_runoff = mean(Mon_Runoff))%>%
  ggplot(aes(x=factor(Month,levels = month.abb,ordered = T),y=avg_runoff)) + 
     geom_line(aes(group=Tillage,color=Tillage,linetype=Tillage),size = 0.8) +
     geom_point(aes(color=Tillage),size=1.5) +
  xlab('Months') +
  ylab('Average Monthly Runoff') +
  scale_y_continuous(name = 'Average Monthly Runoff (mm)',
                     expand = c(0,0),
                     breaks = c(0,500,1000,1500,2000,2500,3000),
                     limits = c(0,2500)) +
  #scale_fill_discrete(limits = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))+
  scale_color_discrete() +
  labs(fill = '') +
  ggtitle('Average Monthly Runoff from Erosive Rainfall at the SYNTOR baseline Scenario during 100 years') +
  theme_agile(plot_grid = F) +
  theme(plot.title = element_text("Simulated sediment yield modulus proportion",hjust=0.5),
        legend.position = c(0.95,0.95),
        legend.justification = c(1,1),
        legend.title=element_text(size=13),
        legend.background = element_rect(colour = 'white'),
        axis.title.x = element_text(size=13),
        axis.title.y = element_text(size=13)
  )
