# Associated publications

## Soil & Tillage Research

Lifeng Yuan, X.-C. (John) Zhang, Phillip Busteed, Dennis C. Flanagan,
Anurag Srivastava. **Modeling surface runoff and soil loss response to climate
change under GCM ensembles and multiple cropping and tillage systems in
Oklahoma.** *Soil & Tillage Research* 218 (2022), 105296.
DOI: `10.1016/j.still.2021.105296`

Workflow relevance:
- GCM-ensemble climate-impact assessment;
- RCP4.5 / RCP8.5 and two future periods;
- 29 cropping/tillage combinations;
- Python-driven WEPP simulation automation;
- runoff, soil-loss, and crop-production analysis.

## Catena

Lifeng Yuan, X.-C. (John) Zhang, Phillip Busteed, Dennis C. Flanagan.
**Simulating the potential effects of elevated CO2 concentration and
temperature coupled with storm intensification on crop yield, surface runoff,
and soil loss based on 25 GCMs ensemble: A site-specific case study in
Oklahoma.** *Catena* 214 (2022), 106251.
DOI: `10.1016/j.catena.2022.106251`

### Storm-intensification methodology documented in Section 2.3

The study initially evaluated 52 CMIP5 downscaled GCM datasets using historical
daily precipitation from Weatherford, Oklahoma. Historical change between
1950–1979 and 1980–2005 was evaluated in five extreme-precipitation percentile
groups:

- 90–95th
- 95–98th
- 98–99th
- 99–99.9th
- >99.9th

The 25 GCMs that most closely reproduced the observed historical trend in
extreme precipitation were selected.

GPCC then used quantile mapping for monthly spatial downscaling and CLIGEN for
monthly-to-daily disaggregation. Changes in extreme storms were represented by
adjusting precipitation variance and skewness. Skewness was adjusted through a
linear relationship with the ratio of the 99.9th-percentile precipitation to
mean daily precipitation.

The study generated 100 future climate scenarios:

**25 GCMs × 2 RCPs × 2 future periods**

### Elevated CO2 methodology documented in Section 2.4

The modified WEPP model considered atmospheric CO2 effects on
evapotranspiration, biomass production, and radiation use efficiency.

CO2 concentrations were:

- baseline: 380 ppm
- RCP4.5, 2021–2050: 449 ppm
- RCP4.5, 2051–2080: 515 ppm
- RCP8.5, 2021–2050: 473 ppm
- RCP8.5, 2051–2080: 646 ppm

## Land Degradation & Development

Lifeng Yuan, X.-C. (John) Zhang, Phillip Busteed.
**Simulating storm intensification impact on soil erosion and soil hydrology in
various cropping and tillage systems under climate change.**
*Land Degradation & Development* (2022).
DOI: `10.1002/ldr.4299`

Workflow relevance:
- storm-intensification climate forcing;
- crop × tillage processing;
- WEPP runoff and soil-loss simulation;
- post-processing and statistical comparison.

## International Journal of Climatology

Xunchang (John) Zhang, Phillip R. Busteed, Jie Chen, Lifeng Yuan.
**Comparing two weather generator-based downscaling tools for simulating storm
intensification and its impacts on soil erosion under climate change.**
*International Journal of Climatology* 43, 2220–2237.
DOI: `10.1002/joc.7971`

Workflow relevance:
- GPCC vs SYNTOR organization;
- SI vs NO-SI projected forcing;
- WEPP surface-runoff and soil-loss response analysis.

## Explicit exclusion

The SWAT/SVR/DWT streamflow study published in *Water* is unrelated to this
WEPP codebase and is intentionally excluded.
