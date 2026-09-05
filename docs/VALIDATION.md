# Validation status

## Completed

- Core historical R/Python/Jupyter workflow was identified through code audit.
- Public package excludes WEPP/CLIGEN executables, DLLs, bulk historical
  outputs, private paths, and historical notebooks.
- The cleaned Python runner preserves the historical **29-step interactive WEPP
  input sequence** at the static code level.
- Historical scenario directories confirmed **25 distinct GCM climate files**
  for the principal GPCC future branches.
- SI and NO-SI climate files were confirmed to be distinct projected forcing
  branches.

## SI / NO-SI interpretation

Storm intensification was not manually added by the cleaned WEPP runner.
SI/NO-SI inputs came from the original climate projection/downscaling workflow.
The exact underlying projection algorithm is outside this repository, and this
release deliberately does not infer a formula from file differences.

## CO2 scope

The historical project contains evidence of a CO2-aware WEPP workflow. Because
the modified model executable and historical model-specific CO2 files are not
redistributed, this release does not claim to reproduce that executable's
internal implementation.

## Not claimed

- Bit-for-bit reproduction of historical WEPP output.
- End-to-end reproduction of every published figure/table.
- Reimplementation of GPCC/SYNTOR climate generation.
- Redistribution rights for modified WEPP binaries or large historical inputs.
