# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\Crop and tillage.R
# Source SHA256: 36AE17F00109ED7109DDA4E4BD9119DFA2441A7274DF9373A10F7922AA34E93D
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
crop_yield1 <- rbind(crp_till_f1r4,crp_till_f1r8,crp_till_f2r4,crp_till_f2r8)
crop_yield1 %>% group_by(Climate,GCM,Tillage,New_Crop) %>%
  summarise(Yield = mean(Yield)) -> crop_till_yield

crop_till_all <- crop_till_yield
crop_till_all %>% mutate(Crop_name = case_when(
  New_Crop == 'Alfalfa'~ 'Alfalfa',
  New_Crop == 'Sg'~'Sorghum',
  New_Crop == 'Wt'~'Wheat',
  New_Crop == 'Ct'~'Cotton',
  New_Crop == 'Ca'~'Canola',
  New_Crop == 'Sb'~'Soybean',
  TRUE~ New_Crop
)) -> crop_till_all

crop_till_all %>% mutate(Climate = case_when(
  Climate == 'F1R4.5'~ 'RCP4.5 (2021-2050)',
  Climate == 'F1R8.5'~ 'RCP8.5 (2021-2050)',
  Climate == 'F2R4.5'~ 'RCP4.5 (2051-2080)',
  Climate == 'F2R8.5'~ 'RCP8.5 (2051-2080)',
  TRUE ~ Climate
)) -> crop_till_all


head(crop_till_all)
tail(crop_till_all)
nrow(crop_till_all)

head(crp_till_pres)
nrow(crp_till_pres)
crp_till_pres %>% filter(New_Crop == 'Wt') -> base_wheat_yield
head(base_wheat_yield)
base_wheat_yield$Tillage <- factor(base_wheat_yield$Tillage,ordered = T,
                                   levels = c('CT','NT','DT','RT'))
str(base_wheat_yield)




library(tidyverse)
library(ggprism)
library(scales)
crop_till_all %>% group_by(Climate,Tillage,Crop_name) %>%
  filter(Crop_name == 'Wheat') %>%
  ggplot(aes(x=Tillage,y=Yield)) +
  stat_summary(aes(x=reorder(Tillage,-Yield),y = Yield,group=Climate),geom='errorbar',
               position = position_dodge(width = 0.9),
               fun.data = mean_se,width = 0.45) +
  stat_summary(aes(fill=Climate),geom='bar',position = 'dodge',
               fun = mean) +
  geom_segment(aes(x=0.5,xend=1.5,y=2240,yend=2240),color='black') +
  geom_segment(aes(x=1.5,xend=2.5,y=2248,yend=2248),color='black') +
  geom_segment(aes(x=2.5,xend=3.5,y=2224,yend=2224),color='black') +
  geom_segment(aes(x=3.5,xend=4.5,y=2144,yend=2144),color='black') +
  geom_text(data=base_wheat_yield,aes(x=Tillage,y=Yield,label=round(..y..,0)),
            vjust=-0.4,size=4) +
  theme_bw()+
  xlab('Tillage systems') +
  labs(y = expression(paste('Wheat yield (kg ','ha'^-1,'yr'^-1,')'))) +
  scale_y_continuous(guide = 'prism_minor',
                     labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     limits = c(0,3000),
                     breaks = seq(0,3000,500),
                     expand=c(0,0),
                     oob = rescale_none) +
  scale_fill_discrete() +
  theme_bw() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(1,1),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank()
  ) 
#ggsave('wheat_yield.tiff',device = 'tiff',dpi = 600)

crop_till_all %>% group_by(Climate,Tillage,Crop_name) %>%
  summarise(yield = mean(Yield))

#----wheat yield on different cropping system ---------


crop_wheat <- rbind(crop_wheat_pres,crop_wheat_f1r4,
                    crop_wheat_f1r8,crop_wheat_f2r4,
                    crop_wheat_f2r8)

head(crop_wheat)
crop_wheat <- crop_wheat %>% mutate(Climate = case_when(
  Climate == 'F1R4.5'~ 'RCP4.5 (2021-2050)',
  Climate == 'F1R8.5'~ 'RCP8.5 (2021-2050)',
  Climate == 'F2R4.5'~ 'RCP4.5 (2051-2080)',
  Climate == 'F2R8.5'~ 'RCP8.5 (2051-2080)',
  T~'GPCC_Baseline'),
  GCMs = str_extract(Name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}')
)
head(crop_wheat)
tail(crop_wheat)

Baseline_wheat <- crop_wheat %>% filter(Climate == 'GPCC_Baseline') %>%
  group_by(Tillage,New_Crop) %>%
  summarise(Avg_yield = mean(Total_yield))

