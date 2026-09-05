# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: SYNTOR-SI\sumry_out(all).R
# Source SHA256: 39D8FF06C2292EFF1020B8E7969FF19ECD3EC66ECB966C8E4FA95E96AA51305A
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
## deal with sumry out from wepp
sumry <- read.table('..//..//output//result analysis//sum_out_pres.txt',header = F,sep = '',
                 stringsAsFactors = F)
head(sumry)
colnames(sumry) <- c('Name','V2','V3','Total Precp Depth','Total Irrig Depth','Total Runoff from Rainfall','Total Runoff from Snowmelt',
                     'Total Runoff from Irrig','Total Detach','Interrill Detach','Total Deposition','Sediment Yield',
                     'ER')
sumry_pres<- sumry
colnames(sumry_pres) <- c('Name','V2','V3','Precp','Irr','Runoff','Runoff_snow',
                      'Runoff_irr','Soil_loss','Ir_detach','Tol_depos','SedimentYield',
                      'ER')
sumry_pres<- as.data.frame(sumry_pres)
sumry_pres%>% select(Name,Precp,Runoff,Soil_loss,SedimentYield) -> sumry_pres

#class(sumry_pres)

sumry_pres%>% mutate(Tillage = case_when(
  grepl('sum_C',Name) ~ 'CT',
  grepl('sum_D',Name) ~ 'DT',
  grepl('sum_N',Name) ~ 'NT',
  grepl('sum_R',Name) ~ 'RT',
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
  Climate = str_extract(Name,'([:upper:]{2,3}|[:upper:]{1}\\d{1})_[:upper:]{1}')
) -> sumry_pres

#str(sumry_pres)
sumry_pres
write.table(sumry_pres,file = 'sumry_pres.csv',sep = ',',col.names = TRUE,row.names = FALSE)


# class(sumry)
# sumry %>% group_by(Tillage) %>%
#   summarise(mean(Yield))
