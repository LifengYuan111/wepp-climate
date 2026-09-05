# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\crp_f1r8.R
# Source SHA256: 725E54B86C6B0A999E3E0C4B05CE78D143F57F97B09F83091A2980FA6AFF3CE4
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
  GCM = str_extract(Name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}'),
  Harvest = as.numeric(str_extract(Product,'<NETWORK_PATH_REDACTED>')),
  Yield = as.numeric(str_extract_all(Product,'0\\.\\d{3}')),
  Yearly_Yield = ifelse(grepl('-a_',Name) & (Harvest >= 100),round(Yield*Harvest/(100-33),3),Yield),
  Total_yield = Yearly_Yield * 80 * 200,
  Climate = 'F1R8.5'
) -> crop

str(crop)
crop
#write.table(crop,file = 'crop_f1r8.csv',sep = ',',col.names = TRUE,row.names = FALSE)

head(crop)
crop_wheat_f1r8 <- crop %>% filter(Crop == 'Wt'|
                                     Crop == 'Wt-alf'|
                                     Crop == 'Wt_double')

head(crop_wheat_f1r8)

crop_wheat_f1r8 <- crop_wheat_f1r8 %>% mutate(New_Crop = case_when(
  grepl('-a_',Name) & (Harvest >= 100) ~ 'Alfalfa',
  grepl('-a_',Name) & (Harvest < 100) ~ paste(str_extract(Crop, '[[:upper:]]{1}[[:lower:]]{1}'),'alf',sep='-'),
  (Crop == 'Wt_double') & (Yield >= 0.1) ~ 'Wt_double',
  (Crop == 'Wt_double') & (Yield < 0.1) ~ 'Sb',
  TRUE ~ Crop
))
crop_wheat_f1r8 <- crop_wheat_f1r8 %>% filter(!(New_Crop == 'Alfalfa'|
                                                  New_Crop == 'Sb'))
#-----------------------------------------------
class(crop)
crop <- crop %>% mutate(New_Crop = case_when(
  grepl('-a_',Name) & (Harvest >= 100) ~ 'Alfalfa',
  grepl('-a_',Name) & (Harvest < 100) ~ str_extract(Crop, '[[:upper:]]{1}[[:lower:]]{1}'),
  (Crop == 'Wt_double') & (Yield >= 0.1) ~ 'Wt',
  (Crop == 'Wt_double') & (Yield < 0.1) ~ 'Sb',
  TRUE ~ Crop
))

crop %>% group_by(Climate,GCM,New_Crop) %>%
  summarise(Yield = mean(Total_yield)) -> crp_f1r8


crop %>% group_by(Climate,GCM,Tillage,New_Crop) %>%
  summarise(Yield = mean(Total_yield)) -> crp_till_f1r8
