# ============================================================================
# RECOVERED HISTORICAL RESEARCH SCRIPT
# Original relative path: GPCC-NO-SI\cli_scenario_temperature.R
# Source SHA256: B197A83AFBF2DFB8F701403685631568EA9865FE7B320A2EE1CF101E784028E4
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
temp_sheet_name_f1r4<- dir('<LOCAL_PATH_REDACTED>')
dt_f1r4 <- dir('<LOCAL_PATH_REDACTED>',full.names = T) %>% map(read.table,sep='',skip=15,header=F,stringsAsFactors=F)
names(dt_f1r4) <- temp_sheet_name_f1r4
dt_f1r4
cli_f1r4 <- dt_f1r4
head(cli_f1r4)
cli_f1r4 <- lapply(cli_f1r4,function(x) cli_f1r4 = x[c(1:3,8,9)])
tmean <- data.frame(days = 1:36525)
for (i in 1:length(cli_f1r4)){
  colnames(cli_f1r4[[i]]) <- c('day','mon','year','tmax','tmin')
  cli_f1r4[[i]]$tmean <- (cli_f1r4[[i]]$tmax + cli_f1r4[[i]]$tmin)/2
  tmean <- cbind(tmean,cli_f1r4[[i]]$tmean)
}
ncol(tmean)
colnames(tmean) <- c(1:26)
tmean %>% select(2:26) %>% transmute(tmean_f1r4 = rowMeans(.)) -> cli_f1r4_tmean 
head(cli_f1r4_tmean)
tail(cli_f1r4_tmean)
