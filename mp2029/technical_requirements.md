# 2029 Coastal Master Plan Technical Requirements

## Background

### Types of Master Plan Data

The master plan development process generates data of several types. These include:

- **Vector geometries** are used to represent model grids and project alignments.
- **Vector attributes** represent project attributes as well as grid cell values for model inputs and outputs.
- **Raster images** are used to represent some model inputs and outputs.

### Audience Groups

Data from the 2029 Master Plan will be used by a variety of stakeholders during and after the development of the plan:

- **Modeling Teams:** The modeling teams include CPRA staff and contractors responsible for data preparation, modeling, and quality assurance.
- **Strategy Team:** The strategy teams includes CPRA staff who provide direction to the planning process and oversee modeling, public engagement, and plan document preparation.
- **Advisory Groups:** Advisory groups include external stakeholders who provide input and guide the planning process.
- **External Researchers:** External researchers are scientists who are not involved in the development of the plan, but who use plan data as inputs to other coastal modeling and research studies. 
- **Elected Officials:** Elected officials include state and local leaders responsible for the implementation of plan projects.
- **Public an News Media:** The public and news media audience includes residents, property owners, reporters, and any other non-technical stakeholders with an interest in the future of coastal Louisiana.

These audiences will interact with plan data and visualizations in different ways:

| | Modeling Teams | Strategy Team | Advisory Groups | External Researchers | Elected Officials | Public and News Media |
|---|---|---|---|---|---|---|
| Write data | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌| ❌ |
| Perform quality assurance on data | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌| ❌ |
| Download data | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Visualize data in an online portal | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Visualize data in desktop software | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| Access project fact sheets | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## Goals

- Develop a unified and flexible data access and visualization software ecosystem.
- Store plan data in efficient formats that reflect anticipated access patterns and that minimize the need for data conversion and transfer.
- Provide APIs and data access methods that accommodate a wide variety of software running on HPC, cloud, and desktop platforms.
- Create integrated visualization and quality assurance tools that facilitate plan development and communication.
- Provide simulation management capabilities that facilitate coordination among members of the plan development team.

## Architecture Overview

The architecture of the master plan software is organized in five layers: administration, compute, storage, access, and visualization.

```mermaid
flowchart TD
    subgraph A[Administration]
        M[Management API]
    end
    subgraph C[Compute]
        LM[Landscape Models]
        LM --> SSWM[Storm Surge\nand Wave Models]
        LM --> RM[Risk Model]
        SSWM --> RM
        RM --> PT[Planning Tool]
        PT --> SSWM
        PT --> LM
    end
    subgraph S[Storage]
        MPD["Master Plan\nDatabase (MPD)"]
        CODS[Cloud-Optimized\nData Storage]
    end
    subgraph Ac[Access]
        Catalog[Catalog API]
        Data[Data and Analysis API]
    end
    subgraph V[Visualization]
        PI[Portal Interface]
        DeS[Desktop Software]
    end
    A <--> C
    A <--> S
    C <--> S
    S --> Ac
    A <--> V
    Ac --> V
    S --> V
```

### Administration

The administration layer contains a **management API** that provides routes for managing users, teams, and simulation runs. It authenticates users and issues access tokens that are used to authorize access to the catalog API and the data and analysis API.

### Compute

The compute layer contains the quantitative models used to analyze candidate projects. These models include **landscape models**, **storm surge and wave models**, and **risk model**, as well as the **planning tool** used optimize cost-benefit scenarios. While the details of these models are beyond the scope of this document, their interaction with the other layers of the architecture is a key consideration.

### Storage

The storage layer provides persistent data storage for project and model data. It consists of the **master plan database (MPD)**, which runs on a virtual machine in the HPC environment, and **cloud-optimized data storage** that lives on the HPC filesystem. Which datasets are stored in the MPD and which in the cloud-optimized files formats is a question that requires further investigation, as described below.

### Access

The access layer contains three APIs that provide information about, and access to, model data. The **catalog API** provides routes for querying which datasets and combinations of variables are available in the storage layer. It is indexed according to a hierarchy of variables to allow cascading selection of datasets.

