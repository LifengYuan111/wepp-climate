# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\crp_f2r4.R
# Source SHA256: 42694D8904F1068B0C7C814C4DA02E8F9747F55D3B73738D77604084B9177857
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
  Harvest = as.numeric(str_extract(Product,'\\d{2,3}')),
  Yield = as.numeric(str_extract_all(Product,'0\\.\\d{3}')),
  Yearly_Yield = ifelse(grepl('-a_',Name) & (Harvest >= 100),round(Yield*Harvest/(100-33),3),Yield),
  Total_yield = Yearly_Yield * 80 * 200,
  Climate = 'F2R4.5'
) -> crop

str(crop)
crop
#write.table(crop,file = 'crop_f2r4.csv',sep = ',',col.names = TRUE,row.names = FALSE)

head(crop)
crop_wheat_f2r4 <- crop %>% filter(Crop == 'Wt'|
                                     Crop == 'Wt-alf'|
                                     Crop == 'Wt_double')

head(crop_wheat_f2r4)

crop_wheat_f2r4 <- crop_wheat_f2r4 %>% mutate(New_Crop = case_when(
  grepl('-a_',Name) & (Harvest >= 100) ~ 'Alfalfa',
  grepl('-a_',Name) & (Harvest < 100) ~ paste(str_extract(Crop, '[[:upper:]]{1}[[:lower:]]{1}'),'alf',sep='-'),
  (Crop == 'Wt_double') & (Yield >= 0.1) ~ 'Wt_double',
  (Crop == 'Wt_double') & (Yield < 0.1) ~ 'Sb',
  TRUE ~ Crop
))
crop_wheat_f2r4 <- crop_wheat_f2r4 %>% filter(!(New_Crop == 'Alfalfa'|
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
  summarise(Yield = mean(Total_yield)) -> crp_f2r4

crop %>% group_by(Climate,GCM,Tillage,New_Crop) %>%
  summarise(Yield = mean(Total_yield)) -> crp_till_f2r4
