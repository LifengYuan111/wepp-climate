# Reusable precipitation-summary functions recovered from the historical
# GPCC/SYNTOR analysis workflow.

precipitation_statistics <- function(
    precipitation,
    wet_day_threshold = 0.25,
    na.rm = TRUE) {

  if (!is.numeric(precipitation)) {
    stop("precipitation must be numeric")
  }
  if (!is.numeric(wet_day_threshold) ||
      length(wet_day_threshold) != 1L ||
      is.na(wet_day_threshold)) {
    stop("wet_day_threshold must be one non-missing numeric value")
  }

  x <- precipitation
  if (na.rm) {
    x <- x[!is.na(x)]
  } else if (anyNA(x)) {
    stop("precipitation contains NA while na.rm = FALSE")
  }

  wet <- x[x >= wet_day_threshold]
  if (length(wet) == 0L) {
    stop("No precipitation values meet the wet-day threshold")
  }

  q <- stats::quantile(
    wet,
    probs = c(0.90, 0.95, 0.99, 0.999),
    na.rm = TRUE,
    names = FALSE
  )

  data.frame(
    n_wet = length(wet),
    median = stats::median(wet),
    p90 = q[1],
    p95 = q[2],
    p99 = q[3],
    p99_9 = q[4],
    mean = base::mean(wet),
    sd = stats::sd(wet)
  )
}

annual_precipitation <- function(data, year_col = "year", precip_col = "prcp") {
  if (!all(c(year_col, precip_col) %in% names(data))) {
    stop("Required year/precipitation columns are missing")
  }
  if (!is.numeric(data[[precip_col]])) {
    stop("Precipitation column must be numeric")
  }

  totals <- tapply(
    data[[precip_col]],
    data[[year_col]],
    sum,
    na.rm = TRUE
  )

  data.frame(
    year = names(totals),
    precipitation = as.numeric(totals),
    row.names = NULL,
    stringsAsFactors = FALSE
  )
}