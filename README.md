# Azure End to End Data Engineering Adventure Works Project

## Table of Contents  

1. [Project Description](#project-description)
2. [Technical Components](#technical-components)
3. [Data Architecture](#data-architecture)
4. [Azure Data Factory (Ingestion and Orchestration)](#azure-data-factory)
   - [Objective](#objective-adf)
   - [Pipeline Architecture](#pipeline-architecture)
   - [1- PL_Extract_Raw_Data](#pl_extract_raw_data)
   - [2- PL_Trans_Load](#pl_trans_load)
5. [Azure Databricks (Transformation)](#azure-databricks)
   - [Objective](#objective-databricks)
   - [Considerations](#considerations)
   - [Development and Production Notebooks Overview](#development-and-production)
   - [Development Notebook](#development-notebook)
   - [Production Notebook](#production-notebook)
6. [Azure Synapse Analytics (Serving)](#azure-synapse-analytics)
   - [Objective](#objective-synapse)
   - [Steps](#steps-synapse)
7. [Power BI (Visualization)](#power-bi)
   - [Objective](#objective-powerbi)
   - [Steps](#steps-powerbi)
   - [Visualizations](#visualizations)

## Project Description

<p align="justify">This project focuses on building a comprehensive, <b>end-to-end Azure Data Engineering solution</b> that seamlessly integrates data ingestion, transformation, and analytics. It is designed to follow the principles of the <b>Medallion Architecture</b>, ensuring a structured and scalable approach to data processing. By implementing this architecture, the solution facilitates an efficient and organized data flow, transitioning from raw ingestion to progressively refined and enriched datasets. These optimized datasets will ultimately support advanced analytics and reporting, enabling stakeholders to derive meaningful insights and make data-driven decisions with confidence. 
</p>

## Technical Components <a name="technical-components"></a>
 
 - **GitHub:** Data source.
 - **Azure Data Lake:** Centralized storage for transformed data.
 - **Azure Data Factory (ADF):** Data integration and orchestration platform.
 - **Databricks:** Data transformation.
 - **Azure Synapse Analytics:** Data analysis.
 - **Power BI:** Visualization and reporting.

## Data Architecture <a name="data-architecture"></a>

<img src="https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Pictures/Architecture_Project_01.pdf" alt="image" width="550" height="auto">

## Azure Data Factory (Ingestion and Orchestration) <a name="azure-data-factory"></a>
### Objective <a name="objective-adf"></a>

<p align="justify">The purpose of this section in the README is to explain the modular architecture of the pipelines implemented in Azure Data Factory, detailing their structure and functionality for data <b>ingestion</b>, <b>transformation</b>, and <b>orchestration</b>. The main goal is to highlight how the architecture is designed to be efficient, reusable, and scalable, facilitating maintenance and version control.</p>

### Pipeline Architecture <a name="pipeline-architecture"></a>

<p align="justify">A <b>modular pipeline structure</b> was chosen to improve reusability, maintainability, and scalability. By breaking processes into smaller modules, updates and reuse can be done without affecting the main workflow. It also allows for more efficient error management, optimizes performance by enabling parallel execution, and enhances the understanding of the workflow. This modular approach also <b>simplifies version control</b> and deployment of specific changes without disrupting the overall system.</p>

The architecture is based on the following steps:

<img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Production.png" alt="image" width="500" height="auto">

#### **1- PL_Extract_Raw_Data:** <a name="pl_extract_raw_data"></a>

<p align="justify">Extracting all Adventures Works folders in GitHub, by using a <b>dynamic copy parameter to extract the path URL and file destination</b> within a forEach activity that reads the corresponding url address and loads the data through a json file placed in the Lookup Activity.</p>

<img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data.png" alt="image" width="500" height="auto">

##### **Steps:**
  - **Creation a Dynamic Copy Activity:**
    
     **1- Creation of source connection:**
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_source.png" alt="image" width="500" height="auto">    

     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_source_inside.png" alt="image" width="500" height="auto">


     **2- Creation of sink connection:**
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_sink.png" alt="image" width="500" height="auto">
     
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_sink_inside.png" alt="image" width="600" height="auto">


  - **Creation of LookUp Activity by using json parameter:**
    
     **1- Create a JSON file:** It is used a JSON to create dynamic parameters that automate the extraction and loading of data. The structure of the JSON is broken down below:
       - **p_rel_url:** Relative URL of the data source.  
       - **p_sink_folder:** Target folder in the ADLS Gen2 bronze layer.  
       - **p_sink_file:** Target file name and format.

         Then it is uploaded it into our Data Lake in the parameters folder. [Format of JSON](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Codes/Dynamic_Pipeline.json)


     **2- Create a LookUp Activity:**    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_LookUp_source_inside.png" alt="image" width="700" height="auto">
     
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_LookUp_source.png" alt="image" width="500" height="auto">

     
  - **Creation of forEach Activity and put inside the Dynamic Copy:** (Extract the values from the LookUp Activity which uses the json script)
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_forEach_settings.png" alt="image" width="480" height="auto">

  - **PL_Extract_Data results:**

     **Bronze Folder:**

     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/Data%20Ingestion%20(Bronze%20folder).png" alt="image" width="500" height="auto">

#### **2- PL_Trans_Load:**<a name="pl_trans_load"></a>

<p align="justify">In this pipeline, an extraction of the transformations made in the notebook <b>Prod - Databricks Transformations (Silver_layer)</b> has been carried out.</p>

<img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans.png" alt="image" width="250" height="auto">

##### **Steps:**
  - **Creation an Access Token inside of Databricks:**
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans_databricks_linked_Access_Token.png" alt="image" width="500" height="auto">

  - **Creation a Databricks connection:**
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans_databricks_linked.png" alt="image" width="500" height="auto">

  - **Creation a Notebook Activity:**
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans_settings.png" alt="image" width="400" height="auto">

  - **PL_Trans_Load results:**
   
     **Silver Folder:**

     <img src="https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Pictures/Data%20Transformation%20(Silver%20folder).png" alt="image" width="400" height="auto">

## Azure Databricks (Transformation) <a name="azure-databricks"></a>
### Objective: <a name="objective-databricks"></a>
<p align="justify">The <b>purpose of the silver layer</b> in a data lake, using <b>Azure Databricks</b>, is to <b>provide cleaned, enriched, and transformed data</b> that is ready for further analytics and business intelligence processes. It acts as an intermediary between the raw ingested data (bronze layer) and the final, highly curated data (gold layer).</p> 

### Considerations <a name="considerations"></a>
- **Pre-processed Data:**  
  <p align="justify">Since the data is sourced from Kaggle, it is already pre-processed and well-structured. Therefore, the typical data cleaning and enrichment processes, such as handling missing values, deduplication, and standardization, are not required in this case.</p>

- **Single-Node Cluster:**  
  <p align="justify">Due to the relatively small size of the dataset, a single-node Databricks cluster is sufficient to handle the processing tasks efficiently. This setup helps reduce costs while still providing the necessary compute resources for transformation and validation tasks.</p>

- **Performance Optimization:**  
  <p align="justify">Despite the dataset’s small size, optimization techniques such as storing data in Parquet format and using Delta Lake for versioning and incremental updates are still applied to ensure scalability if data volume increases in the future.</p>


### Development and Production Notebooks Overview: <a name="development-and-production"></a>

<p align="justify">To implement the transformation process effectively, two Databricks notebooks were created:</p>

- **Development Notebook:** Used for building and testing the transformation logic.

- **Production Notebook:** Optimized for automated runs in the pipeline.

### Development Notebook: <a name="development-notebook"></a>

The development notebook consists of the following four parts:

1. **Data Access Using App**  
   - Connect to the data source using the appropriate application and authentication methods.  
   - Access the raw data stored in the Azure Data Lake (bronze layer).  
   - Ensure secure and efficient data retrieval.  

2. **Data Loading**  
   - Load the extracted data into Databricks for further processing.    

3. **Transformations**  
   - Validate schema consistency before proceeding to transformations. 
   - Apply business logic and transformations to refine the data.  
   - Perform operations such as filtering, aggregations, and joins.
   - Convert the data into optimized formats such as Parquet or Delta Lake for better performance.
   - Store the transformed data in the silver layer for further analysis.  

5. **Quick Sales Analysis**  
   - Perform initial exploratory analysis on the processed data.  
   - Generate key sales insights and trends.  
   - Visualize results using Databricks built-in visualization tools.

You can view the notebook here:  
[**Development Notebook**](https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Codes/Dev%20-%20Databricks%20Transformations%20(Silver_layer).ipynb)

### Production Notebook: <a name="production-notebook"></a>

<p align="justify">Once the development notebook was verified and tested, a separate production notebook was created with modifications to ensure it is optimized for automated, scheduled runs. The production notebook focuses exclusively on the data extraction, loading, and transformation steps, ensuring efficient execution without additional overhead. It is fully integrated into the Azure Data Factory pipeline, providing a stable and consistent data processing workflow. The following adjustments were made:</p>

- **Markdown cells removed:** To streamline execution by removing unnecessary documentation.

- **Display cells removed:** To eliminate outputs used only for exploratory purposes.

- **Quick Sales Analysis section removed:** Since it was only relevant for development and not part of the production pipeline.

You can view the notebook here:  
[**Production Notebook**](https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Codes/Prod%20-%20Databricks%20Transformations%20(Silver_layer).ipynb)


## Azure Synapse Analytics (Serving) <a name="azure-synapse-analytics"></a>
### Objective: <a name="objective-synapse"></a>
After transforming the data in the **Silver layer**, the processed data is structured within **Azure Synapse** to provide optimized query performance and facilitate data access. This process involves creating **views** and **external tables** to integrate data from the Data Lake, providing an easy way to work with the data without needing to move it into the Synapse SQL pool.

### **Steps:** <a name="steps-synapse"></a>

1. **Creating Master Key and Schema**
- First, the **master key** for database encryption was created to ensure data security:
   ```sql
   CREATE MASTER KEY ENCRYPTION BY PASSWORD = '**********';

2. **Schema was created within the database to organize the data:**
   ```sql
   CREATE SCHEMA gold;

3. **Creating Views for Data Access**
Views were created on top of the data stored in the silver layer to simplify querying and present the data in a consumable format. These views are based on OPENROWSET, which allows querying data directly from the Data Lake.
You can view the full Synapse sql script here:  
[Azure Synapse Views](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Codes/Azure%20Synapse%20(Views).sql)

5. **Setting Up External Data Sources**
To access data from the Data Lake and load it into the Synapse environment, external data sources were configured:
- Create Managed Identity and Credentials
   ```sql
   CREATE DATABASE SCOPED CREDENTIAL cred_david
   WITH IDENTITY = 'Managed Identity';

- Define External Data Sources for Silver and Gold Layers:
  ```sql
  CREATE EXTERNAL DATA SOURCE source_silver
  WITH (
      LOCATION = 'https://awstorageproject01.blob.core.windows.net/silver',
      CREDENTIAL = cred_david
  );
   
  CREATE EXTERNAL DATA SOURCE source_gold
  WITH (
      LOCATION = 'https://awstorageproject01.blob.core.windows.net/gold',
      CREDENTIAL = cred_david
  );
  
5. **Creating External File Format for Parquet**
- A Parquet file format was defined to ensure proper handling of the Parquet data:
   ```sql
   CREATE EXTERNAL FILE FORMAT format_parquet
   WITH (
      FORMAT_TYPE = PARQUET,
      DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
   );
   
6. **Creating External Tables**
External tables were created to allow Synapse to access Parquet files stored in the Data Lake while enabling structured querying within Synapse.
- Create External Table for Sales Data:
  [Azure Synapse External Tables](https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Codes/Azure%20Synapse%20(External%20Tables).sql)
   
7. **Result in Served data store (gold)**: [Final gold files](https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/tree/main/Data/Results)

   ![image](https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/KPIs%20(Gold%20Folder).png)

## Power BI (Visualization) <a name="power-bi"></a>
### Objective: <a name="objective-powerbi"></a>
Visualize and report the processed data.

### Steps: <a name="steps-powerbi"></a>
1. Use Microsoft Power BI to retrieve data directly from the gold folder by using Data lake connection, ensuring that the data is automatically refreshed through the cloud pipeline.
2. Build an interactive dashboard showcasing sales data and insights.

### Visualizations: <a name="visualizations"></a> [Dashboard](https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Codes/Dashboard_PowerBI.pbix)

<img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/Dashboard_Power_BI_Product.png" alt="image" width="500" height="auto">
<img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/Dashboard_Power_BI_Countries.png" alt="image" width="500" height="auto">
