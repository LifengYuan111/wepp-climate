# Computational workflow

The recovered workflow consists of 25-GCM climate projections, RCP4.5/RCP8.5,
two future periods, GPCC/SYNTOR projected forcing, SI/NO-SI climate branches,
crop × tillage scenarios, Python-driven WEPP execution, and R-based analysis of
runoff, soil loss, crop yield, ensemble uncertainty, significance, and
publication outputs.

## Storm intensification

SI/NO-SI is a property of the supplied projected climate forcing. The WEPP
runner does not calculate storm intensification and does not apply a fixed
precipitation multiplier. The exact downscaling/projection algorithm is outside
this repository and is not reverse-engineered here.

## Elevated CO2

Historical evidence indicates a CO2-aware WEPP workflow and crop-specific CO2
parameterization. Modified WEPP executables and historical model-specific CO2
files are not redistributed, so this repository does not claim to reproduce
the modified WEPP implementation itself.

## Why the repository is curated

The historical workspace contained large outputs, climate files, duplicate
scripts, machine-specific paths, and third-party/model binaries. This public
repository keeps the reusable scientific logic while excluding those assets.
