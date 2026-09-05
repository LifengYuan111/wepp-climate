# Shared helpers for WEPP runoff / soil-loss result analysis.

percent_change <- function(future, baseline) {
  ifelse(is.na(baseline) | baseline == 0, NA_real_,
         100 * (future - baseline) / baseline)
}

summarise_gcm_response <- function(data, value_col,
                                   groups = c("Climate", "GCM", "Tillage", "Crop")) {
  value_col <- rlang::ensym(value_col)
  data |>
    dplyr::group_by(dplyr::across(dplyr::all_of(groups))) |>
    dplyr::summarise(
      mean = mean(!!value_col, na.rm = TRUE),
      sd = stats::sd(!!value_col, na.rm = TRUE),
      n = sum(!is.na(!!value_col)),
      se = sd / sqrt(n),
      .groups = "drop"
    )
}
