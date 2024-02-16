# CPRA Master Plan Documentation

## Models Overview

```mermaid
flowchart TD
    Scenarios[Scenario Development] -->|Environmental Scenario| ICM["Integrated Compartment \nModel (ICM)"]
    Projects[Project Concepts] -->|Model Group| ICM
    PT[Planning Tool] --> Projects
    DEM["Digital Elevation Model (DEM)"] -->|Topography\nBathymetry| ICM
    ICM -->|Land Cover\nVegetation| ADCIRC_SWAN["Advanced Circulation +\nSimulating Waves Nearshore\n(ADCIRC+SWAN)"]
    DEM -->|Topography\nBathymetry| ADCIRC_SWAN
    ICM -->|Land Cover\nVegetation| CLARA["Coastal Louisiana Risk\nAssessment (CLARA)"]
    ADCIRC_SWAN -->|Peak Water Level\nPeak Wave Height\nPeak Wave Period| CLARA
    ICM -->|Land Cover\nVegetation| PT
    CLARA -->|Flood Depth\nDamage| PT
    click Scenarios "#scenario-development"
```

## Scenario Development

```mermaid
flowchart LR
    CORS["Continuously Operating\nReference Stations (CORS)"] -->|Primary Benchmarks| DS(Deep Subsidence)
    NGS["CPRA/National\nGeodetic Survey (NGS)"] -->|Secondary Benchmarks| DS
    CRMS["Coastwide Reference\nMonitoring System (CRMS)"] -->|RSET-MH| SS(Shallow Subsidence)
    DS --> TS(Total Subsidence)
    SS --> TS
    TS --> ES("Environmental\nScenarios")
    MP2017["2017 Coastal Master Plan"] -->|Sea Level Rise Curves| SLR(Sea Level Rise)
    NOAA_SLR["Global and Regional\nSea Level Rise Scenarios\nfor the United States (NOAA)"] -->|Sea Level Rise Curves| SLR
    CMIP["Coupled Model\nIntercomparison Project\n(CMIP)"] -->|Sea Level Rise Curves| SLR
    SLR --> ES
    CMIP -->|Temperature Projections| Temp(Temperature)
    ASOS["Surface Weather\nObservation Stations (ASOS)"] -->|Historic Temperatures| Temp
    Temp --> ES
    Temp --> PET(Evapotranspiration)
    PET --> ES
    CMIP -->|Precipitation Projections| Precip(Precipitation)
    Precip --> ES
    CMIP -->|Precipitation Projections| SW(Seasonal Wetness)
    SW --> TH(Tributary\nHydrographs)
    TH --> ES
    USGS_Gages["USGS River Gages"] -->|Daily Flow| TH
    CMIP -->|Precipitation Projections| ERDC["USACE Engineering\nResearch and Development\nCenter (ERDC)"] -->|Mississippi Daily Flow| TH
    USGS_SS["USGS Suspended\nSediment Observations"] -->|Rating Curves| TH
    CMIP -->|Precipitation Projections| DP(Daily Precipitation)
    DP --> SI("Storm Intensity")
    SStorm["Synthetic Storms"] --> SI
    SI --> ES
```

## Landscape Composition

```mermaid
flowchart TD
    S2["Sentinel-2"] -->|2018 Imagery| CE(Cloud Exclusion)
    CE --> IC(Index Calculation)
    IC --> |mNDWI\nNDVI\nAnnual Composite| AV(Aquatic Vegetation)
    CRMS["Coastwide Reference\nMonitoring System (CRMS)"] -->|2015/2016 Land/Water Classifications| ED(Endmember Development)
    IC -->|mNDWI| ED
    CCAP["Coastal Change\nAnalysis Program (C-CAP)"] -->|2015-2017 Beta-Level Data| ED
    AV --> FLWE(Fractional Land/Water Estimation)
    ED --> FLWE
    FLWE -->|Land\nWater\nFloating Aquatic Vegetation\nSubmerged Aquatic Vegetation| ICM["Integrated Compartment\nModel (ICM)"]
```

## Digital Elevation Model (DEM)

```mermaid
flowchart LR
    3DEP["USGS 3D Elevation\nProgram (3DEP)"] --> RT(Reprojection\nand Transformation)
    NOAA --> RT
    USACE["U.S. Army Corps\nof Engineers (USACE)"] --> RT
    USDA_NRCS["USDA Natural Resources\nConservation Service (NRCS)"] --> RT
    CPRA --> RT
    LADOT["Louisiana Department of\nTransportation (LA DOT)"] --> RT
    LPBF["Lake Pontchartrain\nBasin Foundation (LPBF)"] --> RT
    TNRIS[Texas Natural Resources\nInformation System] --> RT
    RT --> BD(Breakline\nDevelopment)
    BD --> DSP(Data Source\nPrioritization)
    DSP --> FG(Filling Gaps in\nBathymetry)
    MP17DEM[2017 Coastal\nMaster Plan\nBaseline DEM] --> FG
    FG --> TBDEM("NGOM2\nTBDEM")
```

## Integrated Compartment Model (ICM)

```mermaid
flowchart TD
    M[ICM-Morph] -->|Land\nAvailable Bareground| VM[ICM-LaVegMod]
    VM -->|Organic Matter Accumulation| M
    H[ICM-Hydro] -->|Mineral Accumulation| M
    H -->|Average Annual Salinity\nWater Level Variation| VM
    H -->|Water Depth| In(Inundation)
    M -->|Elevation| In
    In --> BT(Bareground Transitions)
    VM --> BT
    BT --> M
```

_Data Source: [Attachment C8][C8]_

### ICM-LAVegMod

```mermaid
flowchart TD
    M[ICM-Morph] -->|Land Change| WA(Water Area)
    WA --> VC(Vegetation Coverages)
    H[ICM-Hydro] -->|Average Annual Salinity\nWater Level Variation| VC
    VC --> SS(Acute Salinity Stress)
    H -->|2-Week Salinity| SS
    SS --> FFIBS(FFIBS Score)
```

_Data Source: [Attachment C8][C8]_

### ICM-Morph

### ICM-Hydro

## Advanced Circulation + Simulating Waves Nearshore (ADCIRC+SWAN)

## Coastal Louisiana Risk Assessment (CLARA)

## Planning Tool

[C8]: https://coastal.la.gov/wp-content/uploads/2024/02/C8_ICM-LAVegModICM-Morph_v2.pdf