# Phase 7B — Final R-Code Audit

Generated: 2026-09-05 10:16:50

## Decision

**Ready for final review after this Phase 7B commit; not auto-pushed or merged.**

## Scope audited

- 49 recovered historical R/Rmd scripts
- 9627 historical-code lines in the sanitized copies
- 6 portable R modules under src/R/
- Phase 7 manifests, index, and recovery documentation

## Critical Phase 7 issue found and repaired

Phase 7 used an over-broad UNC/network-path sanitizer. It transformed the valid
R regex:

str_extract(Product,'\\d{2,3}')

into:

str_extract(Product,'<NETWORK_PATH_REDACTED>')

in **19 crop-yield scripts**.

Phase 7B rebuilt every recovered script directly from the original historical
file after verifying its SHA-256 hash against the Phase 7 manifest. All 19
crop-harvest regex occurrences are now preserved.

## Privacy/static scan after repair

- Unredacted Windows absolute-path hits: 0
- Unredacted email hits: 0
- Secret-like assignment hits: 0
- <NETWORK_PATH_REDACTED> placeholders: 0
- Preserved \\d{2,3} harvest-regex occurrences: 19

Machine-specific Windows paths remain represented only as
<LOCAL_PATH_REDACTED>, and email addresses only as <EMAIL_REDACTED>.

## Exact duplicate historical scripts

Four exact source-code duplicate pairs/groups were identified. These are kept
intentionally because they preserve the original SI/NO-SI workflow tree:

- SYNTOR-NO-SI\climate data analysis.Rmd <-> SYNTOR-SI\climate data analysis.Rmd
- SYNTOR-NO-SI\Prec_runoff.R <-> SYNTOR-SI\Prec_runoff.R
- SYNTOR-NO-SI\soil_loss.R <-> SYNTOR-SI\soil_loss.R
- SYNTOR-NO-SI\sumry_out(all).R <-> SYNTOR-SI\sumry_out(all).R

They should be interpreted as historical provenance, not as four independent
software contributions.

## Portable-module improvements

Phase 7B also hardens:

- src/R/scenario_mapping.R
- src/R/extreme_precipitation.R
- src/R/ensemble_statistics.R

and adds:

- tests/test_r_base_helpers.R

The precipitation helper now computes the study-relevant 90th, 95th, 99th and
99.9th percentiles explicitly rather than accepting a custom probability vector
that could be mislabeled. Ensemble summaries now handle all-missing values and
NA group values more safely.

## R syntax validation

Rscript detected at C:\Program Files\R\R-4.5.1\bin\Rscript.exe. Portable modules and historical scripts were parse-checked; see the parse CSV.

Historical parser failures, if any:

- examples/recovered_r/GPCC-NO-SI/Crop and tillage.R [R] — Error: unexpected end of input Execution halted
- examples/recovered_r/GPCC-NO-SI/crop schedule.R [R] — Error: unexpected end of input Execution halted
- examples/recovered_r/GPCC-NO-SI/evt_GCMs_100.R [R] — Error in parse(file = "C:/WEPP_GitHub_Public/wepp-climate/examples/recovered_r/GPCC-NO-SI/evt_GCMs_100.R") :    C:/WEPP_GitHub_Public/wepp-climate/examples/recovered_r/GPCC-NO-SI/evt_GCMs_100.R:176:1: unexpected '->' 175:                                                         Avg_Runoff = mean(Avg_...
- examples/recovered_r/GPCC-NO-SI/Table 5.R [R] — Error: unexpected end of input Execution halted
- examples/recovered_r/GPCC-SI/Table 5.R [R] — Error: unexpected end of input Execution halted
- examples/recovered_r/SYNTOR-NO-SI/Table 3.R [R] — Error: unexpected end of input Execution halted
- examples/recovered_r/SYNTOR-NO-SI/Table 5S.R [R] — Error: unexpected end of input Execution halted
- examples/recovered_r/SYNTOR-SI/cli_rainfal.R [R] — Error in parse(file = "C:/WEPP_GitHub_Public/wepp-climate/examples/recovered_r/SYNTOR-SI/cli_rainfal.R") :    C:/WEPP_GitHub_Public/wepp-climate/examples/recovered_r/SYNTOR-SI/cli_rainfal.R:604:2: unexpected symbol 603:  604: 3ggsave       ^ Execution halted

Historical parse success is **syntax evidence only**. It does not prove that a
script runs end-to-end, because many recovered scripts depend on historical
working directories, upstream R objects, large climate/model datasets, package
versions, and WEPP outputs that are intentionally not bundled.

## Publication interpretation

The recovered tree is suitable for demonstrating the breadth of the original
research workflow: GPCC/SYNTOR climate processing, SI/NO-SI branches, GCM
ensembles, precipitation/extreme-event analysis, crop/tillage processing,
WEPP event-output extraction, runoff, soil loss, yield, statistics, and
publication figures/tables.

It should be described as **recovered and sanitized historical research code**,
not as a fully reproducible software package.

## Release recommendation

After reviewing this Phase 7B commit and its review ZIP:

1. merge phase7-r-code-recovery into main;
2. push main;
3. verify the GitHub tree and README links;
4. optionally tag the resulting release only after the repository is confirmed
   stable.