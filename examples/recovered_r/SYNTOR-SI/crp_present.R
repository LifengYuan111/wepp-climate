# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-SI\crp_present.R
# Source SHA256: 3C66B74A9B9EC40AE4615697F60DDF0B631F13970C050A3B92E326C93C450F5B
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
## deal with crop out from wepp
crop <- read.csv('<LOCAL_PATH_REDACTED>',header = F,sep = ':',
                 stringsAsFactors = F)
colnames(crop) <- c('Name','Product')
crop <- as.data.frame(crop)
crop
head(crop)
tail(crop)
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
  Climate = 'Baseline',
  GCM = str_sub(Name,-10,-7),
  Harvest = as.numeric(str_extract(Product,'\\d{2,3}')),
  Yield = as.numeric(str_extract_all(Product,'0\\.\\d{3}')),
  Yearly_Yield = ifelse(grepl('-a_',Name) & (Harvest >= 100),round(Yield*Harvest/(100-33),3),Yield),
  Total_yield = Yearly_Yield * 80 * 200,
  downscale = c('SYNTOR-SI')
) -> crop

str(crop)
crop
#write.table(crop,file = 'crop_pres.csv',sep = ',',col.names = TRUE,row.names = FALSE)
crop <- crop %>% mutate(New_Crop = case_when(
  grepl('-a_',Name) & (Harvest >= 100) ~ 'Alfalfa',
  grepl('-a_',Name) & (Harvest < 100) ~ str_extract(Crop, '[[:upper:]]{1}[[:lower:]]{1}'),
  (Crop == 'Wt_double') & (Yield > 0.1) ~ 'Wt',
  (Crop == 'Wt_double') & (Yield < 0.1) ~ 'Sb',
  TRUE ~ Crop
))

class(crop)
head(crop)
tail(crop)
nrow(crop)
crp_pres <- crop %>% select(Climate,GCM,Tillage,New_Crop,Total_yield,downscale)
head(crp_pres)
nrow(crp_pres)
crp_pres
crp_pres %>% group_by(New_Crop) %>%
  summarise(yield = mean(Total_yield)) 
head(crp_pres)
head(crp_f1r4)


crop_all <- rbind(crp_pres,crp_f1r4,crp_f1r8,crp_f2r4,crp_f2r8)

write.csv(a,'currentyield.csv')


# load crop yield from csv.file
crop_yield <- read.csv('Crop_yield.csv',row.names = 1)
crop_yield <- crop_yield %>% select(c(1:6))
colnames(crop_yield) <- c('Crop','Baseline','F1R4.5','F1R8.5','F2R4.5','F2R8.5')
crop_yield
str(crop_yield)
typeof(crop_yield)
library(scales)
crop_yield2 <- round(apply(crop_yield,2,scales::rescale),2)
crop_yield2 <- as.data.frame(crop_yield2)
class(crop_yield2)
crop_yield2

#colour = c("#00AFBB", "#E7B800", "#FC4E07","#BB3099","#EE0099","#0000AC"))

#ggsave('rose1.jpeg',device = 'jpeg',dpi = 300)
crop_yield %>% gather(Baseline:F2R8.5,key = 'GCMs',value = 'Yield') %>%
  ggBar(aes(x=Crop,fill=GCMs,y=Yield),stat = 'identity',polar = T, palette='Greens',
        width=1,color='black',size=0.1,interactive = T,labelsize = 1) 


