# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-NO-SI\crp_present_from_GPCC.R
# Source SHA256: 6E9D0E4D4FCBE2C7D690ABF00095340C3AE5AC841C6ED25F3FCCAA241A776711
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
## deal with crop out from wepp
crop <- read.csv('<LOCAL_PATH_REDACTED>',header = F,sep = ':',
                 stringsAsFactors = F)
crop
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
  GCM = 'SYNTOR-NO-SI',
  Harvest = as.numeric(str_extract(Product,'<NETWORK_PATH_REDACTED>')),
  Yield = as.numeric(str_extract_all(Product,'0\\.\\d{3}')),
  Yearly_Yield = ifelse(grepl('-a_',Name) & (Harvest >= 100),round(Yield*Harvest/(100-33),3),Yield),
  Total_yield = Yearly_Yield * 80 * 200,
  Climate = c('Baseline')
) -> crop

str(crop)
crop

crop <- crop %>% mutate(New_Crop = case_when(
  grepl('-a_',Name) & (Harvest >= 100) ~ 'Alfalfa',
  grepl('-a_',Name) & (Harvest < 100) ~ str_extract(Crop, '[[:upper:]]{1}[[:lower:]]{1}'),
  (Crop == 'Wt_double') & (Yield >= 0.1) ~ 'Wt',
  (Crop == 'Wt_double') & (Yield < 0.1) ~ 'Sb',
  TRUE ~ Crop
))

class(crop)
crop %>% group_by(Climate,GCM,New_Crop) %>%
  summarise(Yield = mean(Total_yield)) -> crp_pres

crop_yield <- rbind(crp_pres,crp_f1r4,crp_f1r8,crp_f2r4,crp_f2r8)
crop_yield %>% group_by(Climate,GCM,New_Crop) %>%
  summarise(Yield = mean(Yield)) -> crop_yield

crop_all <- crop_yield
crop_all %>% mutate(Crop_name = case_when(
  New_Crop == 'Alfalfa'~ 'Alfalfa',
  New_Crop == 'Sg'~'Sorghum',
  New_Crop == 'Wt'~'Wheat',
  New_Crop == 'Ct'~'Cotton',
  New_Crop == 'Ca'~'Canola',
  New_Crop == 'Sb'~'Soybean',
  TRUE~ New_Crop
)) -> crop_all


crp_base <- crop_all[which(crop_all$Climate == 'Baseline'),]
crp_base %>% group_by(New_Crop) %>% mutate(base_crop = mean(Yield)) -> crp_base
crp_base$downscale <- c('SYNTOR-NO-SI')
write.csv(crp_base,'crp_base_Syntor_no_si.csv',row.names = F)
crp_others <- crop_all[!(crop_all$Climate == 'Baseline'),]
crp_others
crp_others$downscale <- c('SYNTOR-NO-SI')
write.csv(crp_others,'crp_others_Syntor_no_si.csv',row.names = F)

crp_others %>% mutate(Climate = case_when(
  Climate == 'F1R4.5'~ 'RCP4.5 (2021-2050)',
  Climate == 'F1R8.5'~ 'RCP8.5 (2021-2050)',
  Climate == 'F2R4.5'~ 'RCP4.5 (2051-2080)',
  Climate == 'F2R8.5'~ 'RCP8.5 (2051-2080)',
  TRUE ~ Climate
)) -> crp_others

crp_others$Climate <- factor(crp_others$Climate, ordered=T,
                             levels = c('RCP4.5 (2021-2050)',
                                        'RCP8.5 (2021-2050)',
                                        'RCP4.5 (2051-2080)',
                                        'RCP8.5 (2051-2080)'))

# finally plot figure 5 with se bar

library(scales)
crp_others %>% group_by(Crop_name) %>% 
  ggplot(aes(x=reorder(Crop_name,-Yield),y=Yield)) +
  stat_summary(aes(group=Climate),geom='errorbar',
               position = position_dodge(width = 0.9),
               fun.data = mean_se,width = 0.45)+
  stat_summary(aes(fill=Climate,group=Climate),geom='col',position = 'dodge',
               fun.y = mean) +
  stat_summary(aes(label=round(..y..,0),group=Climate),geom='text',fun.y= mean,
               position= position_dodge(width = 0.9),color = 'black',hjust=1.2,vjust=0.5,angle=90) +
  geom_col(data=crp_base,aes(x=reorder(Crop_name,-base_crop),y=base_crop),
           position = 'dodge',alpha=0,color='black') +
  geom_text(data=crp_base,aes(x=reorder(Crop_name,-base_crop),y=base_crop,label=round(..y..,0)),
            vjust=-0.4,size=4) +
  xlab('Crop') +
  labs(y = expression(paste('Crop yield (kg ','ha'^-1,'yr'^-1,')'))) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     limits = c(0,11000),
                     breaks = seq(0,11000,1000),
                     expand=c(0,0),
                     oob = rescale_none) +
  scale_fill_discrete() +
  theme_bw() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0.97,0.97),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank()
  ) 


