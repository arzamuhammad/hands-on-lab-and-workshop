-- =====================================================================
--  NusantaraMart Hands-On Lab  |  lab_queries.sql
--  Modules 2-7: SELECT, Aggregation, JOIN, DML, Data Engineering pipeline
--  Each example starts with a BUSINESS QUESTION, answered by a query.
--  Run AFTER setup.sql has loaded the data.
-- =====================================================================

USE WAREHOUSE LAB_WH;
USE DATABASE  RETAIL_DB;
USE SCHEMA    RAW;

-- =====================================================================
-- MODULE 2 - SELECT (pick & filter data)
-- =====================================================================

-- Q1: Who are our customers?
SELECT customer_id, full_name, city, segment
FROM customers
LIMIT 10;

-- Q2: Which products cost more than Rp50,000?
SELECT product_name, category, unit_price
FROM products
WHERE unit_price > 50000
ORDER BY unit_price DESC;

-- Q3: Which VIP customers are based in Jakarta?
SELECT full_name, email, segment
FROM customers
WHERE segment = 'VIP' AND city = 'Jakarta';

-- Q4: What are the 5 most recent orders?
SELECT order_id, customer_id, order_date, status
FROM orders
ORDER BY order_date DESC
LIMIT 5;

-- =====================================================================
-- MODULE 3 - Aggregation (summarize many rows)
-- =====================================================================

-- Q1: How many customers do we have in total?
SELECT COUNT(*) AS total_customers FROM customers;

-- Q2: How many customers per segment?
SELECT segment, COUNT(*) AS num_customers
FROM customers
GROUP BY segment
ORDER BY num_customers DESC;

-- Q3: What is the average price per product category?
SELECT category,
       COUNT(*)               AS num_products,
       ROUND(AVG(unit_price)) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- Q4: How many orders per status?
SELECT status, COUNT(*) AS num_orders
FROM orders
GROUP BY status
ORDER BY num_orders DESC;

-- =====================================================================
-- MODULE 4 - JOIN (combine related tables)
-- =====================================================================

-- Q1: What is the customer name for each order? (orders + customers)
SELECT o.order_id, o.order_date, c.full_name, c.city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 10;

-- Q2: What is the total value of each order? (orders + order_items)
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id
ORDER BY order_value DESC
LIMIT 10;

-- Q3: Which product category sells the most units? (order_items + products)
SELECT p.category, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY units_sold DESC;

-- Q4 (3 tables): Revenue per store city? (orders + stores + order_items)
SELECT s.city,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))) AS revenue
FROM orders o
JOIN stores s       ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.city
ORDER BY revenue DESC;

-- =====================================================================
-- MODULE 5 - INSERT / UPDATE / DELETE (modify data)
-- =====================================================================

-- Scenario 1 (INSERT): a new customer signs up
INSERT INTO customers (customer_id, full_name, email, city, province, segment, signup_date)
VALUES (9999, 'Siti Aminah', 'siti@email.com', 'Bandung', 'Jawa Barat', 'Member', CURRENT_DATE());

SELECT * FROM customers WHERE customer_id = 9999;

-- Scenario 2 (UPDATE): Siti is upgraded to VIP
UPDATE customers SET segment = 'VIP' WHERE customer_id = 9999;

SELECT customer_id, full_name, segment FROM customers WHERE customer_id = 9999;

-- Scenario 3 (DELETE): customer asks to delete the account
DELETE FROM customers WHERE customer_id = 9999;

SELECT COUNT(*) AS remaining FROM customers WHERE customer_id = 9999;  -- expect 0

-- !! WARNING: UPDATE / DELETE without WHERE changes/removes ALL rows. Always check WHERE!

-- =====================================================================
-- MODULE 7 - DATA ENGINEER: build a pipeline (RAW -> ANALYTICS)
--   RAW data -> transform/filter -> data marts, automated as a Task graph (DAG)
--   where each step is its OWN task connected by dependencies (AFTER).
-- =====================================================================
USE SCHEMA RETAIL_DB.ANALYTICS;

