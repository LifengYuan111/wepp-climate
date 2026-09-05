# Crop-yield helpers reconstructed from repeated historical crp_*.R workflows.

normalize_crop_name <- function(x) {
  dplyr::case_when(
    x == "Alfalfa" ~ "Alfalfa",
    x == "Sg" ~ "Sorghum",
    x == "Wt" ~ "Wheat",
    x == "Ct" ~ "Cotton",
    x == "Ca" ~ "Canola",
    x == "Sb" ~ "Soybean",
    TRUE ~ x
  )
}

summarise_crop_yield <- function(data) {
  data |>
    dplyr::mutate(
      Crop_name = normalize_crop_name(.data$New_Crop),
      Climate = scenario_label(.data$Climate)
    ) |>
    dplyr::group_by(.data$Climate, .data$GCM, .data$Tillage, .data$Crop_name) |>
    dplyr::summarise(
      Yield = mean(.data$Yield, na.rm = TRUE),
      .groups = "drop"
    )
}
