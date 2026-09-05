# WEPP-Climate

**R and Python workflows for climate-change impact analysis with WEPP**

WEPP-Climate is a curated reconstruction of research code used to automate
Water Erosion Prediction Project (WEPP) simulations and analyze climate impacts
on surface runoff, soil loss, and crop yield under large climate-model ensembles
and agricultural management scenarios.

## Research workflow

**25 GCMs → RCP4.5 / RCP8.5 → 2021–2050 / 2051–2080 → GPCC / SYNTOR climate forcing → SI / NO-SI branches → crop × tillage systems → WEPP batch simulations → runoff / soil loss / crop yield → statistics and publication outputs**

The Python layer automates WEPP runs across management × climate combinations.
The R layer provides reusable functions for climate-scenario processing,
ensemble summaries, crop-yield analysis, and runoff/soil-loss analysis.

## Important note on storm intensification

`SI` and `NO-SI` are **alternative projected climate-forcing branches produced
by the original climate projection/downscaling workflow**. This repository does
**not** implement or claim to reconstruct a user-defined storm-intensification
formula inside WEPP or the Python runner.

The WEPP automation consumes climate files that already represent the projected
SI/NO-SI alternatives. The exact underlying projection algorithm belongs to the
original climate-generation methodology and is not reimplemented here.

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

The associated studies used ensembles of 25 GCMs and 29 cropping/tillage
combinations.

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
