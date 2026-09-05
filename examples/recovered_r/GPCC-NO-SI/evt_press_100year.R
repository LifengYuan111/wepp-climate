# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\evt_press_100year.R
# Source SHA256: 5B65CD1C5A9A113F4177B4948A1CC152D28BB3AAEEC2772190D04EB2150DB4BD
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
# load event file for baseline, including runoff and soil loss data
evt_sheets_name_pres <- dir('<LOCAL_PATH_REDACTED>',pattern = 'evt_')
dt <- dir('<LOCAL_PATH_REDACTED>',full.names = T,pattern = 'evt_') %>% map(read.table,sep='',skip=2,header=T,stringsAsFactors=F)
names(dt) <- evt_sheets_name_pres
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
library(lubridate)
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

head(evt)
evt_pres_out_sum <- data.frame()
sumry_pres <- list()
df1_pres <- list()

for (i in 1:length(evt)){
  evt[[i]] %>% summarise( name = names(evt[i]),
                          event_records = n(),
                          unique_year = n_distinct(year),
                          Ave_Ann_Precp = round(sum(Precp)/100,3),
                          Ave_Ann_Runoff = round(sum(Runoff)/100,3),
                          Ave_Ann_Sed_Width = round(sum(Soilloss)/100,3),
                          Ave_Ann_Sed_Profile_Width = round(Ave_Ann_Sed_Width * 80,3),
                          Total_Soil_Loss =round(Ave_Ann_Sed_Profile_Width/1600,3)) -> sumry_pres[[i]]
  evt[[i]] %>% arrange(month) %>%
    group_by(month)%>%
    summarise(soil = round(sum(Soilloss)*80/160000,3))%>%
    #select(soil)%>%
    t() -> df1_pres[[i]]
}


num <- 0
a <- list()
for (i in 1:length(df1_pres)) {
  if (ncol(df1_pres[[i]]) != 12) {
    num = num + 1
    print(df1_pres[[i]])
    a <- c(a,df1_pres[i])
  }
}
print(num)


for (i in 1:length(df1_pres)) {
  df1_pres[[i]] <- as.data.frame(df1_pres[[i]],stringsAsFactors = F)
  if (ncol(df1_pres[[i]]) < 12) {
    if (!("1" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='1',soil = 0)),.after = 0)
    }
    if (!("2" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='2',soil = 0)),.after = 1)
    } 
    if (!("3" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='3',soil = 0)),.after = 2)
    }
    if (!("4" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='4',soil = 0)),.after = 3)
    }
    if (!("5" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='5',soil = 0)),.after = 4)
    }
    if (!("6" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='6',soil = 0)),.after = 5)
    }
    if (!("7" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='7',soil = 0)),.after = 6)
    }
    if (!("8" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='8',soil = 0)),.after = 7)
    }
    if (!("9" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='9',soil = 0)),.after = 8)
    }
    if (!("10" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='10',soil = 0)),.after = 9)
    }
    if (!("11" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='11',soil = 0)),.after = 10)
    }
    if (!("12" %in% df1_pres[[i]][1,])){
      df1_pres[[i]] <- add_column(df1_pres[[i]],V = t(data.frame(month='12',soil = 0)),.after = 11)
    }
  } else if (ncol(df1_pres[[i]]) > 12) {
    df1_pres[[i]] %>% select(1:12) -> df1_pres[[i]]
  } else {
    next
  }
}

for (i in 1:length(df1_pres)) {
  colnames(df1_pres[[i]]) <- month.abb
  row.names(df1_pres[[i]]) <- NULL
  temp <- cbind(sumry_pres[[i]],df1_pres[[i]][2,])
  evt_pres_out_sum <- rbind(evt_pres_out_sum,temp)
}

nrow(evt_pres_out_sum)

