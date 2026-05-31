USE EcommerceDB;
GO


-- Ques 1
SELECT * FROM customers;

-- Ques 2
SELECT first_name, last_name, city
FROM customers;

-- Ques 3
SELECT DISTINCT category
FROM products;


-- Ques 6
/*INSERT INTO products
VALUES (209,'Test Product','Electronics',
'TestBrand',-50,100);
*/

-- Ques 7
SELECT *
FROM orders
WHERE status='Delivered';

-- Ques 8
SELECT *
FROM products
WHERE category='Electronics'
AND unit_price > 2000;


-- Ques 9
SELECT *
FROM customers
WHERE state='Maharashtra'
AND join_date BETWEEN '2024-01-01'
AND '2024-12-31';


-- Ques 10
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10'
AND '2024-08-25'
AND status <> 'Cancelled';


-- Ques 11
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-01'
AND '2024-08-31';


-- 12
SELECT *
FROM customers
WHERE YEAR(join_date)=2024;

-- 13
SELECT COUNT(*) AS total_orders
FROM orders;


--14
SELECT SUM(total_amount) AS revenue
FROM orders
WHERE status='Delivered';


-- 15
SELECT category,
AVG(unit_price) AS avg_price
FROM products
GROUP BY category;

-- 16
SELECT status,
COUNT(*) AS order_count,
SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;


-- 17
SELECT category,
MAX(unit_price) AS highest_price,
MIN(unit_price) AS lowest_price
FROM products
GROUP BY category;

--18
SELECT category,
AVG(unit_price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;

--19
SELECT o.order_id,
       o.order_date,
       c.first_name,
       c.last_name,
       o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;


-- 20
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       o.order_id,
       o.order_date
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;


--21
SELECT o.order_id,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount_pct
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
JOIN products p
ON oi.product_id = p.product_id;


--22
SELECT *
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id;

SELECT *
FROM customers c
RIGHT JOIN orders o
ON c.customer_id=o.customer_id;


--24
SELECT product_name,
       unit_price,
       CASE
         WHEN unit_price < 1000
              THEN 'Budget'
         WHEN unit_price BETWEEN 1000 AND 3000
              THEN 'Mid-Range'
         ELSE 'Premium'
       END AS price_tier
FROM products;


--25
SELECT
SUM(CASE
      WHEN status='Delivered'
      THEN 1 ELSE 0
    END) AS delivered_orders,

SUM(CASE
      WHEN status<>'Delivered'
      THEN 1 ELSE 0
    END) AS not_delivered_orders
FROM orders;



--27
BEGIN TRY
    BEGIN TRANSACTION;

    -- 1. Insert New Order
    INSERT INTO orders
    (order_id, customer_id, order_date, status, total_amount)
    VALUES
    (1011, 102, GETDATE(), 'Pending', 1598.00);

    -- 2. Insert First Order Item
    INSERT INTO order_items
    (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES
    (5016, 1011, 202, 1, 799.00, 0);

    -- 3. Insert Second Order Item
    INSERT INTO order_items
    (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES
    (5017, 1011, 208, 1, 799.00, 0);

    -- 4. Update Product Stock
    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 202;

    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 208;

    -- Commit if all statements succeed
    COMMIT TRANSACTION;

    PRINT 'Transaction Completed Successfully';

END TRY
BEGIN CATCH

    -- Rollback if any statement fails
    ROLLBACK TRANSACTION;

    PRINT 'Transaction Failed - All Changes Rolled Back';

END CATCH;