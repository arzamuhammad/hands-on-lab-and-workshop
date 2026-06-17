# NusantaraMart — Zero to Data Hero (Hands-On Lab)

A beginner-friendly, 2-hour hands-on lab where students play three roles —
**Data Analyst → Data Engineer → BI Developer** — using a fictional Indonesian retail
company, **NusantaraMart**. No prior coding experience required.

Inspired by Snowflake's [Zero to Snowflake](https://www.snowflake.com/en/developers/guides/zero-to-snowflake/) quickstart.

---

## What you'll build

```
Sign up trial ─▶ Setup (warehouse/db) ─▶ Load retail data from S3
       │
       ▼
 [Act 1: ANALYST]   SELECT ▸ Aggregation ▸ JOIN ▸ INSERT/UPDATE/DELETE ▸ Mini-Challenge
       │
       ▼
 [Act 2: DATA ENGINEER]   COPY INTO ▸ transform/filter ▸ data marts ▸ automate with a Task
       │
       ▼
 [Act 3: BI DEVELOPER]    Deploy a Streamlit dashboard ─▶ "Wow, I built a dashboard!"
```

By the end you will have queried real data, built an **automated data pipeline**, and
deployed a **live dashboard** — entirely in the browser.

---

## Repository contents

| File | Purpose |
|------|---------|
| `hol.md` | Full lab guide / facilitator script (step-by-step, with talking points) |
| `generate_data.py` | Python script that generates the synthetic retail CSVs (stdlib only) |
| `data/` | Generated CSV files (see schema below) |
| `setup.sql` | **Module 0–1:** warehouse, database, schema, tables, S3 stage, `COPY INTO` |
| `lab_queries.sql` | **Module 2–7:** SELECT, aggregation, JOIN, DML, and the DE pipeline |
| `solutions.sql` | Answer key for the Module 6 mini-challenge (facilitator only) |
| `streamlit_app.py` | **Module 8:** Streamlit-in-Snowflake dashboard code |
| `seed_insert.sql` | **No-S3 fallback** — loads all data via `INSERT` instead of `COPY INTO` |

---

## The dataset (NusantaraMart)

A small retail star schema. All data is **synthetic** and generated locally.

| Table | Rows (default) | Description |
|-------|----------------|-------------|
| `customers` | ~500 | Shoppers: name, city, province, segment, signup date |
| `products` | 30 | Catalog: name, category, brand, unit price |
| `stores` | 15 | Stores: city, province, region, channel (Online/Offline) |
| `orders` | ~5,000 | Order headers: customer, store, date, status, payment |
| `order_items` | ~14,800 | Order line items: product, quantity, price, discount |

**Relationships**

```
customers 1───∞ orders ∞───1 stores
                   │
                   1
                   │
                   ∞
              order_items ∞───1 products
```

---

## Prerequisites

- A web browser (everything runs in **Snowsight**, Snowflake's web UI).
- A **Snowflake free trial** account — sign up at https://signup.snowflake.com
  (Enterprise edition, AWS, nearest region e.g. Jakarta/Singapore). Trial = ~$400 free credits / 30 days.
- *(Facilitator only)* An **Amazon S3 bucket** to host the CSVs, or use the no-S3 fallback.

> **Tip for students:** sign up and verify your email **the day before** the workshop so
> Module 0 goes quickly.

---

## Quick start

### Step 1 — (Facilitator) Generate the data

```bash
python3 generate_data.py
# optional knobs:
python3 generate_data.py --seed 42 --customers 500 --orders 5000
```

This writes 5 CSV files into `./data/`.

### Step 2 — Choose how to load the data

**Option A — From S3 (recommended, matches the "data engineer" story)**
1. Upload the 5 CSVs to your bucket: `s3://<YOUR-BUCKET>/data/`.
2. In `setup.sql`, replace `<BUCKET-LAB-RETAIL>` with your bucket path.
3. Run `setup.sql` top-to-bottom in a Snowsight Worksheet.

**Option B — No S3 (fallback)**
1. Run only the `CREATE WAREHOUSE/DATABASE/SCHEMA/TABLE` parts of `setup.sql` (Module 0 + 1.1).
2. Then run `seed_insert.sql` to load all rows via `INSERT`.

**Option C — Snowsight UI**
Use **Data ▸ Load Data** in Snowsight to drag-and-drop each CSV into its table (no SQL needed).

### Step 3 — Run the lab

1. Work through `lab_queries.sql` (Modules 2–7). Each block starts with a **business question**.
2. Try the Module 6 mini-challenge yourself; check `solutions.sql` after.
3. Build the pipeline (Module 7) — creates `ANALYTICS` data marts and a scheduled **Task**.

### Step 4 — Deploy the dashboard (Module 8)

1. Snowsight ▸ **Streamlit** ▸ **+ Streamlit App**.
2. Name `Retail Dashboard`, Database `RETAIL_DB`, Schema `ANALYTICS`, Warehouse `LAB_WH`.
3. Replace the sample code with `streamlit_app.py`, click **Run**. 🎉

---

## Lab modules at a glance

| Module | Skill | Example business question |
|--------|-------|---------------------------|
| 0. Setup | Trial, warehouse, database | — |
| 1. Data Prep | `COPY INTO` from S3 | "How do we get raw files into tables?" |
| 2. SELECT | filter, sort, limit | "Which products cost more than Rp50,000?" |
| 3. Aggregation | `COUNT/SUM/AVG/GROUP BY` | "How many customers per segment?" |
| 4. JOIN | combine tables | "Which product category sells the most?" |
| 5. DML | `INSERT/UPDATE/DELETE` | "A new customer signs up / upgrades / leaves" |
| 6. Mini-Challenge | everything above | 5 case-study questions |
| 7. Data Engineer | transform + Task | "Turn raw data into automated data marts" |
| 8. BI Developer | Streamlit | "Show the business its sales dashboard" |

---

## Naming conventions (used throughout)

| Object | Name |
|--------|------|
| Warehouse | `LAB_WH` (X-Small) |
| Database | `RETAIL_DB` |
| Schemas | `RAW` (raw data), `ANALYTICS` (data marts) |
| Company | NusantaraMart (fictional) |

---

## Cleanup (optional — save credits)

```sql
ALTER TASK RETAIL_DB.ANALYTICS.task_refresh_marts SUSPEND;
ALTER WAREHOUSE LAB_WH SUSPEND;
-- DROP DATABASE RETAIL_DB;   -- remove everything
```

---

## Notes

- The **teaching slides** (2-hour theory session) are intentionally **vendor-neutral**
  (general data-platform concepts). This hands-on lab uses Snowflake as the practice platform.
- All SQL has been validated against Snowflake. Revenue is computed as
  `quantity * unit_price * (1 - discount_pct)` and only `status = 'Completed'` orders count.

Happy querying — and welcome to the world of data! 🚀