# plot crop yield graph
#ggsave('crop_yield126.jpeg',device = 'jpeg',dpi=300)
library(ggrepel)
crop_yield %>% gather(Baseline:F2R8.5,key = 'GCMs',value = 'Yield') %>%
  ggplot(aes(x=reorder(Crop,-Yield),y=Yield,fill=GCMs)) + 
  geom_col(color='black',position = 'dodge') +
  #geom_text_repel(aes(x=reorder(Crop,-Yield),label=Yield,vjust=-0.6),position='identity', direction = 'both') +
  #geom_text_repel(aes(label = Yield,hjust=0,vjust=-1.1,angel = 45),
                  # position = position_dodge(width=0.85),force_pull  = 0.5,
                  # min.segment.length = 0, seed = 42, box.padding = 0.5) +
  geom_text(aes(x=reorder(Crop,-Yield),label=round(Yield,0),hjust = 0.5,vjust=-0.7),position=position_dodge(width = 0.9)) +
  scale_fill_d3(alpha = 0.35) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     breaks = seq(0,11000,1000),
                     expand = c(0,0),
                     limits = c(0,11000)) +
  xlab('Crop') + ylab('Crop yield (kg/ha/yr)') +
  theme_agile(plot_grid = F,vert_grid = F) +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.99,0.99),
         legend.justification = c(1,1),
         legend.text = element_text(size=22),
         legend.background = element_blank(),
         panel.background = element_blank(),
         panel.border = element_blank()
  )


## finally plot figure 5 with se bar
crop_all$cli <- gsub('base','Baseline',crop_all$cli)
crop_all$cli <- gsub('F1R4','F1R4.5',crop_all$cli)
crop_all$cli <- gsub('F1R8','F1R8.5',crop_all$cli)
crop_all$cli <- gsub('F2R4','F2R4.5',crop_all$cli)
crop_all$cli <- gsub('F2R8','F2R8.5',crop_all$cli)

crop_all <- rbind(crop_pres,crp_f1r4,crp_f1r8,crp_f2r4,crp_f2r8)

crop_all %>% mutate(Crop_name = case_when(
  New_Crop == 'Alfalfa'~ New_Crop,
  New_Crop == 'Sg'~'Sorghum',
  New_Crop == 'Wt'~'Wheat',
  New_Crop == 'Ct'~'Cotton',
  New_Crop == 'Ca'~'Canola',
  New_Crop == 'Sb'~'Soybean',
  TRUE~ New_Crop
)) -> crop_all
crp_base <- crop_all[which(crop_all$Climate == 'Baseline'),]
crp_base %>% group_by(Crop_name) %>% mutate(base_crop = mean(Total_yield)) -> crp_base
crp_base
crp_others <- crop_all[!(crop_all$Climate == 'Baseline'),]
crp_others
head(crp_others)
crp_others$Crop_name <- factor(crp_others$Crop_name,levels = c('Alfalfa',
                                                               'Sorghum',
                                                               'Wheat',
                                                               'Soybean',
                                                               'Canola',
                                                               'Cotton'))
                               

#ggsave('crop_yield.jpeg',device='jpeg',dpi=300)
# finally plot figure 5 with se bar
# plotting LDD-Figure2
library(scales)
library(ggsci)
crp_others %>% group_by(Crop_name) %>% 
  #ggplot(aes(x=reorder(Crop_name,-Total_yield),y=Total_yield)) +
  ggplot(aes(x=Crop_name,y=Total_yield)) +
  stat_summary(aes(group=Climate),geom='errorbar',
               position = position_dodge(width = 0.9),
               fun.data = mean_se,width = 0.45)+
  stat_summary(aes(group=Climate),geom='col',position = 'dodge',fill='white',
               fun.y = mean) +
  stat_summary(aes(fill=Climate,group=Climate),geom='col',position = 'dodge',
               fun.y = mean) +
  stat_summary(aes(label=round(..y..,0),group=Climate),geom='text',fun.y= mean,
               position= position_dodge(width = 0.9),color = 'black',hjust=1.15,vjust=0.5,angle=90) +
  geom_col(data=crp_base,aes(x=reorder(Crop_name,-base_crop),y=base_crop),
           position = 'dodge',alpha=0,color='black') +
  geom_text(data=crp_base,aes(x=reorder(Crop_name,-base_crop),y=base_crop,label=round(..y..,0)),
            vjust=-0.2,size=4) +
  xlab('Crop') +
  labs(y = expression(paste('kg ','ha'^-1,'yr'^-1))) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     limits = c(0,11000),
                     breaks = seq(0,11000,1000),
                     expand=c(0,0),
                     oob = rescale_none) +
  scale_fill_tron(alpha = 0.5) +
  theme_bw() +
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 13,color='black'),
         axis.text.y = element_text(size = 13,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.97,0.97),
         legend.justification = c(1,1),
         legend.text = element_text(size=16),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank()
  ) 
