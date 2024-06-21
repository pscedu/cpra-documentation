# 2023 Coastal Master Plan Models

## Models Overview

```mermaid
flowchart TD
    Scenarios[📋 Scenario Development] -->|Environmental Scenario| ICM["📦 Integrated Compartment \nModel (ICM)"]
    Projects(Project Concepts) -->|Model Group| ICM
    PT[💻 Planning Tool] --> Projects
    DEM["📐 Digital Elevation Model (DEM)"] -->|Topography\nBathymetry| ICM
    ICM -->|Land Cover\nVegetation| ADCIRC_SWAN["🌀 Advanced Circulation +\nSimulating Waves Nearshore\n(ADCIRC+SWAN)"]
    DEM -->|Topography\nBathymetry| ADCIRC_SWAN
    ICM -->|Land Cover\nVegetation| CLARA["💵 Coastal Louisiana Risk\nAssessment (CLARA)"]
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
    DS --> TS(📤 Total Subsidence)
    SS --> TS
    MP2017["2017 Coastal Master Plan"] -->|Sea Level Rise Curves| SLR(📤 Sea Level Rise)
    NOAA_SLR["Global and Regional\nSea Level Rise Scenarios\nfor the United States (NOAA)"] -->|Sea Level Rise Curves| SLR
    CMIP["Coupled Model\nIntercomparison Project\n(CMIP)"] -->|Sea Level Rise Curves| SLR
    CMIP -->|Temperature Projections| Temp(Temperature)
    ASOS["Surface Weather\nObservation Stations (ASOS)"] -->|Historic Temperatures| Temp
    Temp --> PET(📤 Evapotranspiration)
    CMIP -->|Precipitation Projections| Precip(📤 Precipitation)
    CMIP -->|Precipitation Projections| SW(Seasonal Wetness)
    SW --> TH(📤 Tributary\nHydrographs)
    USGS_Gages["USGS River Gages"] -->|Daily Flow| TH
    CMIP -->|Precipitation Projections| ERDC["USACE Engineering\nResearch and Development\nCenter (ERDC)"] -->|Mississippi Daily Flow| TH
    USGS_SS["USGS Suspended\nSediment Observations"] -->|Rating Curves| TH
    CMIP -->|Precipitation Projections| DP(Daily Precipitation)
    DP --> SI(📤 Storm Intensity)
    SStorm[Synthetic Storms] --> SI
```

_Data Source: [2023 Master Plan Appendix B][B]_

## 🌎 Landscape Composition

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
    FLWE -->L(📤 Land)
    FLWE --> W(📤 Water)
    FLWE --> FAV(📤 Floating Aquatic Vegetation)
    FLWE --> SAV(📤 Submerged Aquatic Vegetation)
```

_Data Source: [2023 Master Plan Attachment B1][B1]_

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
    FG --> E(📤 Elevation)
```

_Data Source: [2023 Master Plan Attachment B1][B1]_

## 📦 Integrated Compartment Model (ICM)

```mermaid
flowchart TD
    M[🌄 ICM-Morph] -->|Land\nAvailable Bareground| VM[🌱 ICM-LaVegMod]
    VM -->|Organic Matter Accumulation| M
    H[💧 ICM-Hydro] -->|Mineral Accumulation| M
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
    LC(🌄 Land Change) --> WA(Water Area)
    WA --> VC(Vegetation Coverages)
    AASal(💧 Average Annual Salinity) --> VC
    WLV(💧 Water Level Variation) --> VC
    VC --> SS(Acute Salinity Stress)
    2WkSal(💧 2-Week Salinity) --> SS
    SS --> FFIBS(📤 FFIBS Score)
```

_Data Source: [Attachment C8][C8]_

### 🌄 ICM-Morph

```mermaid
flowchart LR
    P(Polders) --> ?
    DS(📋 Deep Subsidence) --> ?
    SS(📋 Shallow Subsidence) --> ?
    NC[Maintained\nNavigation\nChannels\nand Rivers] --> ?
    DZ(Active Deltaic Zones) --> ?
    DTL(Distance to Land) --> ?
    SAV(Submerged\nAquatic\nVegetation) --> ?
    
    E(📐 Elevation) --> ID(Inundation Depths)
    LT(🌎 Land Type) --> ED(Marsh Edges)
    ID --> IHSI(Calculate\nInundation\nfor use in\nHSI Equations)
    ID --> NSL(Classify New\nSubaerial Land)
    ID --> MD(Mineral Sediment\nDeposition)
    MA(💧 Mineral Accumulation) --> MD
    OMAR("Organic Matter\nAccumulation Rates\n(CRMS)") --> OA(Organic Matter\nAccumulation)
    WFS(🌱 Weighted FFIBS Score) --> OA
    BG(🌱 Bareground) --> MB(Map Spatial\nDistribution of\nBareground)
    E --> MB
    FM(🌱 Flotant Mortality) --> F(Flotant Marsh Loss)
    FE(🌱 Flotant Establishment) --> F
    ED --> EE(Marsh Edge Erosion)
    HEE[Historical Edge\nErosion Rates] --> EE
    HEE[Historical Edge\nErosion Rates] --> BSP(Implement Shoreline\nProtection Projects)
    AMDS("Annual Mean\nDepth-Salinity\n(CRMS)") --> IT(Chronic Inundation\nStress Thresholds)
    WFS --> IT
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
    DE(💻 Design Elevation) --> BMP
    EM(💻 Erosion Multipliers) --> BSP
    BMP --> BRP(Implement Ridge\nRestoration\nand Levee\n Projects)

    classDef fixme fill:red,color:black,stroke:black,font-weight:bold
    class ? fixme
```

