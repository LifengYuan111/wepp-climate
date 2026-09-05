# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\Table 5.R
# Source SHA256: E1C5F753FADB89E85844B0D2217C9C9AA501270A45FA5FCCF8FA5F4C11246CE2
#
# This is a sanitized copy recovered from the historical WEPP research workspace.
# Machine-specific absolute paths and email addresses were redacted.
# The scientific statements/calculations were otherwise retained as historical
# evidence. This file is not guaranteed to run without reconstructing its
# historical data objects, package versions, and upstream workflow state.
# ============================================================================
data <- read.csv('Table5-SYNTOR-SI.csv')
data
colnames(data) <- c('Tillage_system','Runoff','Soil_loss','Crop','Climate','Sig_run','Sig_soil')
head(data)
tail(data)
str(data)
data
data <- data %>% mutate_if(is.numeric,round,1)

data$Crop <- factor(data$Crop,ordered = T,
                    levels = c('Ca','Wt','Sb','Sg','Ct',
                               'Wt_double','Ca-alf','Wt-alf','Sb-alf',
                               'Sg-alf','Ct-alf'))

data %>% group_by(Climate) %>%
  summarise(Avg_runoff = mean(Runoff),
            Avg_Soilloss = mean(Soil_loss))
# finally plot runoff 
library(wesanderson)
ann_text <- data.frame(Tillage_system = 'DT',Crop = 'Ct-alf',lab = '(mm)',Climate='Baseline')
pal <- wes_palette("Zissou1", 11, type = "continuous")
data %>% arrange(desc(Runoff)) %>% 
  ggplot() + geom_tile(aes(x=Crop,y=reorder(Tillage_system,Runoff),fill=Runoff)) +
  geom_text(aes(x=Crop,y=reorder(Tillage_system,Runoff),label=Sig_run),stat='identity',hjust=-0.75,vjust=-0.35) +
  geom_text(aes(x=Crop,y=reorder(Tillage_system,Runoff),label=format(round(Runoff, 1), nsmall = 1)),stat='identity') +
  geom_text(data=ann_text,aes(x=Crop,y=Tillage_system),label=expression(paste('(mm ','yr'^-1,')'))) +
  facet_grid(rows = vars(Climate)) +
  xlab('Crop') + ylab('Tillage system') +
  scale_fill_gradientn(colours = pal)+
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         axis.line = element_line(color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.9,1),
         legend.justification = c(1,1),
         legend.text = element_text(size=12),
         legend.background = element_blank(),
         strip.background=element_rect(fill="white"),
         strip.text.y = element_blank(),
         panel.background = element_blank() 
  )-> r
r

head(data)


# finally plot soil loss with color scale
ann_text1 <- data.frame(Tillage_system = 'NT',Crop = 'Wt-alf',Climate='Baseline')
data %>% 
  ggplot() + geom_tile(aes(x=factor(Crop,ordered = T,levels = c('Sb','Ct','Sg','Ca','Wt',
                                                                'Wt_double','Ca-alf','Sg-alf',
                                                                'Sb-alf','Ct-alf','Wt-alf')),
                           y=factor(Tillage_system,ordered = T,levels = c('NT','DT','CT','RT')),fill=Soil_loss)) +
  geom_text(aes(x=factor(Crop,ordered = T,levels = c('Sb','Ct','Sg','Ca','Wt',
                                                     'Wt_double','Ca-alf','Sg-alf',
                                                     'Sb-alf','Ct-alf','Wt-alf')),
                y=factor(Tillage_system,ordered = T,levels = c('NT','DT','CT','RT')),label=Sig_soil,hjust=-0.75,vjust=-0.35),stat='identity') +
  geom_text(aes(x=Crop,y=reorder(Tillage_system,Soil_loss),label=format(round(Soil_loss, 1), nsmall = 1)),stat='identity') +
  geom_text(data=ann_text1,aes(x=Crop,y=Tillage_system),label = expression(paste('(t ','ha'^-1,'yr'^-1,')'))) +
  facet_grid(rows = vars(Climate)) +
  xlab('Crop') + ylab('') +
  scale_fill_gradientn(colours = c('green',pal),
                       breaks=c(1,5,10,15),
                       oob = scales::squish)+
  theme( axis.title.x = element_text(size = 14),
         axis.title.y = element_text(size = 14),
         axis.text.x = element_text(size = 12,color='black'),
         axis.text.y = element_text(size = 12,color='black'),
         axis.ticks.length = unit(0.2,'cm'),
         axis.line = element_line(color='black'),
         legend.title = element_blank(),
         legend.direction = 'horizontal',
         legend.position = c(0.9,0.9),
         legend.justification = c(1,1),
         legend.text = element_text(size=12),
         legend.background = element_blank(),
         strip.background=element_rect(fill="white"),
         strip.text.y = element_text(size = 12),
         panel.background = element_blank() 
  )->s
s
#ggsave('b.tiff',device = 'tiff',dpi = 300)
library(patchwork)
r + s
ggsave('Table5_new.tiff',device = 'tiff',dpi=300)



