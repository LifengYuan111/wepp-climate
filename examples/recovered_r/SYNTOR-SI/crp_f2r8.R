# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-SI\crp_f2r8.R
# Source SHA256: 34830FDB16214B8F40A999DC26CFC4986C2F9BC5A48C083C3B09EC9D25D77666
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
  downscale = c('SYNTOR-SI')
) -> crop

str(crop)
crop
#write.table(crop,file = 'crop_f2r8.csv',sep = ',',col.names = TRUE,row.names = FALSE)
crop <- crop %>% mutate(New_Crop = case_when(
  grepl('-a_',Name) & (Harvest >= 100) ~ 'Alfalfa',
  grepl('-a_',Name) & (Harvest < 100) ~ str_extract(Crop, '[[:upper:]]{1}[[:lower:]]{1}'),
  (Crop == 'Wt_double') & (Yield >= 0.1) ~ 'Wt',
  (Crop == 'Wt_double') & (Yield < 0.1) ~ 'Sb',
  TRUE ~ Crop
))

class(crop)
head(crop)
crp_f2r8 <- crop %>% select(GCM,Tillage,New_Crop,Total_yield,downscale)
crp_f2r8$Climate <- 'F2R8.5'
nrow(crp_f2r8)
crp_f2r8 %>% group_by(New_Crop) %>%
  summarise(sum(Total_yield)/25) 
crp_f2r8 %>% select(Climate,GCM,Tillage,New_Crop,Total_yield,downscale) ->crp_f2r8
