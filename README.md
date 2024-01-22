# CPRA Master Plan Documentation

## Models Overview

```mermaid
flowchart TD
    Scenarios[Scenario Development] -->|Environmental Scenario| ICM["Integratged Compartment \nModel (ICM)"]
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
    CMIP["Coupled Model\nIntercomparison Project\n(CMIP)"] --> SLR(Sea Level Rise)
    CMIP --> Precip(Precipitation)
    CMIP --> Temp(Temperature)
    ASOS["Surface Weather\nObservation Stations (ASOS)"] -->|Historic Temperatures| Temp
```

## Digital Elevation Model

## Integrated Compartment Model (ICM)

## Advanced Circulation + Simulating Waves Nearshore (ADCIRC+SWAN)

## Coastal Louisiana Risk Assessment (CLARA)

## Planning Tool