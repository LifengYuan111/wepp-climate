# Computational workflow

## Climate-model screening

The historical workflow began with 52 CMIP5 downscaled GCM datasets using BCCA
and LOCA products. Observed daily precipitation at Weatherford, Oklahoma, was
used to evaluate whether the climate models reproduced the historical trend in
extreme precipitation.

The historical period 1950–2005 was divided into:

- 1950–1979
- 1980–2005

Storm intensification was evaluated within five precipitation-percentile groups:

- 90–95th
- 95–98th
- 98–99th
- 99–99.9th
- >99.9th

Percent changes between the two periods were calculated for the observations
and each of the 52 GCM datasets. The 25 models that best matched the observed
historical trend in extreme precipitation were selected for future projections.

## GPCC downscaling and storm intensification

GPCC downscaled GCM monthly precipitation and air temperature to the target
station using quantile mapping and then disaggregated monthly climate to daily
series using CLIGEN.

Projected climate-change signals were used to adjust baseline climate
parameters, including precipitation-occurrence transition probabilities, daily
precipitation mean, variance, and skewness.

Changes in extreme storms were represented by adjusting variance and skewness.
The skewness coefficient was adjusted through a linear relationship with the
ratio of the 99.9th-percentile precipitation to mean daily precipitation.

Therefore, storm intensification was incorporated during climate downscaling.
It was not manually added by the Python WEPP batch runner.

## Future climate scenarios

The selected 25 GCMs were used under:

- RCP4.5 and RCP8.5
- 2021–2050 and 2051–2080

This produced 100 future climate scenarios:

**25 GCMs × 2 RCPs × 2 future periods = 100 scenarios**

## Elevated CO2

The modified WEPP workflow considered atmospheric CO2 effects on
evapotranspiration, biomass production, and radiation use efficiency.

CO2 concentrations used in the study were:

- Baseline: 380 ppm
- RCP4.5, 2021–2050: 449 ppm
- RCP4.5, 2051–2080: 515 ppm
- RCP8.5, 2021–2050: 473 ppm
- RCP8.5, 2051–2080: 646 ppm

Modified WEPP executables and historical CO2 parameter files are intentionally
not redistributed.

## Agricultural scenarios

The historical project used 29 cropping and tillage combinations including
major Oklahoma crops and four tillage practices:

- conventional tillage (CT)
- reduced tillage (RT)
- delayed tillage (DT)
- no-till (NT)

## WEPP automation and analysis

The selected climate files and agricultural scenarios were passed to WEPP using
Python batch automation. WEPP event, water-balance, summary, soil-loss, and crop
outputs were then processed in R for:

- runoff
- soil loss
- crop yield
- percentile/extreme-event analysis
- significance testing
- uncertainty analysis
- publication figures and tables

## Scope of this repository

This repository contains the cleaned WEPP automation and analysis workflow.
It does not include the complete GPCC climate-generation software, original
large GCM datasets, modified WEPP executables, or bulk historical model outputs.
