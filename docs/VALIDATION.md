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

## Storm-intensification provenance

The scientific method is documented in Yuan et al. (2022, Catena).

The original workflow:

1. evaluated 52 CMIP5 downscaled GCM datasets;
2. compared 1950–1979 with 1980–2005 observed and modeled daily precipitation;
3. evaluated five extreme-precipitation percentile classes;
4. calculated historical percent changes in storm intensification;
5. selected the 25 GCMs that best reproduced the observed extreme-precipitation
   trend;
6. used GPCC to downscale future GCM projections;
7. represented changes in extreme storms by adjusting precipitation variance
   and skewness;
8. adjusted skewness using a linear relationship with the ratio of the 99.9th
   percentile to mean daily precipitation.

The WEPP runner itself does not generate storm intensification. It consumes
climate files produced by the upstream climate/downscaling workflow.

## Elevated-CO2 provenance

The associated Catena study documents the following atmospheric CO2
concentrations:

- 380 ppm baseline
- 449 ppm: RCP4.5, 2021–2050
- 515 ppm: RCP4.5, 2051–2080
- 473 ppm: RCP8.5, 2021–2050
- 646 ppm: RCP8.5, 2051–2080

The modified WEPP configuration accounted for CO2 effects on evapotranspiration,
biomass production, and radiation use efficiency.

Because modified WEPP executables and model-specific historical CO2 files are
not redistributed, this public release does not claim to reproduce the modified
WEPP executable internally.

## Not claimed

- Bit-for-bit reproduction of historical WEPP output.
- End-to-end reproduction of every published figure/table.
- Reimplementation of the complete GPCC/SYNTOR climate-generation software.
- Redistribution rights for modified WEPP binaries or large historical inputs.

The repository should therefore be described as a **validated reconstruction of
the WEPP automation and downstream analysis workflow with documented scientific
provenance for the upstream climate scenarios**.
