# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-SI\evt_press_100year.R
# Source SHA256: D84EA92C8FF1E80AC7573117A8268AE226CF808CC28B59BD8BFE854E8D73C33E
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
evt[1]
evt[[1]]%>% summarise(n = n_distinct(n_year))
length(evt)
evt

runoff_100_pres <- lapply(evt, function(x) x <- x%>% group_by(n_year) %>% summarise(ann_runoff = sum(Runoff),
                                                                                   ann_soilloss = sum(soilloss)*80/1600))


tlist <- list()
for (i in 1:length(evt)){
  evt[[i]] %>% summarise(avg_runoff = sum(Runoff)/100,
                         avg_soil = (sum(Soilloss)/100)*80/1600) -> tlist[[i]]
}
tlist

evt_out_sum <- data.frame()
sumry <- list()
df1 <- list()
# analyze Average Annual Sediment Leaving Profile
for (i in 1:length(evt)){
  evt[[i]] %>% summarise( name = names(evt[i]),
                          event_records = n(),
                          unique_year = n_distinct(year),
                          Ave_Ann_Precp = round(sum(Precp)/100,3),
                          Ave_Ann_Runoff = round(sum(Runoff)/100,3),
                          Ave_Ann_Sed_Width = round(sum(Soilloss)/100,3),
                          Ave_Ann_Sed_Profile_Width = round(Ave_Ann_Sed_Width * 80,3),
                          Total_Soil_Loss =round(Ave_Ann_Sed_Profile_Width/1600,3))  -> sumry[[i]]
  
  evt[[i]] %>% arrange(month) %>%
    group_by(month)%>%
    # divide by 100 months and convert to t/ha from kg/m2
    summarise(soil = round(sum(Soilloss)*8/16000,3))%>%
    #select(soil)%>%
    t() -> df1[[i]]
} -> evt_out_sum

evt_out_sum
nrow(evt_out_sum)

#deal with the situation with 10 months in a year

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

head(evt_out_sum)
evt_out_sum %>% summarise(mean = mean(.$Total_Soil_Loss))
evt_out_sum %>% summarise(mean = mean(.$Ave_Ann_Runoff))
evt_out_sum%>% summarise(n = n_distinct(Crop))

evt_out_sum %>% group_by(Crop,Tillage)%>% summarise(avg_runoff = mean(Ave_Ann_Runoff))->runoff_pres
evt_out_sum %>% group_by(Crop,Tillage)%>% summarise(avg_soil = mean(Total_Soil_Loss))->soil_pres

runoff_pres
soil_pres

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
library(tidyverse)
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
write.csv(runoff_all1,'runoff_crop_GPCC-SI.csv',row.names = F)
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
