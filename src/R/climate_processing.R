# Climate-scenario helpers reconstructed from historical WEPP research scripts.
# This file removes machine-specific paths but intentionally keeps the original
# scenario labels used by the analyses.

scenario_label <- function(x) {
  dplyr::case_when(
    x == "F1R4.5" ~ "RCP4.5 (2021-2050)",
    x == "F1R8.5" ~ "RCP8.5 (2021-2050)",
    x == "F2R4.5" ~ "RCP4.5 (2051-2080)",
    x == "F2R8.5" ~ "RCP8.5 (2051-2080)",
    TRUE ~ x
  )
}

read_wepp_climate_daily <- function(path, skip = 15) {
  x <- utils::read.table(
    path,
    sep = "",
    skip = skip,
    header = FALSE,
    stringsAsFactors = FALSE
  )
  x <- x[, 1:4]
  names(x) <- c("day", "month", "year", "precip_mm")
  x
}

read_climate_directory <- function(directory, scenario = NULL) {
  files <- list.files(directory, full.names = TRUE)
  if (length(files) == 0L) {
    stop("No climate files found in: ", directory)
  }

  out <- lapply(files, function(path) {
    x <- read_wepp_climate_daily(path)
    x$GCM <- tools::file_path_sans_ext(basename(path))
    if (!is.null(scenario)) x$Climate <- scenario
    x
  })
  dplyr::bind_rows(out)
}

annual_precipitation_summary <- function(x) {
  x |>
    dplyr::group_by(.data$GCM, .data$Climate, .data$year) |>
    dplyr::summarise(
      annual_precip_mm = sum(.data$precip_mm, na.rm = TRUE),
      .groups = "drop"
    )
}
