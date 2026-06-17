"""
NusantaraMart Retail Dashboard  |  streamlit_app.py
Streamlit-in-Snowflake (SiS) app for MODULE 8 of the hands-on lab.

HOW TO USE:
  1. In Snowsight, go to:  Streamlit  ->  + Streamlit App
  2. Name it "Retail Dashboard", choose Database RETAIL_DB, Schema ANALYTICS,
     Warehouse LAB_WH.
  3. Delete the sample code, paste THIS file, click Run.

It reads from the data marts built in lab_queries.sql (Module 7):
  ANALYTICS.mart_daily_sales, mart_category_sales, mart_region_sales
"""
import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

st.set_page_config(page_title="NusantaraMart Dashboard", layout="wide")
session = get_active_session()

st.title("🛒 NusantaraMart — Retail Sales Dashboard")
st.caption("Built by the Data Analytics team • powered by data marts in RETAIL_DB.ANALYTICS")


@st.cache_data(ttl=600)
def run(sql: str) -> pd.DataFrame:
    return session.sql(sql).to_pandas()


# ---------------------------------------------------------------- KPIs
daily = run("SELECT * FROM RETAIL_DB.ANALYTICS.mart_daily_sales ORDER BY order_date")
total_revenue = float(daily["REVENUE"].sum())
total_orders = int(daily["NUM_ORDERS"].sum())
aov = total_revenue / total_orders if total_orders else 0

c1, c2, c3 = st.columns(3)
c1.metric("Total Revenue", f"Rp {total_revenue:,.0f}")
c2.metric("Total Orders", f"{total_orders:,}")
c3.metric("Avg Order Value", f"Rp {aov:,.0f}")

st.divider()

# ------------------------------------------------------- Daily revenue
st.subheader("📈 Daily Revenue")
daily_idx = daily.copy()
daily_idx["ORDER_DATE"] = pd.to_datetime(daily_idx["ORDER_DATE"])
st.line_chart(daily_idx, x="ORDER_DATE", y="REVENUE")

# -------------------------------------------------- Category & Region
left, right = st.columns(2)

with left:
    st.subheader("🏷️ Revenue by Category")
    cat = run("""
        SELECT category, revenue
        FROM RETAIL_DB.ANALYTICS.mart_category_sales
        ORDER BY revenue DESC
    """)
    st.bar_chart(cat, x="CATEGORY", y="REVENUE")

with right:
    st.subheader("📍 Revenue by Region")
    region = run("""
        SELECT region, SUM(revenue) AS revenue
        FROM RETAIL_DB.ANALYTICS.mart_region_sales
        GROUP BY region
        ORDER BY revenue DESC
    """)
    st.bar_chart(region, x="REGION", y="REVENUE")

# ------------------------------------------------------ Detail tables
with st.expander("🔎 See detail tables"):
    st.write("**Top cities by revenue**")
    st.dataframe(
        run("""
            SELECT region, city, revenue
            FROM RETAIL_DB.ANALYTICS.mart_region_sales
            ORDER BY revenue DESC
            LIMIT 10
        """),
        use_container_width=True,
    )

st.success("🎉 You just built a real data dashboard — congratulations!")