Baseline_wheat


crop_wheat %>% filter(!(Climate == 'GPCC_Baseline')) %>% group_by(Climate) %>% ggplot(aes(x = reorder(Tillage,-Total_yield),y= Total_yield)) +
  stat_summary(aes(fill=New_Crop),geom='bar',position = 'dodge',
               fun = mean,width=0.65) +
  stat_summary(aes(group=New_Crop),geom='errorbar',
               position = position_dodge(width = 0.65),
               fun.data = mean_se,width = 0.3) +
  geom_segment(aes(x=0.65,xend=1,y=2528,yend=2528),linetype='dashed') +
  geom_segment(aes(x=1,xend=1.35,y=1952,yend=1952),linetype='dashed') +
  geom_segment(aes(x=1.65,xend=2,y=2512,yend=2512),linetype='dashed') +
  geom_segment(aes(x=2,xend=2.35,y=1984,yend=1984),linetype='dashed') +
  geom_segment(aes(x=2.65,xend=3,y=2480,yend=2480),linetype='dashed') +
  geom_segment(aes(x=3,xend=3.35,y=1968,yend=1968),linetype='dashed') +
  geom_segment(aes(x=3.65,xend=3.9,y=2512,yend=2512),linetype='dashed') +
  geom_segment(aes(x=3.9,xend=4.1,y=2000,yend=2000),linetype='dashed') +
  geom_segment(aes(x=4.1,xend=4.35,y=1920,yend=1920),linetype='dashed') +
  geom_text(data=Baseline_wheat,aes(x= Tillage,y=Avg_yield,group=New_Crop,label=round(..y..,0)),
            vjust=-0.3,size=4,position = position_dodge(width = 0.65)) +
  scale_y_continuous(expand = c(0,0),
                     limits = c(0,3000),
                     breaks = seq(0,3000,by=500)) +
  facet_wrap(.~Climate,scales = 'free',strip.position = 'top') +
  xlab('Tillage systems') +
  labs(y = expression(paste('Wheat yield (kg ','ha'^-1,'yr'^-1,')'))) +
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
         #panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         strip.text = element_text(size=14)
  ) 
ggsave('wheat_yield_tillage.tiff',device = 'tiff',dpi=600)


#t-test 
wheat_yield <- crop_wheat%>% filter(!(Climate == 'GPCC_Baseline'))

head(wheat_yield)

wheat_yield_bs <- crop_wheat%>% filter((Climate == 'GPCC_Baseline'))
wheat_yield_bs <- wheat_yield_bs %>% select(Climate,Tillage,Crop,Total_yield)
head(wheat_yield_bs)
nrow(wheat_yield_bs)
write.csv(wheat_yield_bs,'wheat_yield_bs.csv',row.names = F)

wheat_yield <-wheat_yield %>% select(Climate,Tillage,Crop,GCMs,Total_yield)

Tillage <- unique(wheat_yield$Tillage)
Crop <- unique(wheat_yield$Crop)
Climate <- unique(wheat_yield$Climate)

res <- NULL
for (i in Climate) {
  for (j in Tillage) {
    for (cp in Crop) {
      if ((j == 'DT'& cp == 'Wt-alf')|
          (j == 'NT'& cp == 'Wt-alf')|
          (j == 'RT'& cp == 'Wt-alf')){
        next
      }
      x <- wheat_yield %>% 
        group_by(Climate,Tillage,Crop,GCMs)%>%
        summarise(avg_yield = mean(Total_yield)) %>%
        filter(Climate == i&
                 Tillage == j&
                 Crop == cp ) %>% {.$avg_yield}
      mu1 <-  wheat_yield_bs %>% filter(Tillage == j &
                                          Crop == cp) %>% {.$Total_yield}
      t_test <- t.test(x,mu = mu1,
                       alternative = 'less',
                       conf.level = 0.95)
      if (t_test$p.value < 0.001){
        print(paste(i,j,cp,t_test$p.value,'***',sep = ','))
        res <- rbind(res,paste(i,j,cp,t_test$p.value,'***',sep = ','))
      } else if (t_test$p.value < 0.01){
        print(paste(i,j,cp,t_test$p.value,'**',sep = ','))
        res <- rbind(res,paste(i,j,cp,t_test$p.value,'**',sep = ','))
      } else if (t_test$p.value < 0.05){
        print(paste(i,j,cp,t_test$p.value,'*',sep = ','))
        res <- rbind(res,paste(i,j,cp,t_test$p.value,'*',sep = ','))
      }
    }
  }
}

res
write.csv(res,'yield_t_test.csv',row.names = F)
