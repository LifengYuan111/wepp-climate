# Base-R smoke tests for dependency-light WEPP climate helpers.
# Run with: Rscript tests/test_r_base_helpers.R

source(file.path("src", "R", "scenario_mapping.R"))
source(file.path("src", "R", "extreme_precipitation.R"))
source(file.path("src", "R", "ensemble_statistics.R"))
source(file.path("src", "R", "runoff_soilloss.R"))

stopifnot(
  identical(
    normalize_wepp_scenario("F1R4.5"),
    "RCP4.5 (2021-2050)"
  )
)

co2 <- wepp_co2_lookup()
stopifnot(
  co2$co2_ppm[co2$condition == "RCP8.5 (2051-2080)"] == 646
)

p <- precipitation_statistics(c(0, 0.1, 1, 2, 3, NA))
stopifnot(p$n_wet == 3L)
stopifnot(abs(p$mean - 2) < 1e-12)

annual <- annual_precipitation(
  data.frame(year = c(2000, 2000, 2001), prcp = c(1, 2, 4))
)
stopifnot(annual$precipitation[annual$year == "2000"] == 3)

ens <- ensemble_summary(
  data.frame(
    scenario = c("A", "A", "B"),
    runoff = c(1, 3, 5)
  ),
  group_cols = "scenario",
  value_cols = "runoff"
)
stopifnot(nrow(ens) == 2L)

stopifnot(percent_change(110, 100) == 10)
stopifnot(is.na(percent_change(1, 0)))

cat("R base-helper smoke tests passed.\n")