The **data and analysis API** provides routes for accessing, summarizing, and comparing model data. The responses are provided in tabular and geospatial formats that can be consumed by the visualization layer.

### Visualization

The visualization layer provides tools for displaying and analyzing model data and projects. The **portal interface** is the primary component of this layer. It provides a web-based interface for mapping and charting data obtained via the access layer. It also provides an interface for quality assurance and approval functionality provided via the administration layer.

While most analysis and quality assurance tasks can be performed using the portal, some advanced techniques may require the use of **desktop software**, such as ArcGIS or QGIS. The data formats provided by the access layer are designed to be compatible with common desktop analysis tools, minimizing the need to move or convert data.

## Model Data Storage

In the 2023 master plan, model data were stored on the HPC filesystem. Attributes for vector model grids were stored as CSVs, and raster outputs were stored in a variety of image formats, including binary dumps, ASCII gridded XYZ files, and GeoTIFFs. Some of the attribute data from the CSVs were later imported into the project development database (PDD) and exposed via a time series API for use in the Data Access Portal (DAP). Some of the raster outputs were converted to Cloud Optimized GeoTIFFs (COGs) and map tiles (MBTiles) for download and display, respectively, in the DAP.

**2023 Model Data Storage Summary**

| Model Grid Type | Model Output Format | Intermediate Formats | Download and Display Formats |
|---|---|---|---|
| Vector | CSV | PostgreSQL table | CSV, JSON (generated by the time series API in real time)
| Raster | Binary dump | ASCII gridded XYZ, GeoTIFF | COG, MBTiles

The 2023 data storage approach had several limitations that the 2029 plan aims to improve:

- Raw model data, such as CSVs and raster binary dumps, had to be explicitly converted into display formats using postprocessing scripts. As a result, results were not immediately viewable after a model run completed.

- Use of uncompressed file formats for model outputs increased file read and write times and filesystem usage.

- Storage of each dataset in multiple formats increased filesystem usage.

- Adding model data to the PDD required moving the database storage to a network filesystem (Ocean), degrading the database performance.

- The lack of a centralized model data store required building a separate data catalog that had to be updated manually when new runs were added.

In addition to addressing these limitations, any data storage approach considered for the 2029 plan needs to scale well beyond the volume of data produced by the 2023 plan. The planned change in spatial resolution for the risk model from communities to grid cells will dramatically increase the volume of data produced by that model, and changes in other models could have similar impacts. As a result, testing each of the candidate storage approaches at scale will be a key aspect of its evaluation.

### 2029 Model Data Storage Approaches

To address the limitations in the 2023 model data storage system, we [evaluated three approaches for 2029 model data storage](model_data_storage.md):

