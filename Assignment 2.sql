USE SuperstoreDB;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

SELECT * FROM SuperStore 



-- 2.) Exploring the Table
USE SuperstoreDB;
GO
SELECT TOP 10 *
FROM SuperStore; 

-- Checking total rows
SELECT COUNT(*) AS Total_Rows
FROM SuperStore;


-- 3.) Apply WHERE Filters
-- Region
SELECT * 
FROM SuperStore
WHERE Region = 'West';   

-- Category

SELECT * 
FROM SuperStore
WHERE Category = 'Technology'; 

-- Date

SELECT * 
FROM SuperStore
WHERE Order_Date BETWEEN '2016-01-01' AND '2016-11-7';


-- Sales
SELECT * 
FROM SuperStore
WHERE Sales > 1000; 



-- 4.) Aggregation Using GROUP BY

-- Total Sales by Region
SELECT Region,
	SUM(Sales) AS Total_Sales
FROM SuperStore
GROUP BY Region;

-- Total Quantity by Category
SELECT Category,
	SUM(Quantity) AS Total_Quantity
FROM SuperStore
GROUP BY Category;

-- Average Sales by Category
SELECT Category,
       AVG(Sales) AS Average_Sales
FROM SuperStore
GROUP BY Category;



-- 5.) Sort and Limit Results

-- Top 10 Products
SELECT TOP 10 Product_Name,
       SUM(Sales) AS Total_Sales
FROM SuperStore
GROUP BY Product_Name
ORDER BY Total_Sales DESC;

-- Top Categories
SELECT Category,
       SUM(Sales) AS Total_Sales
FROM SuperStore
GROUP BY Category
ORDER BY Total_Sales DESC;


-- 6.) Use Cases

-- Monthly Sales Trend
SELECT YEAR(Order_Date) AS Year,
       MONTH(Order_Date) AS Month,
       SUM(Sales) AS Total_Sales
FROM SuperStore
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;

-- Top 10 Customers
SELECT TOP 10 Customer_Name,
       SUM(Sales) AS Total_Sales
FROM SuperStore
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

-- Duplicate Values
SELECT Order_ID,
       COUNT(*) AS Duplicate_Count
FROM SuperStore
GROUP BY Order_ID
HAVING COUNT(*) > 1;



-- 7.) Validate Results
SELECT COUNT(*) AS Total_Rows
FROM SuperStore;

-- Check missing values
SELECT *
FROM SuperStore
WHERE Sales IS NULL
   OR Quantity IS NULL
   OR Customer_Name IS NULL
   OR Region IS NULL;

-- Count Missing Values
SELECT
SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Missing_Sales,
SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS Missing_Customers
FROM SuperStore;

