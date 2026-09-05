# Recovered historical R workflows

This directory contains **sanitized historical research scripts** recovered from
the original WEPP climate-impact workspace.

They are published for scientific provenance and code archaeology. They should
not be interpreted as a modern standalone package.

## Why these scripts are separate from `src/R`

`src/R/` contains cleaned reusable functions intended to be portable.

`examples/recovered_r/` preserves representative historical analysis logic,
including publication plotting, crop/tillage processing, GCM ensemble analysis,
WEPP event-output extraction, runoff/soil-loss calculations, and climate
statistics.

## Sanitization

The Phase 7B recovery process:

- reads the original historical files without modifying them;
- verifies original SHA-256 values against the Phase 7 manifest;
- replaces local Windows absolute paths with `<LOCAL_PATH_REDACTED>`;
- redacts email addresses;
- preserves R regular-expression strings such as `\\d{2,3}`;
- preserves historical file names and scenario-folder structure.

## Duplicate files

Some SI and NO-SI branches contain byte-identical historical scripts. They are
retained intentionally to preserve the original workflow tree. The Phase 7B
audit identifies these duplicates explicitly.

## Reproducibility warning

Many historical scripts were written as interactive research-analysis scripts.
They may depend on objects created by earlier scripts, historical working
directories, large climate files, WEPP outputs, package versions, and model
executables that are not distributed here.

A successful R parse check means syntax is readable by R; it does not imply
end-to-end reproduction.

Use the cleaned functions under `src/R/` for new work.