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
    ERDC["USACE Engineering\nResearch and Development\nCenter (ERDC)"] -->|Mississippi Daily Flow| TH
    USGS_SS["USGS Suspended\nSediment Observations"] -->|Rating Curves| TH
    CMIP -->|Precipitation Projections| DP(Daily Precipitation)
    DP --> SI("Storm Intensity")
    SStorm["Synthetic Storms"] --> SI
    SI --> ES
```

## Digital Elevation Model

## Integrated Compartment Model (ICM)

## Advanced Circulation + Simulating Waves Nearshore (ADCIRC+SWAN)

## Coastal Louisiana Risk Assessment (CLARA)

## Planning Tool