# filter any runoff from each scenario is larger than the baseline condition
data %>% select(Tillage_system,Runoff,Crop,Climate) %>% group_by(Climate,Crop) %>%
  summarise(Runoff = mean(Runoff))%>%
  spread(Climate,Runoff)%>%
  filter(F1R4.5 > Baseline,
         F1R8.5 > Baseline,
         F2R4.5 > Baseline,
         F2R8.5 > Baseline)

###################################################
y <- data.frame(n_year = c(1950:2049))
nrow(y)
y$n_year <- as.character(y$n_year)

runoff_100_f2r8 <- list()
for (i in 1:725){
  y %>% left_join(evt[[i]],by='n_year') %>% select(n_year,Runoff,Soilloss)%>% mutate(across(everything(),~replace_na(.x,0))) %>% 
    group_by(n_year)%>% summarise(Total_Soil_Loss = round(sum(Soilloss)*80/1600,3),
                                  Total_Runoff = sum(Runoff)) -> runoff_100_f2r8[[i]]
}

names(runoff_100_f2r8) <- evt_sheets_name_f2r8
head(runoff_100_f2r8)

for (i in 1:725){
  runoff_100_f2r8[[i]] %>% mutate(Tillage = case_when(
    grepl('evt_C',names(runoff_100_f2r8[i])) ~ 'CT',
    grepl('evt_D',names(runoff_100_f2r8[i])) ~ 'DT',
    grepl('evt_N',names(runoff_100_f2r8[i])) ~ 'NT',
    grepl('evt_R',names(runoff_100_f2r8[i])) ~ 'RT',
    TRUE ~ 'None'),
    Crop = case_when(
      grepl('-ca-a',names(runoff_100_f2r8[i])) ~ 'Ca-alf',
      grepl('-ca',names(runoff_100_f2r8[i])) ~ 'Ca',
      grepl('-ct-a',names(runoff_100_f2r8[i])) ~ 'Ct-alf',
      grepl('-ct',names(runoff_100_f2r8[i])) ~ 'Ct',
      grepl('-sb-a',names(runoff_100_f2r8[i])) ~ 'Sb-alf',
      grepl('-sb',names(runoff_100_f2r8[i])) ~ 'Sb',
      grepl('-sg-a',names(runoff_100_f2r8[i])) ~ 'Sg-alf',
      grepl('-sg',names(runoff_100_f2r8[i])) ~ 'Sg',
      grepl('-wt-a',names(runoff_100_f2r8[i])) ~ 'Wt-alf',
      grepl('-wt-D',names(runoff_100_f2r8[i])) ~ 'Wt_double',
      grepl('-wt',names(runoff_100_f2r8[i])) ~ 'Wt',
      TRUE ~ 'None'),
    Climate = str_extract(names(runoff_100_f2r8[i]),'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}')) -> runoff_100_f2r8[[i]]
}

runoff_GCMs_f2r8 <- data.frame()
for (i in 1:725){
  runoff_GCMs_f2r8 <- rbind(runoff_GCMs_f2r8,runoff_100_f2r8[[i]])
}
head(runoff_GCMs_f2r8)

runoff_GCMs_f2r8 %>% group_by(Climate,n_year) %>% summarise(avg_runoff = mean(Total_Runoff),
                                                            avg_soilloss = mean(Total_Soil_Loss)) -> r_GCMs_f2r8_sumry

r_GCMs_f2r8_sumry %>% filter (Climate == 'BC_L') %>% summarise(mean(avg_soilloss))

r_GCMs_f2r8_sumry %>% group_by(Climate) %>% summarise(ann_runoff = mean(avg_runoff),
                                                      ann_soil = mean(avg_soilloss))-> temp

write.csv(temp,'GCMs_f2r8_runoff.csv')

climate_name_f2r8 <- unique(r_GCMs_f2r8_sumry$Climate)

# t.test runoff between baseline and 25 GCMs 
for (i in climate_name_f2r8) {
  r_GCMs_f2r8_sumry %>% filter (Climate == i) %>% select(avg_runoff) -> f2r8_runoff
  p.value <- t.test(Avg_Ann_Runoff100_pres$ann_runoff,f2r8_runoff$avg_runoff,alternative = 'two.sided')$p.value
  if (p.value < 0.1) {
    print(paste(i,'p value under f2r8.5 is',p.value))
  }
  # p.mean <- t.test(Avg_Ann_Runoff100_pres$ann_runoff,f2r8_runoff$avg_runoff,alternative = 'two.sided')$estimate
  # print(paste(i,'estimate is:',p.mean))
}

# t.test soil loss between baseline and 25 GCMs 
for (i in climate_name_f2r8) {
  r_GCMs_f2r8_sumry %>% filter (Climate == i) %>% select(avg_soilloss) -> f2r8_soilloss
  p.value <- t.test(Avg_Ann_Soil100_pres$ann_soil,f2r8_soilloss$avg_soilloss,alternative = 'two.sided')$p.value
  if (p.value < 0.1) {
    print(paste(i,'p value under f2r8.5 is',p.value))
  }
}
