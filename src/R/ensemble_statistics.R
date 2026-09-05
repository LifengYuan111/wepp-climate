# Generic ensemble summaries for WEPP climate-impact outputs.

ensemble_summary <- function(
    data,
    group_cols,
    value_cols,
    na.rm = TRUE) {

  missing_cols <- setdiff(c(group_cols, value_cols), names(data))
  if (length(missing_cols) > 0L) {
    stop("Missing columns: ", paste(missing_cols, collapse = ", "))
  }
  if (length(group_cols) == 0L || length(value_cols) == 0L) {
    stop("group_cols and value_cols must both be non-empty")
  }

  # Keep NA grouping values rather than silently dropping those rows.
  group_frame <- data[group_cols]
  group_frame[] <- lapply(group_frame, function(x) {
    x <- as.character(x)
    x[is.na(x)] <- "<NA>"
    x
  })

  interaction_key <- interaction(
    group_frame,
    drop = TRUE,
    lex.order = TRUE
  )
  pieces <- split(data, interaction_key, drop = TRUE)

  summarize_one <- function(x) {
    if (na.rm) {
      x <- x[!is.na(x)]
    } else if (anyNA(x)) {
      return(c(mean = NA_real_, sd = NA_real_, min = NA_real_,
               max = NA_real_, range = NA_real_, n = sum(!is.na(x))))
    }

    if (length(x) == 0L) {
      return(c(mean = NA_real_, sd = NA_real_, min = NA_real_,
               max = NA_real_, range = NA_real_, n = 0))
    }

    c(
      mean = mean(x),
      sd = stats::sd(x),
      min = min(x),
      max = max(x),
      range = diff(range(x)),
      n = length(x)
    )
  }

  out <- lapply(pieces, function(d) {
    group_values <- d[1, group_cols, drop = FALSE]
    stats_list <- lapply(value_cols, function(v) summarize_one(d[[v]]))
    names(stats_list) <- value_cols

    stats_df <- as.data.frame(
      as.list(unlist(stats_list)),
      check.names = FALSE
    )
    cbind(group_values, stats_df, row.names = NULL)
  })

  if (length(out) == 0L) {
    return(data.frame())
  }

  do.call(rbind, out)
}