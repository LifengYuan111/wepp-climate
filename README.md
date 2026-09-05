# WEPP-Climate

**R and Python workflows for climate-change impact analysis with WEPP**

WEPP-Climate is a curated reconstruction of research code used to automate
Water Erosion Prediction Project (WEPP) simulations and analyze climate impacts
on surface runoff, soil loss, and crop yield under large climate-model ensembles
and agricultural management scenarios.

## Research workflow

**52 CMIP5 downscaled GCM datasets → historical extreme-precipitation screening → 25 selected GCMs → RCP4.5 / RCP8.5 → 2021–2050 / 2051–2080 → GPCC / SYNTOR climate downscaling → SI / NO-SI projected climate forcing → crop × tillage systems → WEPP batch simulations → runoff / soil loss / crop yield → statistics and publication outputs**

The Python layer automates WEPP runs across management × climate combinations.
The R layer provides reusable functions for climate-scenario processing,
ensemble summaries, crop-yield analysis, and runoff/soil-loss analysis.

## Storm intensification methodology

Storm intensification was incorporated during the climate downscaling process,
not manually added inside the WEPP automation.

For the GPCC workflow, 52 CMIP5 downscaled GCM datasets were first evaluated
against observed daily precipitation at Weatherford, Oklahoma. Historical daily
precipitation from 1950–2005 was divided into 1950–1979 and 1980–2005. Extreme
precipitation was grouped into five percentile classes:

- 90–95th percentile
- 95–98th percentile
- 98–99th percentile
- 99–99.9th percentile
- >99.9th percentile

Percent changes in storm intensification between the two historical periods were
calculated for both observations and each GCM. The 25 GCMs that most closely
matched the observed historical trend in extreme precipitation were selected
for future climate projections.

GPCC then downscaled projected monthly precipitation and temperature to the
target station using quantile mapping and disaggregated monthly climate to daily
series using CLIGEN. Changes in extreme storms were represented by adjusting
daily-precipitation distribution parameters, especially variance and skewness.
The skewness coefficient was adjusted through a linear relationship with the
ratio of the 99.9th-percentile precipitation to mean daily precipitation.

The resulting SI/NO-SI climate files were supplied to WEPP. This repository does
not reimplement the complete GPCC climate-generation software; it documents and
automates the downstream WEPP simulation and analysis workflow.

## Elevated CO2 treatment

The historical study used a modified WEPP configuration that considered
atmospheric CO2 effects on evapotranspiration, biomass production, and radiation
use efficiency.

The atmospheric CO2 concentrations used in the study were:

| Climate condition | CO2 concentration |
|---|---:|
| Baseline | 380 ppm |
| RCP4.5, 2021–2050 | 449 ppm |
| RCP4.5, 2051–2080 | 515 ppm |
| RCP8.5, 2021–2050 | 473 ppm |
| RCP8.5, 2051–2080 | 646 ppm |

Modified WEPP executables and historical model-specific CO2 parameter files are
not redistributed in this repository.
>>>>>>> 8adb91e (Document GPCC storm-intensification and CO2 methodology)

## Repository structure

```text
src/python/wepp_climate/  Portable WEPP runner and configuration
src/R/                    Climate, crop-yield, runoff and soil-loss helpers
scripts/                  Command-line workflow entry points
config/                   Portable example configuration
workflows/                GPCC/SYNTOR × SI/NO-SI documentation
docs/                     Scientific provenance and validation
tests/                    Python structural tests
```

## Python WEPP automation

Install:

```bash
python -m pip install -e .
```

Then provide your own WEPP installation and inputs in a local YAML configuration:

```bash
python scripts/run_wepp_scenarios.py --config config/example.yml
```

WEPP, CLIGEN, modified WEPP executables, and other third-party binaries are
**not distributed** by this repository.

## Scenario labels

| Code | Scenario |
|---|---|
| `F1R4.5` | RCP4.5, 2021–2050 |
| `F1R8.5` | RCP8.5, 2021–2050 |
| `F2R4.5` | RCP4.5, 2051–2080 |
| `F2R8.5` | RCP8.5, 2051–2080 |

The associated studies used ensembles of 25 selected GCMs and 29
cropping/tillage combinations.

## Scientific provenance and validation

This is a **curated software reconstruction**, not a dump of the historical
working directory. Historical notebooks, absolute paths, bulk outputs, model
binaries, and private working files are intentionally excluded.

Static validation confirmed that the refactored Python runner preserves the
historical 29-step WEPP interactive-input sequence. See
[`docs/VALIDATION.md`](docs/VALIDATION.md).

## Associated publications

The workflow is associated with peer-reviewed WEPP climate-impact studies in
*Soil & Tillage Research*, *Catena*, *Land Degradation & Development*, and
*International Journal of Climatology*. See
[`docs/PUBLICATIONS.md`](docs/PUBLICATIONS.md).

## Reproducibility scope

This release exposes the cleaned automation and analysis architecture. It does
not claim end-to-end reproduction of every published figure because the
original large climate datasets, modified model executables, and some
model-specific inputs are not redistributed.

## Author

**Lifeng Yuan, Ph.D.**

## License status

No open-source license is granted in this initial public release. See
[`NOTICE.md`](NOTICE.md). The license can be updated after
copyright/public-domain and institutional release status are confirmed.