evt_pres_out_sum %>% mutate(Tillage = case_when(
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
  GCMs = c('GPCC-NO-SI'),
  Climate = c('Baseline')
) -> evt_out_sum


nrow(evt_out_sum)
head(evt_out_sum)
str(evt_out_sum)
evt_out_sum <- as.data.frame(evt_out_sum)
write.csv(evt_out_sum,'evt_pres_out_sum.csv')

head(evt_out_sum)
evt_out_sum %>% summarise(mean = mean(.$Total_Soil_Loss))
evt_out_sum %>% summarise(across(Total_Soil_Loss,mean))

evt_out_sum %>% summarise(mean = mean(.$Ave_Ann_Runoff))
evt_out_sum %>% summarise(across(Ave_Ann_Runoff,mean))
evt_out_sum%>% summarise(n = n_distinct(Crop))

evt_out_sum %>% group_by(Crop,Tillage)%>% summarise(avg_runoff = mean(Ave_Ann_Runoff))->runoff_pres
evt_out_sum %>% group_by(Crop,Tillage)%>% summarise(avg_soil = mean(Total_Soil_Loss))->soil_pres

runoff_pres
# runoff amount generated on wheat fields
runoff_pres %>% filter(Crop == 'Wt' |
                         Crop == 'Wt-alf'|
                         Crop == 'Wt_double') %>%
  summarise(Runoff = mean(avg_runoff))

# annual soil loss amount generated on wheat fields
soil_pres %>% filter(Crop == 'Wt' |
                      Crop == 'Wt-alf'|
                      Crop == 'Wt_double') %>%
  summarise(Soilloss = mean(avg_soil))

runoff_pres <- as.data.frame(runoff_pres)  
runoff_f1r4 <- as.data.frame(runoff_f1r4)  
runoff_f1r8 <- as.data.frame(runoff_f1r8)  
runoff_f2r4 <- as.data.frame(runoff_f2r4)  
runoff_f2r8 <- as.data.frame(runoff_f2r8)  

runoff_all <- cbind(runoff_pres,f1r4=runoff_f1r4[,3],f1r8=runoff_f1r8[,3],f2r4=runoff_f2r4[,3],f2r8=runoff_f2r8[,3])
colnames(runoff_all) <- c('Crop','Tillage','Baseline','F1R4.5','F1R8.5','F2R4.5','F2R8.5')
runoff_all %>% group_by(Crop) %>% select(F1R4.5:F2R8.5) %>% summarise(MeanRunoff = (F1R4.5+F1R8.5+F2R4.5+F2R8.5)/4) -> MeanRunoff


runoff_all1 <- runoff_all %>% left_join(MeanRunoff,by = 'Crop')
head(runoff_all1)

colors1 <- c(Baseline = '#1f78b4')
shapes1 <- c(Baseline = 'dashed')


library(scales)
# finally plot surface runoff on different crop types 
runoff_all1 %>% gather(F1R4.5:F2R8.5,key = 'GCMs',value='Runoff') %>% group_by(Crop,GCMs) %>% summarise(avg_runoff = mean(Runoff),
                                                                                                        baseline = mean(Baseline),
                                                                                                        MeanRunoff = mean(MeanRunoff)) %>%
  ggplot(aes(x=reorder(Crop,-avg_runoff),y=avg_runoff)) + geom_col(aes(fill=GCMs),position = 'dodge') +
  geom_col(aes(y=MeanRunoff),position = 'dodge',alpha=0.01,color='grey50') +
  geom_line(aes(x=reorder(Crop,-baseline),y=baseline,group= 1,color= I('grey30')),size=0.9,alpha=0.9,linetype='dashed',show.legend = T) +
  geom_point(aes(x=reorder(Crop,-baseline),y=baseline,color=I('red')),shape=19,size=2.5) +
  geom_text(aes(x=reorder(Crop,-baseline),y=baseline,label=round(baseline,1),vjust=-0.9),position=position_dodge(width =0.2),color = 'black') +
  xlab('') + ylab('Average annual surface runoff (mm)') +
  scale_y_continuous(breaks = seq(80,150,10),
                     limits = c(80,150),
                     oob = rescale_none) +
  scale_fill_discrete() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0.97,0.97),
         legend.justification = c(1,1),
         legend.text = element_text(size=16),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank()
  )->p
