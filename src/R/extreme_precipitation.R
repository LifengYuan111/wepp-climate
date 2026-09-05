# Reusable precipitation-summary functions recovered from the historical
# GPCC/SYNTOR analysis workflow.

precipitation_statistics <- function(
    precipitation,
    wet_day_threshold = 0.25,
    probs = c(0.90, 0.95, 0.99, 0.999),
    na.rm = TRUE) {

  x <- precipitation
  if (!is.numeric(x)) {
    stop("precipitation must be numeric")
  }

  wet <- x[!is.na(x) & x >= wet_day_threshold]

  if (length(wet) == 0L) {
    stop("No precipitation values meet the wet-day threshold")
  }

  q <- stats::quantile(wet, probs = probs, na.rm = na.rm, names = FALSE)

  data.frame(
    n_wet = length(wet),
    median = stats::median(wet, na.rm = na.rm),
    p90 = q[which.min(abs(probs - 0.90))],
    p95 = q[which.min(abs(probs - 0.95))],
    p99 = q[which.min(abs(probs - 0.99))],
    p99_9 = q[which.min(abs(probs - 0.999))],
    mean = base::mean(wet, na.rm = na.rm),
    sd = stats::sd(wet, na.rm = na.rm)
  )
}

annual_precipitation <- function(data, year_col = "year", precip_col = "prcp") {
  if (!all(c(year_col, precip_col) %in% names(data))) {
    stop("Required year/precipitation columns are missing")
  }

  years <- data[[year_col]]
  prcp <- data[[precip_col]]
  totals <- tapply(prcp, years, sum, na.rm = TRUE)

  data.frame(
    year = names(totals),
    precipitation = as.numeric(totals),
    row.names = NULL,
    stringsAsFactors = FALSE
  )
}