crp_others %>% group_by(Crop_name) %>% 
  ggplot(aes(x=reorder(Crop_name,-Yield),y=Yield)) +
  stat_summary(aes(group=Climate),geom='errorbar',
               position = position_dodge(width = 0.9),
               fun.data = mean_se,width = 0.45)+
  stat_summary(aes(fill=Climate,group=Climate),geom='col',position = 'dodge',
               fun.y = mean) +
  stat_summary(aes(label=round(..y..,0),group=Climate),geom='text',fun.y= mean,
               position= position_dodge(width = 0.9),color = 'black',hjust=1.2,vjust=0.5,angle=90) +
  # geom_col(data=crp_base,aes(x=reorder(Crop_name,-base_crop),y=base_crop),
  #          position = 'dodge',alpha=0,color='black') +
  geom_segment(aes(x=0.5,xend=1.5,y=10406,yend=10406),color='black') +
  geom_segment(aes(x=1.5,xend=2.5,y=4310,yend=4310),color='black') +
  geom_segment(aes(x=2.5,xend=3.5,y=2206,yend=2206),color='black') +
  geom_segment(aes(x=3.5,xend=4.5,y=941,yend=941),color='black') +
  geom_segment(aes(x=4.5,xend=5.5,y=1555,yend=1555),color='black') +
  geom_segment(aes(x=5.5,xend=6.5,y=1716,yend=1716),color='black') +
  geom_text(data=crp_base,aes(x=reorder(Crop_name,-base_crop),y=base_crop,label=round(..y..,0)),
            vjust=-0.4,size=4) +
  xlab('Crop') +
  labs(y = expression(paste('Crop yield (kg ','ha'^-1,'yr'^-1,')'))) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     limits = c(0,11000),
                     breaks = seq(0,11000,1000),
                     expand=c(0,0),
                     oob = rescale_none) +
  scale_fill_discrete() +
  theme_bw() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0.97,0.97),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank()
  ) 
ggsave('crop_yield.tiff',device='tiff',dpi=300)

crop_base_no_alf <- crp_base%>%filter(New_Crop != 'Alfalfa')
crop_no_alf <- crp_others%>%filter(New_Crop != 'Alfalfa')

crop_no_alf %>% group_by(Crop_name) %>% 
  ggplot(aes(x=reorder(Crop_name,-Yield),y=Yield)) +
  stat_summary(aes(group=Climate),geom='errorbar',
               position = position_dodge(width = 0.9),
               fun.data = mean_se,width = 0.45)+
  stat_summary(aes(fill=Climate,group=Climate),geom='col',position = 'dodge',
               fun.y = mean) +
  stat_summary(aes(label=round(..y..,0),group=Climate),geom='text',fun.y= mean,
               position= position_dodge(width = 0.9),color = 'black',hjust=1.2,vjust=0.5,angle=90) +
  # geom_col(data=crp_base,aes(x=reorder(Crop_name,-base_crop),y=base_crop),
  #          position = 'dodge',alpha=0,color='black') +
  geom_segment(aes(x=0.5,xend=1.5,y=4310,yend=4310),color='black') +
  geom_segment(aes(x=1.5,xend=2.5,y=2206,yend=2206),color='black') +
  geom_segment(aes(x=2.5,xend=3.5,y=941,yend=941),color='black') +
  geom_segment(aes(x=3.5,xend=4.5,y=1555,yend=1555),color='black') +
  geom_segment(aes(x=4.5,xend=5.5,y=1716,yend=1716),color='black') +
  geom_text(data=crop_base_no_alf,aes(x=reorder(Crop_name,-base_crop),y=base_crop,label=round(..y..,0)),
            vjust=-0.4,size=4) +
  xlab('Crop') +
  labs(y = expression(paste('Crop yield (kg ','ha'^-1,'yr'^-1,')'))) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     limits = c(0,5000),
                     breaks = seq(0,5000,500),
                     expand=c(0,0),
                     oob = rescale_none) +
  scale_fill_discrete() +
  theme_bw() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         legend.title = element_blank(),
         legend.direction = 'vertical',
         legend.position = c(0.97,0.97),
         legend.justification = c(1,1),
         legend.text = element_text(size=14),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank()
  )
ggsave('crop_yield_no_alf.tiff',device='tiff',dpi=300)


crop_no_alf %>% group_by(Crop_name) %>% summarise(yield = mean(Yield))-> new_crop_yield
new_crop_yield$baseline <- c(1555,941,4310,1716,2206)
new_crop_yield
new_crop_yield %>% mutate(prop = round((yield-baseline)*100/baseline,1)) %>% arrange(prop)
