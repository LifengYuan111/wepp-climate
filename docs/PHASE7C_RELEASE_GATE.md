# Phase 7C - R-Code Release Gate

Generated: 2026-09-05 10:33:40

## Release decision

**PASS - approved for merge into main.**

## Verified inventory

- 49 recovered historical R/Rmd scripts
- 6 portable R modules under src/R/
- 49/49 historical source manifest rows
- 49/49 Phase 7B reconstruction rows

## R validation

- Portable R modules: **6/6 PASS**
- Historical R/Rmd scripts: **41/49 PASS**
- Preserved historical syntax failures: **8**

The eight historical parse failures are retained as provenance artifacts and
are not silently edited merely to force syntax success.

## Historical parse failures
- examples/recovered_r/GPCC-NO-SI/Crop and tillage.R
- examples/recovered_r/GPCC-NO-SI/crop schedule.R
- examples/recovered_r/GPCC-NO-SI/evt_GCMs_100.R
- examples/recovered_r/GPCC-NO-SI/Table 5.R
- examples/recovered_r/GPCC-SI/Table 5.R
- examples/recovered_r/SYNTOR-NO-SI/Table 3.R
- examples/recovered_r/SYNTOR-NO-SI/Table 5S.R
- examples/recovered_r/SYNTOR-SI/cli_rainfal.R

## Final privacy and integrity gate

- Unredacted local Windows path hits: 0
- Unredacted email hits: 0
- Secret-like assignment hits: 0
- Erroneous NETWORK_PATH_REDACTED placeholders: 0
- Phase 7B crop-harvest regex repair: verified

## Interpretation

Code under src/R/ is the portable and reusable layer.

Code under examples/recovered_r/ is recovered and sanitized historical
research code. It documents the original research workflow but is not
presented as a fully self-contained reproducible software package.

No release tag is created by Phase 7C.
