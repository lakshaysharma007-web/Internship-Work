USE SuperstoreDB_New;
GO
/*
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME IN ('customers','products','orders');

CREATE TABLE customers
(
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50)
);


INSERT INTO customers
SELECT DISTINCT
       Customer_ID,
       Customer_Name,
       Segment
FROM superstore_raw;



CREATE TABLE products
(
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(255),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100)
);



INSERT INTO products
SELECT DISTINCT
       Product_ID,
       Product_Name,
       Category,
       Sub_Category
FROM superstore_raw;



CREATE TABLE orders
(
    Order_ID VARCHAR(30),
    Order_Date DATE,
    Customer_ID VARCHAR(20),
    Product_ID VARCHAR(50),
    Sales DECIMAL(18,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(18,2)
);


INSERT INTO orders
SELECT DISTINCT
       Order_ID,
       Order_Date,
       Customer_ID,
       Product_ID,
       Sales,
       Quantity,
       Discount,
       Profit
FROM superstore_raw;


*/


-- Query 1: Find orders whose sales are greater than average sales
SELECT *
FROM orders
WHERE Sales >
(
    -- Calculate average sales of all orders
    SELECT AVG(Sales)
    FROM orders
);


-- Query 2: Find the highest sales order for every customer
SELECT *
FROM orders o
WHERE Sales =
(
    -- Find maximum sales for the current customer
    SELECT MAX(Sales)
    FROM orders
    WHERE Customer_ID = o.Customer_ID
);


-- Query 3: Calculate total sales for each customer using CTE

WITH CustomerSales AS
(
    -- Summing sales customer-wise
    SELECT Customer_ID,
           SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY Customer_ID
)

-- Display total sales of each customer
SELECT *
FROM CustomerSales;

-- Query 4: Find customers whose total sales are above average

WITH CustomerSales AS
(
    -- Calculate total sales for each customer
    SELECT Customer_ID,
           SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY Customer_ID
)

SELECT *
FROM CustomerSales
WHERE TotalSales >
(
    -- Calculate average of total customer sales
    SELECT AVG(TotalSales)
    FROM CustomerSales
);


-- Query 5: Rank customers based on their total sales

WITH CustomerSales AS
(
    SELECT Customer_ID,
           SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY Customer_ID
)

SELECT Customer_ID,
       TotalSales,

       -- Assign rank based on highest sales
       RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank
FROM CustomerSales;



-- Query 6: Assign row numbers to orders for each customer

SELECT Order_ID,
       Customer_ID,
       Order_Date,

       -- Number orders separately for each customer
       ROW_NUMBER() OVER
       (
           PARTITION BY Customer_ID
           ORDER BY Order_Date
       ) AS RowNum

FROM orders;




-- Query 7: Display top 3 customers based on total sales

WITH CustomerSales AS
(
    SELECT Customer_ID,
           SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY Customer_ID
)

SELECT *
FROM
(
    SELECT Customer_ID,
           TotalSales,

           -- Rank customers by sales
           RANK() OVER(ORDER BY TotalSales DESC) AS SalesRank

    FROM CustomerSales
) RankedCustomers

-- Show only top 3 ranked customers
WHERE SalesRank <= 3;



-- STEP 3. Final Query: Display customer name, total sales and rank

WITH CustomerSales AS
(
    -- Calculate total sales for each customer
    SELECT Customer_ID,
           SUM(Sales) AS TotalSales
    FROM orders
    GROUP BY Customer_ID
)

SELECT
       c.Customer_Name,
       cs.TotalSales,

       -- Rank customers based on total sales
       RANK() OVER(ORDER BY cs.TotalSales DESC) AS SalesRank

FROM CustomerSales cs
JOIN customers c
     ON cs.Customer_ID = c.Customer_ID;



-- MINI PROJECT QUESTIONS
-- QUES 1. TOP 5 CUSTOMERS

WITH customer_sales AS
(
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT TOP 5
       c.customer_name,
       cs.total_sales
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id
ORDER BY cs.total_sales DESC;


-- QUES 2. BOTTOM 5 CUSTOMERS
WITH customer_sales AS
(
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT TOP 5
       c.customer_name,
       cs.total_sales
FROM customer_sales cs
JOIN customers c
ON cs.customer_id = c.customer_id
ORDER BY cs.total_sales ASC;


-- QUES 3. CUSTOMERS WHO MADE ONLY ONE ORDER

SELECT
    c.customer_name,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING COUNT(o.order_id) = 1;



-- QUES 4. Customers With Above-Average Sales

WITH customer_sales AS
(
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales >
(
    SELECT AVG(total_sales)
    FROM customer_sales
);

-- QUES 5. Highest Order Value Per Customer

SELECT
    customer_id,
    MAX(sales) AS highest_order_value
FROM orders
GROUP BY customer_id;

