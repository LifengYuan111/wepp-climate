# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-SI\soil_loss.R
# Source SHA256: E25AA602C4DAB5AD1356446DD2BE0A859FFDFB0163F738AA987AF948FFD69C5E
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
getwd()
setwd("<LOCAL_PATH_REDACTED>")
rm(list=ls())
# load readxl,openxlsx,tidyverse,hydroTSM, and zoo packages to support this analysis
library(tidyverse)
library(readxl)
library(openxlsx)
library(lubridate)
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



write.csv(evt_out_sum,file='soil_loss_evt_out_sum_present.csv')

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

head(dt)
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
  dt[[i]] %>% summarise( name = names(dt[i]),
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
}

head(df1_f1r4,20)
ncol(df1_f1r4[[1]])
df1_f1r4[[13]][1,]

num <- 0
a <- list()
for (i in 1:length(df1_f1r4)) {
  if (ncol(df1_f1r4[[i]]) != 12) {
    num = num + 1
    print(df1_f1r4[[i]])
    a <- c(a,df1_f1r4[i])
  }
}
print(num)
head(df1_f1r4,20)


for (i in 1:length(df1_f1r4)) {
    df1_f1r4[[i]] <- as.data.frame(df1_f1r4[[i]],stringsAsFactors = F)
    if (ncol(df1_f1r4[[i]]) < 12) {
      if (!("1" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='1',soil = 0)),.after = 0)
      }
      if (!("2" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='2',soil = 0)),.after = 1)
      } 
      if (!("3" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='3',soil = 0)),.after = 2)
      }
      if (!("4" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='4',soil = 0)),.after = 3)
      }
      if (!("5" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='5',soil = 0)),.after = 4)
      }
      if (!("6" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='6',soil = 0)),.after = 5)
      }
      if (!("7" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='7',soil = 0)),.after = 6)
      }
      if (!("8" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='8',soil = 0)),.after = 7)
      }
      if (!("9" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='9',soil = 0)),.after = 8)
      }
      if (!("10" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='10',soil = 0)),.after = 9)
      }
      if (!("11" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='11',soil = 0)),.after = 10)
      }
      if (!("12" %in% df1_f1r4[[i]][1,])){
        df1_f1r4[[i]] <- add_column(df1_f1r4[[i]],V = t(data.frame(month='12',soil = 0)),.after = 11)
      }
    } else if (ncol(df1_f1r4[[i]]) > 12) {
      df1_f1r4[[i]] %>% select(1:12) -> df1_f1r4[[i]]
    } else {
      next
    }
}

head(sumry_f1r4,20)
head(df1_f1r4,20)

for (i in 1:length(df1_f1r4)) {
  colnames(df1_f1r4[[i]]) <- month.abb
  row.names(df1_f1r4[[i]]) <- NULL
  temp <- cbind(sumry_f1r4[[i]],df1_f1r4[[i]][2,])
  evt_f1r4_out_sum <- rbind(evt_f1r4_out_sum,temp)
}

nrow(evt_f1r4_out_sum)
final <- nrow(unique(evt_f1r4_out_sum))
write.csv(unique(evt_f1r4_out_sum),'evt_f1r4_out_sum.csv')

df1_f1r4

evt_f1r4_out_sum <-unique(evt_f1r4_out_sum)
head(evt_f1r4_out_sum)
is.data.frame(evt_f1r4_out_sum)


evt_f1r4_out_sum %>% mutate(Tillage = case_when(
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
    TRUE ~ 'None'),
  Climate = str_extract(name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}')
) ->evt_f1r4_out_sum

write.csv(evt_f1r4_out_sum,'evt_f1r4_out_sum.csv')


str(evt_f1r4_out_sum)
evt_f1r4_out_sum %>% mutate(Climate = str_subset(name,'_[:upper:]{2,3}_[:upper:]{1}.'))
nrow(evt_f1r4_out_sum)
evt_f1r4_out_sum[1]
Climate = str_subset(as.character(evt_f1r4_out_sum[1]),'_[:upper:]{2,3}_[:upper:]{1}.')
Climate
typeof(as.character(evt_f1r4_out_sum[1]))
evt_C-ca-a_BC_L.txt
str_extract('evt_C-ca-a_BC_L.txt','[:upper:]{2,3}|[:upper:]{1}\\d{1}_[:upper:]{1}')