-- 7.1  THE PIPELINE (concept)
--   A real data engineer does NOT cram everything into one big script.
--   The work is split into small steps. Each step is its own TASK, and the
--   tasks run in order using dependencies (AFTER). This is a Task Graph (DAG):
--
--      task_build_sales_clean        (root - runs on a schedule)
--             |
--             +--> task_mart_daily_sales       (runs AFTER root)
--             +--> task_mart_category_sales    (runs AFTER root)
--             +--> task_mart_region_sales      (runs AFTER root)
--
--   One SQL statement per task. Clean, easy to debug, easy to extend.

-- 7.2  ROOT TASK: transform & filter -> sales_clean. Runs daily at 01:00.
CREATE OR REPLACE TASK task_build_sales_clean
  WAREHOUSE = LAB_WH
  SCHEDULE  = 'USING CRON 0 1 * * * Asia/Jakarta'
AS
  CREATE OR REPLACE TABLE sales_clean AS
  SELECT o.order_id, o.order_date, o.store_id, o.customer_id,
         oi.product_id, oi.quantity,
         oi.quantity * oi.unit_price * (1 - oi.discount_pct) AS net_amount
  FROM RETAIL_DB.RAW.orders o
  JOIN RETAIL_DB.RAW.order_items oi ON o.order_id = oi.order_id
  WHERE o.status = 'Completed';

-- 7.3  CHILD TASKS: each builds ONE data mart, AFTER the root finishes.
--   These three run in parallel once sales_clean is ready.
CREATE OR REPLACE TASK task_mart_daily_sales
  WAREHOUSE = LAB_WH
  AFTER task_build_sales_clean
AS
  CREATE OR REPLACE TABLE mart_daily_sales AS
  SELECT order_date, COUNT(DISTINCT order_id) AS num_orders, SUM(net_amount) AS revenue
  FROM sales_clean
  GROUP BY order_date;

CREATE OR REPLACE TASK task_mart_category_sales
  WAREHOUSE = LAB_WH
  AFTER task_build_sales_clean
AS
  CREATE OR REPLACE TABLE mart_category_sales AS
  SELECT p.category, SUM(s.quantity) AS units_sold, SUM(s.net_amount) AS revenue
  FROM sales_clean s
  JOIN RETAIL_DB.RAW.products p ON s.product_id = p.product_id
  GROUP BY p.category;

CREATE OR REPLACE TASK task_mart_region_sales
  WAREHOUSE = LAB_WH
  AFTER task_build_sales_clean
AS
  CREATE OR REPLACE TABLE mart_region_sales AS
  SELECT st.region, st.city, SUM(s.net_amount) AS revenue
  FROM sales_clean s
  JOIN RETAIL_DB.RAW.stores st ON s.store_id = st.store_id
  GROUP BY st.region, st.city;

-- 7.4  ACTIVATE the pipeline.
--   IMPORTANT: resume the CHILD tasks first, then the ROOT task last.
ALTER TASK task_mart_daily_sales    RESUME;
ALTER TASK task_mart_category_sales RESUME;
ALTER TASK task_mart_region_sales   RESUME;
ALTER TASK task_build_sales_clean   RESUME;

-- 7.5  Run the whole pipeline now (the root automatically triggers the children).
EXECUTE TASK task_build_sales_clean;

-- Watch the pipeline run (root + 3 children). Re-run this after a few seconds.
SELECT name, state, scheduled_time, query_start_time, error_code
FROM TABLE(INFORMATION_SCHEMA.TASK_HISTORY())
ORDER BY scheduled_time DESC
LIMIT 10;

-- Once every task shows SUCCEEDED, verify the marts:
SELECT * FROM mart_daily_sales     ORDER BY order_date LIMIT 10;
SELECT * FROM mart_category_sales  ORDER BY revenue DESC;
SELECT * FROM mart_region_sales    ORDER BY revenue DESC;
