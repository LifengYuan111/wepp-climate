# R code index

Phase 7 adds two complementary layers:

1. **Portable modules under src/R/** for reusable analysis.
2. **Sanitized historical scripts under examples/recovered_r/** for scientific provenance.

## New portable modules

- src/R/scenario_mapping.R — scenario labels, crop codes, and documented CO2 scenario values.
- src/R/extreme_precipitation.R — wet-day precipitation median/percentile/mean/SD summaries and annual totals.
- src/R/ensemble_statistics.R — generic grouped ensemble mean/SD/range summaries.

## Recovered historical workflow families

### GPCC-NO-SI

- [$leaf](../examples/recovered_r/GPCC-NO-SI/cli_scenario_temperature.R) — climate
- [$leaf](../examples/recovered_r/GPCC-NO-SI/Crop and tillage.R) — crop-yield;management
- [$leaf](../examples/recovered_r/GPCC-NO-SI/crop schedule.R) — crop-yield;management
- [$leaf](../examples/recovered_r/GPCC-NO-SI/crp_f1r4.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-NO-SI/crp_f1r8.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-NO-SI/crp_f2r4.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-NO-SI/crp_f2r8.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-NO-SI/evt_all_extract.R) — wepp-event
- [$leaf](../examples/recovered_r/GPCC-NO-SI/evt_GCMs_100.R) — gcm-ensemble;wepp-event
- [$leaf](../examples/recovered_r/GPCC-NO-SI/evt_press_100year.R) — wepp-event
- [$leaf](../examples/recovered_r/GPCC-NO-SI/main.R) — analysis-driver
- [$leaf](../examples/recovered_r/GPCC-NO-SI/Precip_percentile.R) — climate;percent-change/statistics
- [$leaf](../examples/recovered_r/GPCC-NO-SI/pres_runoff.R) — runoff
- [$leaf](../examples/recovered_r/GPCC-NO-SI/runoff_GCMs.R) — gcm-ensemble;runoff
- [$leaf](../examples/recovered_r/GPCC-NO-SI/runoff_percent_change.R) — runoff;percent-change/statistics
- [$leaf](../examples/recovered_r/GPCC-NO-SI/soil_percent_change.R) — soil-loss;percent-change/statistics
- [$leaf](../examples/recovered_r/GPCC-NO-SI/Table 5.R) — publication-table

### GPCC-SI

- [$leaf](../examples/recovered_r/GPCC-SI/crp_f1r4.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-SI/crp_f1r8.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-SI/crp_f2r4.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-SI/crp_f2r8.R) — crop-yield
- [$leaf](../examples/recovered_r/GPCC-SI/evt_press_100year.R) — wepp-event
- [$leaf](../examples/recovered_r/GPCC-SI/Precip_percentile.R) — climate;percent-change/statistics
- [$leaf](../examples/recovered_r/GPCC-SI/Table 5.R) — publication-table

### SYNTOR-NO-SI

- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/cli_rainfall.R) — climate
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/climate data analysis.Rmd) — climate;analysis-driver
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/crp_f1r4.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/crp_f2r8.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/crp_present.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/crp_present_from_GPCC.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/Prec_runoff.R) — runoff
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/res_analysis.R) — analysis-driver
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/soil_loss.R) — soil-loss
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/sumry_out(all).R) — other
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/Table 3.R) — publication-table
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/Table 5S.R) — publication-table
- [$leaf](../examples/recovered_r/SYNTOR-NO-SI/Table2.R) — publication-table

### SYNTOR-SI

- [$leaf](../examples/recovered_r/SYNTOR-SI/cli_rainfal.R) — climate
- [$leaf](../examples/recovered_r/SYNTOR-SI/climate data analysis.Rmd) — climate;analysis-driver
- [$leaf](../examples/recovered_r/SYNTOR-SI/crp_f1r4.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-SI/crp_f1r4_from_GPCC-SI.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-SI/crp_f2r8.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-SI/crp_f2r8_from_GPCC-SI.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-SI/crp_present.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-SI/crp_present_from_GPCC-SI.R) — crop-yield
- [$leaf](../examples/recovered_r/SYNTOR-SI/Prec_runoff.R) — runoff
- [$leaf](../examples/recovered_r/SYNTOR-SI/soil_loss.R) — soil-loss
- [$leaf](../examples/recovered_r/SYNTOR-SI/sumry_out(all).R) — other
- [$leaf](../examples/recovered_r/SYNTOR-SI/tmax_tmin_calculate.R) — climate

## Interpretation

These historical scripts demonstrate the breadth of the original R workflow but are not claimed to reproduce every published figure/table without the original large inputs and historical software environment.