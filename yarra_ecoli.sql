-- ========================================================
-- Yarra River E. coli Data Analysis
-- Project: SQL queries for EPA / Melbourne Water dataset
-- File: yarra_ecoli.sql
-- ========================================================

-- CSV Import
LOAD DATA INFILE 'Yarra_Watch_E.coli_data.csv'
INTO TABLE EcoliSamples
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS -- WHAT DOES THIS DO 
(Site_ID, Site_Name, Sample_DateTime, Ecoli_Value, Ecoli_Qualifier);


-- Drop table if it exists
DROP TABLE IF EXISTS EcoliSamples

-- Create Table
CREATE TABLE EcoliSamples (
    Site_ID INT, 
    Site_name VARCHAR(100),
    Sample_DateTime DATETIME,
    Ecoli_Value INT,
    Ecoli_Qualifer VARCHAR(5)
);

-- ========================================================
-- Queries
-- ========================================================

-- Overview by site
SELECT Site_Name,
        COUNT(*) AS SampleCount,
        AVG(Ecoli_Value) AS AvgEcoli,
        MAX(Ecoli_Value) AS MaxEcoli,
        MIN(Ecoli_Value) AS MinEcoli
FROM EcoliSamples
GROUP BY Site_Name
ORDER BY AvgEcoli DESC;

-- Yearly trend for a specific site (eg Kew)
SELECT YEAR(Sample_DateTime) as Year,
        AVG(Ecoli_Value) AS AvgEcoli
FROM EcoliSamples
WHERE Site_Name = 'Kew'
GROUP BY YEAR(Sample_DateTime)
GROUP BY Year;

-- Samples exceeding threshold (eg 1000 orgs/100 ml)
SELECT YEAR(Sample_DateTime) AS Year, 
        AVG(Ecoli_Value) AS AvgEcoli
FROM EcoliSamples 
WHERE Site_Name = 'Kew'
GROUP BY YEAR(Sample_DateTime)
GROUP BY Year;

-- Duplicate records check 
SELECT Site_ID, Sample_DateTime, COUNT(*) AS DuplicateCount
FROM EcoliSamples
GROUP BY Site_ID, Sample_DateTime
HAVING COUNT(*) > 1; 

-- Missing values check
SELECT COUNT(*) AS MissingEcoli 
FROM EcoliSamples 
GROUP BY YEAR(Sample_DateTime)
GROUP BY Year;

-- Top most contaminated sites by average E. coli
SELECT Site_Name, 
        AVG(Ecoli_Value) AS AvgEcoli
FROM EcoliSamples
GROUP BY Site_Name
ORDER BY AvgEcoli DESC
LIMIT 5;