ggsave('Figure2_rev.tiff',device='tiff',dpi=300)

crop_all <- rbind(crop_pres,crp_f1r4,crop_f1r8,crop_f2r4,crop_f2r8)
crop_all %>% mutate(Crop_name = case_when(
  New_Crop == 'Alfalfa'~ New_Crop,
  New_Crop == 'Sg'~'Sorghum',
  New_Crop == 'Wt'~'Wheat',
  New_Crop == 'Ct'~'Cotton',
  New_Crop == 'Ca'~'Canola',
  New_Crop == 'Sb'~'Soybean',
  TRUE~ New_Crop
)) -> crop_all
crop_all %>% group_by(cli,Crop_name) %>% summarise(yield = mean(Total_yield)) %>%
  spread(cli,yield) -> a
write.csv(a,'Crop_yield.csv')
library(scales)
# crop yield graph with se bar 
crop_all %>% group_by(cli,Crop_name) %>% summarise(avg_yield = mean(Total_yield),
                                                   ymin = min(Total_yield),
                                                   ymax = max(Total_yield),
                                                   sd_yield = sd(Total_yield),
                                                   n = n(),
                                                   se_yield = sd_yield/sqrt(n)) %>%
  ggplot(aes(x=reorder(Crop_name,-avg_yield),y=avg_yield,group=cli)) +
  stat_summary(aes(fill=cli),geom ='bar',fun.y = mean,position = 'dodge')+
  geom_errorbar(aes(ymin=(avg_yield - se_yield),ymax=(avg_yield + se_yield)),
               position = position_dodge(width = 0.9),
               width = 0.45) +
  stat_summary(aes(label=round(..y..,0)),geom='text',fun.y= mean,
               position= position_dodge(width = 0.9),color = 'black',hjust=1.5,vjust=0.5,angle=90) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     limits = c(0,12000),
                     breaks = seq(0,12000,1000),
                     expand=c(0,0),
                     oob = rescale_none) +
  scale_fill_tron(alpha = 0.5) +
  xlab('Crop') + ylab('Crop yield (kg/ha/yr)') +
  theme_bw() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.97,0.97),
         legend.justification = c(1,1),
         legend.text = element_text(size=16),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank()
  ) 


# crop yield graph without se bar
crop_all %>% group_by(cli,Crop_name) %>% summarise(avg_yield = mean(Total_yield))%>%
  ggplot(aes(x=reorder(Crop_name,-avg_yield),y=avg_yield,group=cli)) +
  stat_summary(aes(fill=cli),geom ='bar',fun.y = mean,position = 'dodge')+
  stat_summary(geom='errorbar',
               position = position_dodge(width = 0.9),
               fun.data = mean_se,width = 0.15)+
  stat_summary(aes(label=round(..y..,0)),geom='text',fun.y= mean,
               position= position_dodge(width = 0.9),color = 'black',hjust=1.5,vjust=0.5,angle=90) +
  scale_y_continuous(labels=function(x) format(x, big.mark = ",", scientific = FALSE),
                     limits = c(0,11000),
                     breaks = seq(0,11000,1000),
                     expand=c(0,0),
                     oob = rescale_none) +
  scale_fill_tron(alpha = 0.5) +
  xlab('Crop') + ylab('Crop yield (kg/ha/yr)') +
  theme_bw() +
  theme( axis.title.x = element_text(size = 13),
         axis.title.y = element_text(size = 13),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.97,0.97),
         legend.justification = c(1,1),
         legend.text = element_text(size=16),
         legend.background = element_blank(),
         axis.line = element_line(color='black'),
         panel.background = element_blank(),
         panel.border = element_blank(),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank()
  ) 
