# Recovered historical R workflows

This directory contains **sanitized historical research scripts** recovered from
the original WEPP climate-impact workspace.

They are published for scientific provenance and code archaeology. They should
not be interpreted as modern standalone packages.

## Why these scripts are separate from `src/R`

`src/R/` contains cleaned reusable functions intended to be portable.

`examples/recovered_r/` preserves representative historical analysis logic,
including publication plotting, crop/tillage processing, GCM ensemble analysis,
WEPP event-output extraction, runoff/soil-loss calculations, and climate
statistics.

## Sanitization

The recovery process:

- reads the original historical files without modifying them;
- replaces local Windows absolute paths with `<LOCAL_PATH_REDACTED>`;
- replaces UNC/network paths with `<NETWORK_PATH_REDACTED>`;
- redacts email addresses;
- preserves the historical file names and scenario-folder structure;
- records SHA-256 hashes of both the original and sanitized copies.

## Reproducibility warning

Many historical scripts were written as interactive research-analysis scripts.
They may depend on objects created by earlier scripts, historical working
directories, large climate files, WEPP outputs, package versions, and model
executables that are not distributed here.

Use the cleaned functions under `src/R/` for new work.