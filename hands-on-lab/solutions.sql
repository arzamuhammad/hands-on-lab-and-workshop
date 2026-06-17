-- =====================================================================
--  NusantaraMart Hands-On Lab  |  solutions.sql
--  Answer key for MODULE 6 - Mini-Challenge (instructor copy)
-- =====================================================================

USE WAREHOUSE LAB_WH;
USE DATABASE  RETAIL_DB;
USE SCHEMA    RAW;

-- ---------------------------------------------------------------------
-- 1. Total revenue across all stores (status = 'Completed')
-- ---------------------------------------------------------------------
SELECT ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed';

-- ---------------------------------------------------------------------
-- 2. Top 5 customers by total spend
-- ---------------------------------------------------------------------
SELECT c.customer_id, c.full_name,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))) AS total_spend
FROM customers c
JOIN orders o       ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.full_name
ORDER BY total_spend DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- 3. Products that have NEVER been sold (LEFT JOIN + IS NULL)
-- ---------------------------------------------------------------------
SELECT p.product_id, p.product_name, p.category
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- ---------------------------------------------------------------------
-- 4. Month with the highest revenue in 2025
-- ---------------------------------------------------------------------
SELECT MONTH(o.order_date) AS month_num,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed' AND YEAR(o.order_date) = 2025
GROUP BY MONTH(o.order_date)
ORDER BY revenue DESC
LIMIT 1;

-- ---------------------------------------------------------------------
-- 5. Average Order Value (AOV) per store channel (Online vs Offline)
-- ---------------------------------------------------------------------
WITH order_totals AS (
  SELECT o.order_id, s.channel,
         SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS order_value
  FROM orders o
  JOIN stores s       ON o.store_id = s.store_id
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE o.status = 'Completed'
  GROUP BY o.order_id, s.channel
)
SELECT channel,
       COUNT(*)            AS num_orders,
       ROUND(AVG(order_value)) AS avg_order_value
FROM order_totals
GROUP BY channel
ORDER BY avg_order_value DESC;
