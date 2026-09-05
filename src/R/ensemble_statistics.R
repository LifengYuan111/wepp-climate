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

  interaction_key <- interaction(data[group_cols], drop = TRUE, lex.order = TRUE)
  pieces <- split(data, interaction_key)

  out <- lapply(pieces, function(d) {
    group_values <- d[1, group_cols, drop = FALSE]

    stats_list <- lapply(value_cols, function(v) {
      x <- d[[v]]
      c(
        mean = mean(x, na.rm = na.rm),
        sd = stats::sd(x, na.rm = na.rm),
        min = min(x, na.rm = na.rm),
        max = max(x, na.rm = na.rm),
        range = diff(range(x, na.rm = na.rm))
      )
    })

    names(stats_list) <- value_cols
    stats_df <- as.data.frame(as.list(unlist(stats_list)), check.names = FALSE)
    cbind(group_values, stats_df, row.names = NULL)
  })

  do.call(rbind, out)
}