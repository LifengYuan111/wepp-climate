# Phase 7 — R Code Recovery Report

Generated: 2026-09-05 09:47:52

## Source protection

Historical source: $SourceRoot

The source folder was read only. No original historical file was modified.

## Repository branch

$BranchName

Phase 7 is committed locally for review but is **not pushed automatically**.

## Recovery result

- Selected historical files: 49
- Recovered and sanitized: 49
- Missing: 0
- New portable R modules: 3

### Workflow families

- GPCC-NO-SI: 17 recovered scripts
- GPCC-SI: 7 recovered scripts
- SYNTOR-NO-SI: 13 recovered scripts
- SYNTOR-SI: 12 recovered scripts

## New portable modules

- src/R/scenario_mapping.R
- src/R/extreme_precipitation.R
- src/R/ensemble_statistics.R

## Historical-code location

examples/recovered_r/

Absolute local paths, UNC/network paths, and email addresses are removed from
the public-review copies. Original filenames and scenario-folder structure are
preserved.

## Scientific interpretation

The recovered scripts expose representative historical logic for:

- GPCC and SYNTOR climate-analysis branches
- SI and NO-SI scenario comparisons
- GCM ensemble processing
- precipitation percentile/extreme-event statistics
- WEPP event extraction
- runoff and soil-loss analysis
- crop yield and crop/tillage analysis
- significance/statistical processing
- publication tables and figures

Historical scripts may depend on upstream workspace objects and omitted large
datasets. They are therefore published as provenance/reference examples rather
than presented as a standalone R package.

## Release gate

Do not merge/push Phase 7 until docs/PHASE7_R_CODE_MANIFEST.csv,
docs/PHASE7_R_PARSE_CHECK.csv, and the recovered script tree have been
reviewed.