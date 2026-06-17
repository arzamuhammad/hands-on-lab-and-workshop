-- =====================================================================
--  NusantaraMart Hands-On Lab  |  setup.sql
--  Modules 0-1: warehouse, database, schema, tables, S3 stage, COPY INTO
--  Run this top-to-bottom in a Snowsight Worksheet AFTER signing up.
-- =====================================================================

-- ---------------------------------------------------------------------
-- MODULE 0 - Setup: compute (warehouse) + storage (database/schema)
-- ---------------------------------------------------------------------

-- "Engine" that runs queries. X-Small = smallest & cheapest.
CREATE OR REPLACE WAREHOUSE LAB_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND   = 60       -- auto-pause after 60s idle (saves credits)
  AUTO_RESUME    = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- "Building" that stores data
CREATE OR REPLACE DATABASE RETAIL_DB;

-- "Rooms": RAW = raw data, ANALYTICS = processed data / data marts
CREATE OR REPLACE SCHEMA RETAIL_DB.RAW;
CREATE OR REPLACE SCHEMA RETAIL_DB.ANALYTICS;

-- Set working context for the rest of the lab
USE WAREHOUSE LAB_WH;
USE DATABASE  RETAIL_DB;
USE SCHEMA    RAW;

-- ---------------------------------------------------------------------
-- MODULE 1 - Data Preparation: load retail data from Amazon S3
-- ---------------------------------------------------------------------

-- 1.1  Create empty tables (the structure / schema)
CREATE OR REPLACE TABLE customers (
  customer_id INT,
  full_name   STRING,
  email       STRING,
  city        STRING,
  province    STRING,
  segment     STRING,
  signup_date DATE
);

CREATE OR REPLACE TABLE products (
  product_id   INT,
  product_name STRING,
  category     STRING,
  brand        STRING,
  unit_price   NUMBER(10,2)
);

CREATE OR REPLACE TABLE stores (
  store_id   INT,
  store_name STRING,
  city       STRING,
  province   STRING,
  region     STRING,
  channel    STRING
);

CREATE OR REPLACE TABLE orders (
  order_id       INT,
  customer_id    INT,
  store_id       INT,
  order_date     DATE,
  status         STRING,
  payment_method STRING
);

CREATE OR REPLACE TABLE order_items (
  order_item_id INT,
  order_id      INT,
  product_id    INT,
  quantity      INT,
  unit_price    NUMBER(10,2),
  discount_pct  NUMBER(4,2)
);

-- 1.2  File format + S3 stage
CREATE OR REPLACE FILE FORMAT csv_ff
  TYPE = CSV
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1;

-- >>> INSTRUCTOR: replace <BUCKET-LAB-RETAIL> with your real S3 bucket/path.
--     The 5 CSV files (customers, products, stores, orders, order_items)
--     must be uploaded to: s3://<BUCKET-LAB-RETAIL>/data/
CREATE OR REPLACE STAGE retail_s3_stage
  URL = 's3://<BUCKET-LAB-RETAIL>/data/'
  FILE_FORMAT = csv_ff;

-- See files available in the stage
LIST @retail_s3_stage;

-- 1.3  COPY INTO (load files -> tables)
COPY INTO customers   FROM @retail_s3_stage/customers.csv;
COPY INTO products    FROM @retail_s3_stage/products.csv;
COPY INTO stores      FROM @retail_s3_stage/stores.csv;
COPY INTO orders      FROM @retail_s3_stage/orders.csv;
COPY INTO order_items FROM @retail_s3_stage/order_items.csv;

-- 1.4  Sanity check - row counts
SELECT 'customers'   AS table_name, COUNT(*) AS rows FROM customers
UNION ALL SELECT 'products',    COUNT(*) FROM products
UNION ALL SELECT 'stores',      COUNT(*) FROM stores
UNION ALL SELECT 'orders',      COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

-- Expected (with default generator settings):
--   customers ~500 | products 30 | stores 15 | orders 5000 | order_items ~14800
