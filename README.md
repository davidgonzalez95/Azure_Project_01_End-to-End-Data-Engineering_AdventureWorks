# Azure End to End Data Engineering Adventure Works Project

## Table of Contents

1. [Project Description](#project-description)
2. [Technical Components](#technical-components)
3. [Data Architecture](#data-architecture)
   - [Part 1: Data Ingestion (ADLS Gen2 / Azure Data Factory)](#part-1-data-ingestion-adls-gen2-azure-data-factory)
   - [Part 2: Data Transformation (Azure Databricks)](#part-2-data-transformation-azure-databricks)
   - [Part 3: Serving (Azure Synapse: Data Views and External Tables)](#part-3-serving-azure-synapse-data-views-and-external-tables)
   - [Part 4: Data Reporting (Power BI)](#part-4-data-reporting-power-bi)
   - [Part 5: End-to-End Pipeline Testing (Azure Data Factory)](#part-5-end-to-end-pipeline-testing-azure-data-factory)

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

   ![image](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Pictures/Architecture.png)

## 1-Azure Data Factory (Ingestion and Orchestration)
### Pipeline Architecture <a name="pipeline-architecture"></a>

<p align="justify">A <b>modular pipeline structure</b> was chosen to improve reusability, maintainability, and scalability. By breaking processes into smaller modules, updates and reuse can be done without affecting the main workflow. It also allows for more efficient error management, optimizes performance by enabling parallel execution, and enhances the understanding of the workflow. This modular approach also <b>simplifies version control</b> and deployment of specific changes without disrupting the overall system.</p>

The architecture is based on the following steps:

<img src="" alt="image" width="500" height="auto">

#### **1- PL_Extract_Raw_Data:** <a name="pl_extract_raw_data"></a>

<p align="justify">Extracting sales data for January from the subsidiaries' SharePoint repositories (simulated in GitHub), by using a <b>dynamic copy parameter to extract the path URL and file destination</b>b> within a forEach activity that reads the corresponding url address and loads the data through a json file placed in the Lookup Activity.</p>

<img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data.png" alt="image" width="500" height="auto">

##### **Steps:**
  - **Creation a Dynamic Copy Activity:**
    
     **1- Creation of source connection:**
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_source_inside.png" alt="image" width="500" height="auto">
     
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_source.png" alt="image" width="500" height="auto">

     **2- Creation of sink connection:**
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_sink_inside.png" alt="image" width="500" height="auto">
     
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_CopyActivity_sink_inside.png" alt="image" width="500" height="auto">

  - **Creation of LookUp Activity by using json parameter:**
     **1- Create a JSON file:** It is used a JSON to create dynamic parameters that automate the extraction and loading of data. The structure of the JSON is broken down below:
        - **`p_rel_url`** – Relative URL of the data source.  
        - **`p_sink_folder`** – Target folder in the ADLS Gen2 bronze layer.  
        - **`p_sink_file`** – Target file name and format.
          Then it is uploaded it into our Data Lake in the parameters folder.[Format of JSON](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Codes/Dynamic_Pipeline.json)

     **2- Create a LookUp Activity:**    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_LookUp_source_inside.png" alt="image" width="500" height="auto">
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_LookUp_source.png" alt="image" width="500" height="auto">
     
  - **Creation of forEach Activity and put inside the Dynamic Copy:** (Extract the values from the LookUp Activity which uses the json script)
    
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Extract_Raw_Data/PL_Extract_Raw_Data_forEach_settings.png" alt="image" width="500" height="auto">

#### PL_Extract_Data results:

   - **Bronze Folder:**

     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/Data%20Ingestion%20(Bronze%20folder).png" alt="image" width="200" height="auto">

### **2- PL_Trans_Load:**<a name="pl_trans_load"></a>

<p align="justify">In this pipeline, an extraction of the transformations made in the notebook <b>Prod - Databricks Transformations (Silver_layer)</b> has been carried out.</p>

    <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans.png" alt="image" width="250" height="auto">

##### **Steps:**
  - **Creation an Access Token inside of Databricks:**
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans_databricks_linked_Access_Token.png" alt="image" width="500" height="auto">

  - **Creation a Databricks connection:**
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans_databricks_linked.png" alt="image" width="500" height="auto">

  - **Creation a Notebook Activity:**
     <img src="https://github.com/davidgonzalez95/Azure_Project_01_End-to-End-Data-Engineering_AdventureWorks/blob/main/Pictures/PL_Load_Trans/PL_Load_Trans_settings.png" alt="image" width="500" height="auto">






## Part 2: Data Transformation (Azure Databricks)

### Objective:
The **purpose of the silver layer** in a data lake, using **Azure Databricks**, is to **provide cleaned, enriched, and transformed data** that is ready for further analytics and business intelligence processes. It acts as an intermediary between the raw ingested data (bronze layer) and the final, highly curated data (gold layer). 

### Considerations
- **Pre-processed Data:**  
  Since the data is sourced from Kaggle, it is already pre-processed and well-structured. Therefore, the typical data cleaning and enrichment processes, such as handling missing values, deduplication, and standardization, are not required in this case.

- **Single-Node Cluster:**  
  Due to the relatively small size of the dataset, a single-node Databricks cluster is sufficient to handle the processing tasks efficiently. This setup helps reduce costs while still providing the necessary compute resources for transformation and validation tasks.

- **Performance Optimization:**  
  Despite the dataset’s small size, optimization techniques such as storing data in Parquet format and using Delta Lake for versioning and incremental updates are still applied to ensure scalability if data volume increases in the future.


### Databricks Workflow Overview:

The following steps are performed within Databricks to process the data effectively:
You can view the full Databricks notebook here:  
[Databricks Notebook (Silver_layer)](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Codes/Databricks%20Transformations%20(Silver_layer).ipynb)

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
   - 
6. **Result in tranformation store (silver)**:
     
   ![image](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Pictures/Data%20Transformation%20(Silver%20folder).png)

## Part 3: **Serving (Azure Synapse: Data Views and External Tables)**

### Objective:
After transforming the data in the **Silver layer**, the processed data is structured within **Azure Synapse** to provide optimized query performance and facilitate data access. This process involves creating **views** and **external tables** to integrate data from the Data Lake, providing an easy way to work with the data without needing to move it into the Synapse SQL pool.

### **Steps Performed in Synapse:**

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
[Azure Synapse SQL script)](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Codes/Azure%20Synapse%20(Views).sql)

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
   ```sql
   CREATE EXTERNAL TABLE gold.ext_sales
   WITH (
      LOCATION = 'ext_sales',
      DATA_SOURCE = source_gold,
      FILE_FORMAT = format_parquet
   )
   AS
   SELECT * FROM gold.sales;
   
7. **Result in Served data store (gold)**:

   ![image](https://github.com/davidgonzalez95/End-to-End-Data-Engineering-on-Azure-Project/blob/main/Pictures/Data%20Transformation%20(Silver%20folder).png

## Part 4: Data Reporting (Power BI)

### Objective:
Visualize and report the processed data.

### Steps:
1. Use Microsoft Power BI to retrieve data directly from the views using DirectQuery, ensuring that the data is automatically refreshed through the cloud pipeline.
2. Build an interactive dashboard showcasing sales data and insights.

## Part 5: End-to-End Pipeline Testing (Azure Data Factory)

### Objective:
Automate and test the pipeline for continuous data integration.

### Steps:
1. Set up a Scheduled Trigger in Azure Data Factory, allowing the pipeline to run daily, automatically extracting, transforming, and loading new data.
2. Test the trigger by running the pipeline and observing the before and after states of the data.