_Data Source: [2023 Master Plan Attachment C8][C8]_

ICM-Morph includes a preprocessing subroutine that reads data into memory. It is omitted from the diagram for readability.

### 💧 ICM-Hydro
```mermaid
flowchart TD
    AT(📋 Air Temperature) --> WT(📤 Water Temperature)
    TH(📋 Tributary Hydrographs) --> WT
    TH --> Sal(📤 Salinity)
    TH --> SS(Suspended Sediments)
    PE(📋 Precipitation and\nEvapotranspiration) --> Sal
    PE --> EWL(📤 Estuary Water Level)
    SS --> Sed(📤 Sedimentation)
    Sal --> SS
    TD(Tidal Dynamics) --> Sed
    EWL --> Sed
    TD --> BR(Bed Resuspension)
    SI(📋 Storm Intensity) --> Win
    Win(Wind) --> Wav
    Wav(Waves) --> BR
    BR --> SS
    TD --> EWL
    EWL --> MEE(Marsh Edge Erosion)
    MEE --> SS
    SLR(📋 Sea Level Rise) --> EWL
```

_Data Source: [2017 Coastal Master Plan Attachment C3-22][C3-22]_

### ⛳ ICM-BI (Barrier Islands Digital Elevation Model)
```mermaid
flowchart TD
    LS(📋 Subsidence) --> PA(Profile Adjustment)
    SLR(📋 Sea Level Rise) --> PA
    CSR(Cross-Shore Retreat) --> PA
    MER(Marsh Edge Retreat) --> PA
    PA --> RAN(Restoration as Needed)
    RAN --> DEM(📤 Updated DEM)
```

_Data Source: [2023 Master Plan Appendix C][C]_

## 🌀 Advanced Circulation + Simulating Waves Nearshore (ADCIRC+SWAN)

## 💵 Coastal Louisiana Risk Assessment (CLARA)

```mermaid
flowchart LR
    SH(🌀 Surge Hydrograph) --> OT(Overtopping)
    WH(🌀 Wave Height) --> OT
    E(📐 Elevation) --> OT
    P("Polders (USACE)") --> OT
    SH --> SF(System Fragility)
    WH --> SF
    P --> SF
    P --> ID(Interior Drainage)
    OT --> FD(Flood Depth)
    SF --> FD
    ID --> FD
    R("Rainfall (IPETF)") --> FD
    Pu(Pumping) --> FD
    FD --> AEP(Annual\nExceedance\nProbability)
    BF("Building Footprints\n(Microsoft)") --> AI(Asset Inventory)
    BA("Building Attributes\n(Google Street View)") --> AI
    NSI("National Structure\nInventory v2\n(USACE)") --> AI
    ADS(ATTOM Data Solutions) --> AI
    OSM(OpenStreetMap) --> AI
    AI --> AV(Asset Valuation)
    AV --> DEL(Direct\nEconomic\nLosses)
    FD --> DEL
    AEP --> DEL
    DEL --> EADD(📤 Expected Annual\nDamage, Dollars)
    DEL --> EASD(📤 Expected Annual\nStructural Damage)
```

_Data Source: [2023 Master Plan Attachment C11][C11]_

## 💻 Planning Tool

[B]: https://coastal.la.gov/wp-content/uploads/2023/09/B_ScenarioDevelopmentFutureConditions_Jan2023_v3.pdf

[B1]: https://coastal.la.gov/wp-content/uploads/2023/07/B1_LandscapeInputData_Jul2023_v5.pdf

[C]: https://coastal.la.gov/wp-content/uploads/2023/05/C_UsePredictiveModels_Jan2023_v3.pdf

[C8]: https://coastal.la.gov/wp-content/uploads/2024/02/C8_ICM-LAVegModICM-Morph_v2.pdf

[C11]: https://coastal.la.gov/wp-content/uploads/2023/08/C11_2023RiskModel_Jan2023_v3.pdf

[C3-22]: http://coastal.la.gov/wp-content/uploads/2017/04/Attachment-C3-22_FINAL_03.07.2017.pdf