p
#write.csv(runoff_all1,'runoff_crop_GPCC-NO-SI.csv',row.names = F)
ggsave('runoff.jpeg',device='jpeg',dpi=300)  
dev.off()


runoff_all_till <- cbind(runoff_pres,f1r4=runoff_f1r4[,3],f1r8=runoff_f1r8[,3],f2r4=runoff_f2r4[,3],f2r8=runoff_f2r8[,3])
colnames(runoff_all_till) <- c('Crop','Tillage','Baseline','F1R4.5','F1R8.5','F2R4.5','F2R8.5')
runoff_all_till %>% group_by(Tillage) %>% select(F1R4.5:F2R8.5) %>% summarise(MeanRunoff = (F1R4.5+F1R8.5+F2R4.5+F2R8.5)/4) -> MeanRunoff
runoff_all_till <- runoff_all_till %>% left_join(MeanRunoff,by = 'Tillage')
head(runoff_all_till)



runoff_all_till %>% gather(F1R4.5:F2R8.5,key = 'GCMs',value='Runoff') %>% group_by(Tillage,GCMs) %>% summarise(avg_runoff = mean(Runoff),
                                                                                                               baseline = mean(Baseline),
                                                                                                               MeanRunoff = mean(MeanRunoff)) %>%
  ggplot(aes(x=reorder(Tillage,-avg_runoff),y=avg_runoff)) + geom_col(aes(fill=GCMs),position = 'dodge',alpha=0.5) +
  geom_col(aes(y=MeanRunoff),position = 'dodge',alpha=0.01,color='grey50') +
  geom_line(aes(x=reorder(Tillage,-baseline),y=baseline,group= 1,color= I('#DC0000B2')),size=0.9,alpha=0.9,linetype='dashed',show.legend = T) +
  geom_point(aes(x=reorder(Tillage,-baseline),y=baseline,color=I('blue')),shape=19,size=2.5) +
  geom_text(aes(x=reorder(Tillage,-baseline),y=baseline,label=round(baseline,1),vjust=-0.9),position=position_dodge(width =0.2),color = 'black') +
  xlab('') + ylab('Average annual surface runoff (mm)') +
  scale_y_continuous(breaks = seq(0,110,10)) +
  #scale_color_manual(values = colors1) +
  #scale_shape_manual(values = shapes1) +
  scale_fill_d3(alpha = 0.5) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         #legend.position = c(0.97,0.97),
         legend.position = 'none',
         legend.justification = c(1,1),
         legend.text = element_text(size=16),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank()
  ) -> a
a

runoff_100_pres <- lapply(evt, function(x) x <- x%>% group_by(n_year) %>% summarise(ann_runoff = sum(Runoff),
                                                                                    ann_soilloss = sum(Soilloss)*80/1600))



# plot soil erosion graph in Figure 8
soil_pres <- as.data.frame(soil_pres)  
soil_f1r4 <- as.data.frame(soil_f1r4)  
soil_f1r8 <- as.data.frame(soil_f1r8)  
soil_f2r4 <- as.data.frame(soil_f2r4)  
soil_f2r8 <- as.data.frame(soil_f2r8)  

soil_all <- cbind(soil_pres,f1r4=soil_f1r4[,3],f1r8=soil_f1r8[,3],f2r4=soil_f2r4[,3],f2r8=soil_f2r8[,3])
colnames(soil_all) <- c('Crop','Tillage','Baseline','F1R4.5','F1R8.5','F2R4.5','F2R8.5')
soil_all

soil_all %>% group_by(Crop) %>% select(F1R4.5:F2R8.5) %>% summarise(MeanSoil = (F1R4.5+F1R8.5+F2R4.5+F2R8.5)/4) -> MeanSoil
# another method to calculate the mean of soil loss across F1R4:F2R8
soil_all %>% group_by(Crop) %>% select(F1R4.5:F2R8.5) %>% 
  rowwise()%>%
  summarise(MeanSoil = mean(c_across(F1R4.5:F2R8.5))) 
MeanSoil

