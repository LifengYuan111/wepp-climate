# Scenario and crop-label helpers for the WEPP climate workflow.
#
# Stable labels recovered from the historical R workflow.

wepp_scenario_lookup <- function() {
  data.frame(
    code = c("F1R4.5", "F1R8.5", "F2R4.5", "F2R8.5"),
    rcp = c("RCP4.5", "RCP8.5", "RCP4.5", "RCP8.5"),
    period = c("2021-2050", "2021-2050", "2051-2080", "2051-2080"),
    label = c(
      "RCP4.5 (2021-2050)",
      "RCP8.5 (2021-2050)",
      "RCP4.5 (2051-2080)",
      "RCP8.5 (2051-2080)"
    ),
    stringsAsFactors = FALSE
  )
}

wepp_co2_lookup <- function() {
  data.frame(
    condition = c(
      "Baseline",
      "RCP4.5 (2021-2050)",
      "RCP4.5 (2051-2080)",
      "RCP8.5 (2021-2050)",
      "RCP8.5 (2051-2080)"
    ),
    co2_ppm = c(380, 449, 515, 473, 646),
    stringsAsFactors = FALSE
  )
}

normalize_wepp_scenario <- function(x) {
  lookup <- wepp_scenario_lookup()
  idx <- match(x, lookup$code)
  out <- x
  matched <- !is.na(idx)
  out[matched] <- lookup$label[idx[matched]]
  out
}

normalize_crop_code <- function(x) {
  mapping <- c(
    "Alfalfa" = "Alfalfa",
    "Sg" = "Sorghum",
    "Wt" = "Wheat",
    "Ct" = "Cotton",
    "Ca" = "Canola",
    "Sb" = "Soybean"
  )

  out <- unname(mapping[x])
  missing <- is.na(out) & !is.na(x)
  out[missing] <- x[missing]
  out
}