- [Database-Centric Storage](model_data_storage.md#database-centric-storage)
- [Hybrid Database-Cloud Storage](model_data_storage.md#hybrid-database-cloud-storage)
- [Cloud-Native Storage](model_data_storage.md#cloud-native-storage)

### Proposed Data Storage Approach

Based on the test results, we recommend implementing a modified version of the hybrid database-cloud storage option using COGs and Parquet files in the wide format. Using `zstd` compression at level 6 for both the COG and Parquet files—as well as a row group size of 5,000 for the Parquet files—optimizes file size and query performance in most cases. The main drawback of this option is that accessing the Parquet files via the database is slow due to the use of Python to read and transpose the Parquet files in real time.

```mermaid
flowchart TD
    VM(Vector Grid Models)
    RM(Raster Grid Models)
    subgraph MPD[Master Plan Database]
        ODBR(Out-DB Rasters)
        PL3P(PL/Python)
    end
    subgraph FS[HPC Filesystem]
        COG(💾 Cloud-Optimized GeoTIFFs)
        P(💾 Parquet)
    end
    CAPI(Catalog API)
    DAPI(Data and Analysis API)
    RM --> COG
    COG --> ODBR
    VM --> P
    FS --> CAPI
    FS --> DAPI
    P --> PL3P
```

#### Data Structure

The proposed data structure—including variables, dimensions, and data types—is described in the [documentation for the cpra.mp.data Python library](https://github.com/pscedu/cpra.mp.data). This repository also includes examples of reading and writing model data in Python.

#### Data Archival and Replacement

In addition to the main data directory that contains active data, there is a second, parallel directory that follows the same dimension hierarchy and is used for archival. The archive directory is used to preserve Parquet and COG files that have been replaced with new versions due to errors. During the replacement process, files are moved to the corresponding location in the archive directory, and a new file is written in the original location. A log record is also added to the MPD that includes the old and new file paths, the date and time, and the reason for replacement.

The archival and replacement process is meant to be used when errors are discovered in a published dataset. It is not intended to handle changes to input data and model parameters. In these cases, a new model group number should be assigned.

Data for exploratory model groups may be removed from the data directory without archival once these model groups are no longer needed. In such cases, a removal record is added to the MPD indicating the model group, the date and time, and the reason for removal.

## Data and Analysis API

The data and analysis API provides a RESTful interface for accessing and transforming model data stored in Parquet and COG files. Data from Parquet files can be returned in several tabular formats. Data from COGs can be returned as GeoTIFFs or raster map tiles. COG data can also be summarized geographic unit (e.g., hydro compartment or ecoregion) and returned in any of the formats used for the tabular data.

All of the API endpoints use the general format:

```
/data/<api_version>/<variable>/<geographic_unit>/<time_unit>.<format>
```

Example URIs for vector-grid (Parquet) data are:

```
/data/v1/salinity_mean/hydro_compartment/daily.arrow
/data/v1/salinity_mean/hydro_compartment/daily.csv
/data/v1/salinity_mean/hydro_compartment/daily.ndjson
/data/v1/salinity_mean/hydro_compartment/daily.parquet
```

Additional example URIs for raster-grid (COG) data are:

```
/data/v1/flood_depth/icm_raster/annual.tiff
/data/v1/flood_depth/icm_raster/annual/{z}/{x}/{y}.png
```

### Query Operations

Without any query string parameters, each endpoint returns the full dataset by default. To obtain a subset of the data or to perform transformation and analysis operations, query string parameters can be added. There are six query operations, which are always performed in the same order:

1. Filter
2. Presort
3. Group and Aggregate
4. Transform and Extract
5. Sort

#### Filter

Filter parameters are used to limit the rows, columns, or bands of the dataset to those matching specific criteria. Any dimension from the partition and non-partition dimensions can be used as a filter parameter. Multiple values can be provided in a comma-separated list. For advanced filtering of vector-grid data, a `filters` parameter can be used to specify complex filtering logic in pyarrow format.

For vector-grid data, the `geography` parameter accepts a comma-separated list of source geography IDs. For raster-grid data, it accepts a comma-separated list of coordinate pairs (in the format `x,y`) at which values are extracted from the COGs. When specifying coordinate pairs for a raster-grid dataset, the result is a tabular dataset that can be transformed in the same way as Parquet data (e.g., using the `melt` parameter below).

For raster-grid data, when the `geography` parameter is not provided, the full images are used. Each COG becomes a band in the resulting image. These bands can be aggregated using the `group_by` and `group_aggregate` parameters below. Due to memory constrains, a maximum of 10 bands can be loaded from COGs. Additional matches beyond the first 10 COGs are ignored.

🚧 **TODO:** We still need to determine how `plan_version` will interact with the other filters. Ideally the API would be able to query data across multiple plan versions (applying geographic crosswalks as necessary), but this functionality would add considerable technical complexity.

| Parameter | Description | Vector-Grid | Raster-Grid | Example |
|---|---|---|---|---|
| Partition and Non-Partition Dimensions | Any dimension from the partition and non-partition tables above | ✅ | ✅ | `aep=0.2` |
| `geography` | Geographies to include | ✅ | ✅ | `geography=24,81` |
| `filters` | Advanced filters in pyarrow format | ✅ | ❌ | `filters=[[("model_group","==",520),("calendar_date","<","2040-01-01")],[("model_group","==",521),("calendar_date",">=","2040-01-01")]]` |

#### Presort

The presort parameter sorts the filtered results prior to aggregation. This is usually only necessary when using an aggregation method where the order of values is important (e.g., difference). The parameter can accept multiple dimensions in a comma-separated list. Dimensions are sorted in ascending order by default unless prefixed with a minus sign (`-`) for descending order.

| Parameter | Description | Vector-Grid | Raster-Grid | Example |
|---|---|---|---|---|
| `presort` | Presort order | ✅ | ✅ | `presort=-calendar_date` |

#### Group and Aggregate

Group and aggregate parameters allow multiple rows or bands to be summarized as a single row or band. Unlike the geographic aggregations in the transformation step below, these aggregations operate on a single vector geography or raster pixel.

| Parameter | Description | Vector-Grid | Raster-Grid | Example |
|---|---|---|---|---|
| `group_by` | Group by dimensions | ✅ | ✅ | `group_by=model_group,scenario,aep` |
| `group_aggregate` | Aggregate function: one of `sum`, `difference`, `max`, `min`, or `mean` | ✅ | ✅ | `group_aggregate=difference` |


#### Transform and Extract

Transform and extract parameters can be used to change the shape or format of the resulting dataset, summarize data at higher geographic levels, or apply color maps to 

| Parameter | Description | Vector-Grid | Raster-Grid | Example |
|---|---|---|---|---|
| `color_map` | Apply the given color map to raster data | ❌ | ✅ | `color_map=ffibs` |
| `melt` | Melt results so that the resulting table has a geography column and a value column instead of a separate column for each geography | ✅ | ❌ | `melt=true` |
| `summarize_by` | Summarize by geographic unit | ✅ | ✅ | `summarize_by=hydro_compartment` |
| `summarize_aggregate` | Aggregate function: one of `sum`, `difference`, `max`, `min`, or `mean` | ✅ | ✅ | `summarize_aggregate=max` |
| `summarize_geography` | Limit the summary geographies to the provided IDs | ✅ | ✅ | `summarize_geography=659,680,700` |

#### Sort

The sort parameter sorts the final results. The parameter can accept multiple dimensions in a comma-separated list. Dimensions are sorted in ascending order by default unless prefixed with a minus sign (`-`) for descending order.

| Parameter | Description | Vector-Grid | Raster-Grid | Example |
|---|---|---|---|---|
| `sort` | Sort order | ✅ | ✅ | `sort=scenario,model_group,calendar_date` |


### Examples

The following examples illustrate common patterns of use for the data and analysis API.

#### Vector-Grid Data

##### Basic Map Query

This request returns daily mean salinity data for all extraction points on a specific date in the Arrow IPC format.

```
GET /data/v1/salinity_mean/extraction_point/daily.arrow?model_group=500&scenario=7&calendar_date=2030-01-01
```

##### Map Query Comparing Two Model Groups

This request returns the difference in daily mean salinity for two model groups on the same date in the Arrow IPC format.

```
GET /data/v1/salinity_mean/extraction_point/daily.arrow?model_group=500,501&scenario=7&calendar_date=2030-01-01&presort=-model_group&group_by=true&group_aggregate=difference
```

##### Basic Time Series Query

This request returns daily time series data for three extraction points in the arrow IPC format.

```
GET /data/v1/salinity_mean/extraction_point/daily.arrow?model_group=500&scenario=7&geography=79,842,1003&sort=calendar_date
```

##### Query with Additional Dimensions

This request returns annual exceedance damage, dollars (AEDD) for a single decade as newline-delimited JSON. Since the `aep`, `asset_type`, and `percentile` parameters are not provided, the query matches all available values for these dimensions. The results are summed across `asset_type` to provide the total damage for each AEP-percentile combination.

```
GET /data/v1/annual_exceedance_damages_dollars/clara/decadal.ndjson?model_group=500&scenario=7&pumping_id=0&fragility_scenario=0geography=12&group_by=aep,percentile&group_aggregate=sum&sort=aep,percentile
```

#### Vector-Grid Data

##### Basic Map Query

This request returns colorized FFIBS data for a single year as PNG map tiles.

```
GET /data/v1/vegetation_type_ffibs/icm_raster/annual/{z}/{x}/{y}.png?model_group=500&scenario=7&calendar_year=2045&color_map=ffibs
```

##### Map Query Comparing Two Years

This request returns the colorized flood depth difference between two years as PNG map tiles.

```
GET /data/v1/flood_depth/icm_raster/annual/{z}/{x}/{y}.png?model_group=500&scenario=7&calendar_year=2045,2050&presort=-calendar_year&group_by=true&group_aggregate=difference&color_map=flood_depth_difference
```

##### Time Series Query at Specific Points

This request returns a flood depth time series at three longitude-latitude pairs as a melted (long format) CSV.

```
GET /data/v1/flood_depth/icm_raster/annual.csv?model_group=500&scenario=7&geography=-90.4914181,30.0144111,-90.8628217,29.4254702,-91.3641637,29.5319325&melt=true&sort=calendar_year,geography
```

##### Single Year Query Summarized by Hydro Compartment

This request returns a flood depths for a single year summarized by hydro compartment as a melted (long format) Parquet file.

```
GET /data/v1/flood_depth/icm_raster/annual.parquet?model_group=500&scenario=7&calendar_year=2050&summarize_by=hydro_compartment&summarize_aggregate=mean&melt=true&sort=calendar_year,geography
```

## Catalog API

The catalog API provides routes for querying what datasets and combinations of dimensions are available in the data and analysis API. It uses a hierarchy of dimensions to allow cascading selection of datasets, as in the MP-DAP. This hierarchy follows the order of dataset, partition, and non-partition dimensions outlined above.

For dataset and partition dimensions, the catalog uses the data directory tree to determine the available choices for each dimension. For non-partition dimensions, it use the Parquet data and COG file names to determine the available choices.

🚧 **TODO:** We still need to finalize how to represent `calendar_date` ranges in the response without specifying each individual date. The syntax in the example below is one possibility.

🚧 **TODO:** If we are going to provide a unique `id` for each combination of dimensions, the catalog will need a way to store these IDs and the associated dimension values. The implementation used in the MP-DAP probably is not a good fit given the increase in dimensionality anticipated for the 2029 plan.

### Example

```
GET /catalog/v1?variable=salinity_mean&geographic_unit=hydro_compartment&time_unit=daily&plan_version=2029.1.0&model_group=500&scenario=7&calendar_date=2030-01-01
```

```json
{
  "choices": {
	"variable": ["annual_exceedance_damages_dollars", "expected_annual_damages_dollars", ...],
	"geographic_unit": ["extraction_point", "hydro_compartment"],
	"time_unit": ["annual", "daily"],
    "plan_version": ["2023.0.2", "2029.1.0"],
	"model_group": [500, 521],
	"scenario": [7, 8],
	"calendar_date": [["2025-01-01", "2044-12-31"], ["2050-01-01", "2070-12-31"]]
  },
  "dataset": {
	"id": "AQZ",
	"metric": "salinity_mean",
	"geographic_unit": "hydro_compartment",
	"time_unit": "daily",
	"model_group": 500,
	"scenario": 7,
	"calendar_date": "2030-01-01"
  },
  "exactMatch": true
}
```

## Quality Assurance/Quality Control (QA/QC)

In the 2023 Master Plan, the [QA/QC portal](https://mp2023.bridges2.psc.edu/) was created to provide support to the team in their review and analysis of simulation runs. This portal was built with the intention of supplanting the Google Sheet review process by offering one source to track all comments, approvals, and issues related to model runs. This portal also attempted to incorporate business logic that was formalized around the Google Sheet review process.

The existing QA/QC portal had several limitations that we hope to address in this next phase of development:

- **Rigid business logic:** The business logic that was decided upon was too strict when translated into the web portal format. Because results were displayed sequentially, users from teams that were part of later portions of the workflow were unable to review their data. This also meant that users from teams that were part of the earlier portions of the workflow were unable to review data from teams that were part of those later portions. Eventually, this system was relaxed so that users could view any data in the system.
- **Navigation:** The navigational layout of the system was extremely cumbersome. Rather than users being able to quickly find the data they were looking for, they would have to wade through multiple layers of data before arriving at their desired view.

### 2023 QA/QC Business Logic

For each of the subroutines in the 2023 QA/QC process, there were a variety of validation items. Every validation item for a given subroutine **had to be approved** before the next subroutine would be made available for review.

```mermaid
flowchart LR
    ML(Morph and LAVegMod Subroutine)
    BI(Barrier Islands Subroutine)
    HSI(HSIs Subroutine)

    subgraph H[Hydro Subroutine]
        ST(Stage)
        SA(Salinity)
        SE(Sediment)
        TE(Temperature)
        TR(Tidal Range)
    end

    subgraph ICM[ICM Simulation]
        direction LR
        H --> ML --> BI --> HSI
    end
```

### 2029 QA/QC Business Logic

We are strongly advocating for a more relaxed approach towards business logic definitions in the 2029 QA/QC process. We envision that this next phase of QA/QC will be guided by the need for policy flexibility and for business logic that is enabled by the software, but enforced by human intervention. Rather than a **rigid** QA/QC process, we propose a **flexible** QA/QC process.

In the **rigid** process, team members were required to approve individual metrics, validation items, and subroutines. Only then could an administrator approve the overarching simulation run. In the proposed **flexible** process, team members are no longer required to approve each individual step prior to administrator approval of the run. Rather, the administrator's simulation run approval will be guided by the existence and status of issues and comments.

### Issues and Comments

Issues and comments will be the driving force behind the flexible QA/QC process. **Issues** represent QA/QC tasks that needs to be completed (e.g., "Review Hydro outputs from S07 G500"). Issues can be nested under other issues to create subtasks, and they can be assigned to team members. Each issue has a status, such open or closed.

**Comments** are pieces of narrative text that contain discussion about an issue. They are attached to an issue and presented in chronological order. Comments may contain links (e.g., to a particular map or chart in the portal that illustrates a problem) and other rich text formatting.

Some of the key features that will be required to manage issues and comments include:

- **Labeling:** Issues need to be tagged with labels that allow for easy filtering. Some possible labels include the environmental scenario, model group, model or subroutine, and the type of resolution for closed issues.
- **Issue automation:** Some issues will need to be created automatically from a template when a model run completes. This will reduce the need for repetitive manual creation of issues for each run.
- **Notifications and mentions:** Issues need to support notifications that allow users to receive an e-mail when they are assigned an issue or when an issue they have participated in receives a new comment. Comments need the ability to include mentions that bring another user into the conversation.

### Dashboards

As we shift towards a flexible approval approach, we must create visualizations, reports, and metrics that administrators can use to determine whether a particular simulation run can be marked as approved. We propose the development of dashboards for this purpose. These dashboards will allow administrators to monitor the progress of simulation runs and perform their approval analysis. Dashboards we envision needing include:

- Simulation run status
- Open issues
- Closed issues
- Stale issues

The **flexible** QA/QC process requires that the business logic surrounding a simulation run's approval be enforced by humans rather than by the software. For example, if the team decides that a simulation run should never be approved if there are any unresolved issues, the administrator must ensure that this is the case prior to approving a simulation run. By not building this business logic (preconditions for approval) into the software, we will avoid having to adjust code or business logic once the portal is live. We believe that if logic shifts over time, this flexibility allows the team to avoid bottlenecks that would require developer intervention.


### QA/QC Workflow

In the flexible QA/QC process, issues, comments, and dashboards are used to track the status of tasks and approvals.

```mermaid
flowchart TD
    MR(Model run completes) --> IC(Issues for the run and review tasks are automatically created from template) --> ILA(Issues are automatically labeled and assigned) --> N(Assigned team members receive notifications) --> R(Team members perform review) --> C(Team members add comments to issues) --> ICl(Assigned team member labels and closes issue) --> AD(Administrator reviews dashboard) --> AC(Administrator labels and closes run issues)
    C --> M(Comments mention another team member) --> N
```

### QA/QC Software

Since many of the necessary features are already available in existing project management software, we recommend investigating the integration of a dedicated project management platform into the portal. We believe this type of integration will save development time and result in a more robust and flexible system. If this option is selected, we envision that the project management tool would be mostly transparent to the portal's users. That is, from the portal side, users would not have to open up this external system. Only those who wish to modify the business logic or who need to view administrative dashboards would directly interact with the project management software.

In addition to the issue and comment features described above, such an integration will require that the project management system support:

- Authentication using PSC credentials
- API access to perform create, read, update, and delete (CRUD) operations on issues and comments

If a suitable external project management system cannot be found, the issue, comment, and dashboard functionality could be built directly into the portal. However, this work would divert development effort from other priorities and would limit the ability to customize the resulting QA/QC system.

## Management API

The management API provides a RESTful interface for the data portal to interact with the project management system described above, read and write information related to the status of a particular Simulation Run, and provide authentication/authorization support for the other APIs.

The management API will be responsible for issuing requests to the project management system using either the App level user information, or the regular user information.

### Examples

#### Simulation Runs

##### Create a simulation run

This request would create a simulation run

```
POST /management/v1/simulation_runs

{
    "status": "to do",
    "model_group": "500",
    "scenario": "7"
}
```
                                                       
##### Get all simulation runs

This request returns all simulation runs.

```
GET /management/v1/simulation_runs
```

##### Get all simulation runs in model group 500

This request returns all simulation runs that are in model group 500.

```
GET /management/v1/simulation_runs?model_group=500
```

##### Get simulation_run by id

This request returns a simulation run based on its internal ID

```
GET /management/v1/simulation_runs/1000
```

##### Update a simulation run

This request would update a simulation run's information (status)

```
PUT /management/v1/simulation_runs/1000

{
    "status": "complete"
}
```

#### QA/QC

##### Get all tasks by simulation_run_id

This request would return all of the tasks associated with a simulation run

```
GET /management/v1/simulation_runs/1000/tasks
```

##### Get all tasks by simulation_run_id that are a progress tracking task

This request would return all of the tasks associated with a simulation run that are also progress tracking tasks

```
GET /management/v1/simulation_runs/1000/tasks?tags=progress_tracking_task
```

##### Get all tasks by simulation_run_id that are bugs

This request would return all of the tasks associated with a simulation run that are also bugs

```
GET /management/v1/simulation_runs/1000/tasks?tags=bug
```

##### Create task

This request would create a task, associated with a particular simulation run

```
POST /management/v1/simulation_runs/1000/tasks

{
    "tags": ["bug"],
    "name": "Critical Error with Salinity",
    "assignees": [1000, 1001]
}
```

##### Get all comments for a task

This request would return all task-level comments for a particular task

```
GET /management/v1/simulation_runs/1000/tasks/1001/comments
```

##### Get all replies for a comment

This request would return all of the replies to a comment

```
GET /management/v1/simulation_runs/1000/tasks/1001/comments/1002/replies
```

##### Create comment

This request would create a comment for a task

```
POST /management/v1/simulation_runs/1000/tasks/1001/comments

{
    "comment_text": "Hello world",
    "assignees": [1000]
    "notify_all": true 
}

```

##### Create reply

This request would create a comment for a task

```
POST /management/v1/simulation_runs/1000/tasks/1001/comments/1002/replies

{
    "comment_text": "Hello world",
    "assignees": [1000]
    "notify_all": true 
}
```

#### User Auth(orization/entication)
 
##### Register new user

This request registers a new user in the management API

```
POST /management/v1/users

{
    "username": "foobar",
    "first_name": "foo",
    "last_name": "bar,
    "password": "password",
    "email": "foo@bar.com",
    "role": "readonly_user"
}
```


##### Update user information

This request updates a user in the management API

```
PUT /management/v1/users

{
    "role": "admin"
}
```

##### Get JSON Web Token

This request updates a user in the management API

```
POST /management/v1/tokens

{
    "username": "foobar",
    "password": "password"
}
```

##### Renew JSON Web Token

This request updates a user in the management API

```
POST /management/v1/tokens/refresh

{
    "refresh": "abc"
}
```

##### Get ClickUp OAuth URL

This request gets an OAuth URL to kick off the OAuth routine.

```
GET /management/v1/clickup/oauth
```

##### Set ClickUp OAuth Code

This request updates a user in the management API

```
POST /management/v1/clickup/oauth

{
    "username": "foobar",
    "code": "xyz"
}
```

##### Get ClickUp users

This request returns all users that can be assigned in ClickUp

```
GET /management/v1/clickup/users
```

##### Get ClickUp teams

This request returns all teams that can be assigned in ClickUp

```
GET /management/v1/clickup/teams
```

