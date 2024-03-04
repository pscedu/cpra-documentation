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

## 📋 Scenario Development

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

## 🌏 Landscape Composition

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

## 📐 Digital Elevation Model (DEM)

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

## 📦 Integrated Compartment Model (ICM)

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

_Data Source: [2023 Master Plan Attachment C8][C8]_

### 🌱 ICM-LAVegMod

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

### 🌄 ICM-Morph

```mermaid
flowchart LR
    P(Polders) --> ?
    SD[Scenario\nDevelopment] -->|Deep Subsidence\nShallow Subsidence| ?
    NC[Maintained\nNavigation\nChannels\nand Rivers] --> ?
    DZ(Active Deltaic Zones) --> ?

    DEM["NGOM2 TBDEM"] -->|Elevation| ID(Inundation Depths)
    H[ICM-Hydro] -->|Mineral Accumulation| MD
    LC[Landscape\nComposition] -->|Land Type| ED(Marsh Edge Delineation)
    ID --> IHSI(Calculate\nInundation\nfor use in\nHSI Equations)
    ID --> NSL(Classify New\nSubaerial Land)
    ID -->|Monthly Inundation Depths\nWetted Area| MD(Mineral Sediment\nDeposition)
    CRMS["Coastwide\nReference\nMonitoring \nSystem (CRMS)"] -->|OMAR| OA(Organic Matter\nAccumulation)
    VM[ICM-LaVegMod] -->|Weighted FFIBS Score| OA
    VM -->|Flotant Mortality\nFlotant Establishment| F(Flotant Marsh Loss)
    ED -->|Marsh Edges| EE(Marsh Edge Erosion)
    HEE[Historical Edge\nErosion Rates] --> EE
    HEE[Historical Edge\nErosion Rates] --> BSP(Implement Shoreline\nProtection Projects)
    VM -->|Bareground| MB(Map Spatial\nDistribution of\nBareground)
    DEM["NGOM2 TBDEM"] -->|Elevation| MB
    CRMS -->|Annual Mean Depth-Salinity| IT(Chronic Inundation\nStress Thresholds)
    VM -->|Weighted FFIBS Score| IT
    MD --> UE(Update Elevation)
    OA --> UE
    F --> UE
    EE --> UE
    MB --> UE
    UE --> NSL
    NSL --> UL(Update Land\nType Classification)
    EE --> UL
    F --> UL
    IT --> UL
    UL --> BMP(Implement\nMarsh Creation\nand Landbridge\nProjects)
    PT -->|Design Elevation| BMP
    PT[Planning Tool] -->|Erosion Multipliers| BSP
    BMP --> BRP(Implement Ridge\nRestoration\nand Levee\n Projects)

    DTL(Distance to Land) --> ??
    SAV(Submerged\nAquatic\nVegetation) --> ??

    classDef fixme fill:red,color:black,stroke:black,font-weight:bold
    class ?,?? fixme
```

_Data Source: [2023 Master Plan Attachment C8][C8]_

ICM-Morph includes a preprocessing subroutine that reads data into memory. It is omitted from the diagram for readability.

### 💧 ICM-Hydro
```mermaid
flowchart TD
    %%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%
    AT("📋 Air Temperature") --> WT("📤 Water Temperature")
    TH("📋 Tributary Hydrographs") --> WT
    TH --> Sal("📤 Salinity")
    TH --> SS(Suspended Sediments)
    PE("📋 Precipitation and\nEvapotranspiration") --> Sal
    PE --> EWL("📤 Estuary Water Level")
    SS --> Sed("📤 Sedimentation")
    Sal --> SS
    TD(Tidal Dynamics) --> Sed
    EWL --> Sed
    TD --> BR(Bed Resuspension)
    SI("📋 Storm Intensity") --> Win
    Win(Wind) --> Wav
    Wav(Waves) --> BR
    BR --> SS
    TD --> EWL
    EWL --> MEE(Marsh Edge Erosion)
    MEE --> SS
    SLR("📋 Sea Level Rise") --> EWL
```

_Data Source: [2017 Coastal Master Plan Attachment C3-22][C3-22]_

## 🌀 Advanced Circulation + Simulating Waves Nearshore (ADCIRC+SWAN)

## 💵 Coastal Louisiana Risk Assessment (CLARA)

## 💻 Planning Tool

[C8]: https://coastal.la.gov/wp-content/uploads/2024/02/C8_ICM-LAVegModICM-Morph_v2.pdf

[C3-22]: http://coastal.la.gov/wp-content/uploads/2017/04/Attachment-C3-22_FINAL_03.07.2017.pdf
