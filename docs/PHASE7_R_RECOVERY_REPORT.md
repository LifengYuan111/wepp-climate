# Phase 7 — R Code Recovery Report

Generated: 2026-09-05
Phase 7B audit updated: 2026-09-05 10:16:50

## Source protection

Historical source: $SourceRoot

The historical source folder was used as **read-only input**. Phase 7/7B writes
only to the Git working repository.

## Repository branch

$branch

The recovery remains on a review branch until explicitly merged.

## Recovery result

- Selected historical files: 49
- Recovered and sanitized: 49
- Missing: 0
- Workflow families:
  - GPCC-NO-SI: 17
  - GPCC-SI: 7
  - SYNTOR-NO-SI: 13
  - SYNTOR-SI: 12

## Public-code layers

- src/R/: cleaned, portable helper modules.
- examples/recovered_r/: sanitized historical research scripts retained for
  provenance and inspection.

## Phase 7B correction

The original Phase 7 sanitizer mistakenly treated the R regular-expression
literal \\d{2,3} as if it were a UNC/network path in 19 crop-yield scripts.
Phase 7B rebuilt all 49 recovered files from SHA-256-verified originals and
preserved those regex literals.

## Validation

See:

- docs/PHASE7B_AUDIT_REPORT.md
- docs/PHASE7B_R_REPAIR_MANIFEST.csv
- docs/PHASE7_R_PARSE_CHECK.csv

No automatic push or merge is performed.