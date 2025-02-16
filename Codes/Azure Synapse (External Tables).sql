CREATE DATABASE SCOPED CREDENTIAL cred_david
WITH
    IDENTITY = 'Managed Identity'

CREATE EXTERNAL DATA SOURCE source_silver
WITH
(
    LOCATION = 'https://awstorageproject01.blob.core.windows.net/silver',
    CREDENTIAL = cred_david
)

CREATE EXTERNAL DATA SOURCE source_gold
WITH
(
    LOCATION = 'https://awstorageproject01.blob.core.windows.net/gold',
    CREDENTIAL = cred_david
)

CREATE EXTERNAL FILE FORMAT format_parquet
WITH
(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)

---------------------------------
-- CREATE EXTERNAL TABLE SALES --
---------------------------------
CREATE EXTERNAL TABLE gold.sales_performance_by_month
WITH
(
    LOCATION = 'sales_performance_by_month',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT 
    d.Year, 
    d.Month,
    ROUND(SUM(p.ProductPrice * s.OrderQuantity), 2) AS TotalRevenues,
    ROUND(SUM(p.ProductCost * s.OrderQuantity), 2) AS TotalExpenses,
    ROUND(SUM(p.ProductPrice * s.OrderQuantity) - SUM(p.ProductCost * s.OrderQuantity), 2) AS Profit
FROM gold.sales s
JOIN gold.calendar d ON s.OrderDate = d.Date
JOIN gold.products p ON s.ProductKey = p.ProductKey
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month


CREATE EXTERNAL TABLE gold.sales_performance_by_product
WITH
(
    LOCATION = 'sales_performance_by_product',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT 
    d.Year, 
    d.Month,
    p.ProductName,
    ROUND(SUM(p.ProductPrice * s.OrderQuantity), 2) AS TotalRevenues,
    ROUND(SUM(p.ProductCost * s.OrderQuantity), 2) AS TotalExpenses,
    ROUND(SUM(p.ProductPrice * s.OrderQuantity) - SUM(p.ProductCost * s.OrderQuantity), 2) AS Profit,
    ROUND(AVG(s.OrderQuantity), 2) AS AvgQuantity
FROM gold.sales s
JOIN gold.calendar d ON s.OrderDate = d.Date
JOIN gold.products p ON s.ProductKey = p.ProductKey
GROUP BY d.Year, d.Month, p.ProductName
ORDER BY d.Year, d.Month, p.ProductName;


CREATE EXTERNAL TABLE gold.sales_performance_by_country
WITH
(
    LOCATION = 'sales_performance_by_country',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
SELECT 
    d.Year, 
    d.Month,
    t.Country, 
    ROUND(SUM(p.ProductPrice * s.OrderQuantity), 2) AS TotalSales,
    ROUND(SUM(p.ProductCost * s.OrderQuantity), 2) AS TotalExpenses,
    ROUND(SUM(p.ProductPrice * s.OrderQuantity) - SUM(p.ProductCost * s.OrderQuantity), 2) AS Profit
FROM gold.sales s
JOIN gold.calendar d ON s.OrderDate = d.Date
JOIN gold.territories t ON s.TerritoryKey = t.SalesTerritoryKey
JOIN gold.products p ON s.ProductKey = p.ProductKey
GROUP BY d.Year, d.Month, t.Country
ORDER BY d.Year, d.Month, t.Country;


CREATE EXTERNAL TABLE gold.sales_performance_by_education
WITH
(
    LOCATION = 'sales_performance_by_education',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
)
AS
WITH totalsales AS (
    SELECT 
        d.Year, 
        d.Month,
        t.Country, 
        SUM(p.ProductPrice * s.OrderQuantity) AS TotalSales
    FROM gold.sales s
    JOIN gold.calendar d ON s.OrderDate = d.Date
    JOIN gold.territories t ON s.TerritoryKey = t.SalesTerritoryKey
    JOIN gold.products p ON s.ProductKey = p.ProductKey
    GROUP BY d.Year, d.Month, t.Country
)
SELECT 
    d.Year, 
    d.Month,
    t.Country,
    c.EducationLevel, 
    ROUND(SUM(p.ProductPrice * s.OrderQuantity), 2) AS TotalSales,
    ROUND(100.0 * SUM(p.ProductPrice * s.OrderQuantity) / ts.TotalSales, 2) AS SalesPercentage
FROM gold.sales s
JOIN gold.calendar d ON s.OrderDate = d.Date
JOIN gold.territories t ON s.TerritoryKey = t.SalesTerritoryKey
JOIN gold.products p ON s.ProductKey = p.ProductKey
JOIN gold.customers c ON s.CustomerKey = c.CustomerKey
JOIN totalsales ts ON d.Year = ts.Year AND d.Month = ts.Month AND t.Country = ts.Country
GROUP BY d.Year, d.Month, t.Country, c.EducationLevel, ts.TotalSales
ORDER BY d.Year, d.Month, t.Country, c.EducationLevel;