soil_all1 <- soil_all %>% left_join(MeanSoil,by = 'Crop') 


# finally plot soil loss graph
soil_all1 %>% gather(F1R4.5:F2R8.5,key = 'GCMs',value='soil') %>% group_by(Crop,GCMs) %>% summarise(avg_soil = mean(soil),
                                                                                                    baseline = mean(Baseline),
                                                                                                    MeanSoil = mean(MeanSoil)) %>%
  ggplot(aes(x=reorder(Crop,-avg_soil),y=avg_soil)) + geom_col(aes(fill=GCMs),position = 'dodge') +
  geom_col(aes(y=MeanSoil),position = 'dodge',alpha=0.01,color='grey50') +
  geom_line(aes(x=reorder(Crop,-baseline),y=baseline,group= 1,color= I('grey30')),size=0.9,alpha=0.9,linetype='dashed',show.legend = T) +
  geom_point(aes(x=reorder(Crop,-baseline),y=baseline,color=I('red')),shape=19,size=2.5) +
  geom_text(aes(x=reorder(Crop,-baseline),y=baseline,label=round(baseline,1),vjust=-0.9),position=position_dodge(width =0.2),color = 'black') +
  xlab('Crop') + ylab('Average annual soil loss (t/ha)') +
  labs(y = expression(paste('Average annual soil loss (t ', ' ha'^-1,'yr'^-1,')'))) +
  scale_y_continuous(breaks = seq(0,13.5,1),
                     limits = c(0,13.5),
                     expand = c(0,0)) +
  scale_fill_discrete() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = 'none',
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank()
  )-> q
q  
ggsave('soilloss.tiff',device = 'tiff',dpi=300)
library(patchwork)
p / q


# plot soil erosion on different tillage systems 

soil_all_till <- cbind(soil_pres,f1r4=soil_f1r4[,3],f1r8=soil_f1r8[,3],f2r4=soil_f2r4[,3],f2r8=soil_f2r8[,3])
colnames(soil_all_till) <- c('Crop','Tillage','Baseline','F1R4.5','F1R8.5','F2R4.5','F2R8.5')
soil_all_till

soil_all_till %>% group_by(Tillage) %>% select(F1R4.5:F2R8.5) %>% summarise(MeanSoil = (F1R4.5+F1R8.5+F2R4.5+F2R8.5)/4) -> MeanSoil
soil_all_till <- soil_all %>% left_join(MeanSoil,by = 'Tillage') 


soil_all_till %>% gather(F1R4.5:F2R8.5,key = 'GCMs',value='soil') %>% group_by(Tillage,GCMs) %>% summarise(avg_soil = mean(soil),
                                                                                                           baseline = mean(Baseline),
                                                                                                           MeanSoil = mean(MeanSoil)) %>%
  ggplot(aes(x=reorder(Tillage,-avg_soil),y=avg_soil)) + geom_col(aes(fill=GCMs),position = 'dodge',alpha=0.5) +
  geom_col(aes(y=MeanSoil),position = 'dodge',alpha=0.01,color='grey50') +
  geom_line(aes(x=reorder(Tillage,-baseline),y=baseline,group= 1,color= I('#DC0000B2')),size=0.9,alpha=0.9,linetype='dashed',show.legend = T) +
  geom_point(aes(x=reorder(Tillage,-baseline),y=baseline,color=I('blue')),shape=19,size=2.5) +
  geom_text(aes(x=reorder(Tillage,-baseline),y=baseline,label=round(baseline,1),vjust=-0.9),position=position_dodge(width =0.2),color = 'black') +
  xlab('Tillage') + ylab('Average annual soil loss (t/ha)') +
  labs(y = expression(paste('Average annual soil loss (t', ' ha'^-1,')'))) +
  scale_y_continuous(breaks = seq(0,8,0.5)) +
  scale_fill_d3() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.97,0.97),
         #legend.position = 'none',
         legend.justification = c(1,1),
         legend.text = element_text(size=10),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank()
  ) -> b
a/b
ggsave('Figure7.tiff',device='tiff',dpi = 300)
