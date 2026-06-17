# Hands-On Lab & Workshop — Intro to Data Platforms

A complete 4-hour learning package for **beginners (no coding background)**, built for a guest
lecture at **Politeknik Gajah Tunggal**. It takes students from "what is data?" to building a
real, automated data pipeline and a live dashboard.

## Structure

```
hands-on-lab-and-workshop/
└── hands-on-lab/               # 2-hour hands-on lab (uses Snowflake free trial)
    ├── README.md                # detailed lab guide (start here)
    ├── hol.md                   # full facilitator script
    ├── generate_data.py         # generates the synthetic retail dataset
    ├── data/                    # the generated CSV files
    ├── setup.sql                # warehouse/db/schema/tables + S3 load
    ├── lab_queries.sql          # SELECT, aggregation, JOIN, DML, pipeline
    ├── solutions.sql            # mini-challenge answer key
    ├── streamlit_app.py         # the dashboard app
    └── seed_insert.sql          # no-S3 fallback loader
```

## The hands-on lab

| Session | Duration | Focus |
|---------|----------|-------|
| **Hands-on lab** (`hands-on-lab/`) | 2 hours | Sign up → load data → SQL → build a pipeline → deploy a dashboard |

> The 2-hour theory session (slides + speaker notes) is maintained separately and is not part of this repository.

## Quick start

- **Instructors:** read `hands-on-lab/README.md`, generate data with `python3 generate_data.py`,
  and rehearse `setup.sql` + `lab_queries.sql` on a Snowflake trial.
- **Students:** sign up for a Snowflake free trial and follow `hands-on-lab/README.md`.

## Story

Students role-play three jobs using a fictional Indonesian retailer, **NusantaraMart**:
**Data Analyst → Data Engineer → BI Developer**.

---
*Educational material. The hands-on lab uses Snowflake as the practice platform.*
