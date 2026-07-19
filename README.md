# Superstore Retail Analytics Data Warehouse

## 📋 Project Overview
This project involved building a robust retail analytics platform for the Kaggle Superstore dataset (2014–2018). We implemented a full end-to-end data pipeline, including dimensional modeling (Star Schema), ETL (Extract, Transform, Load) processes, and advanced OLAP analysis to derive actionable business insights.

## 🛠️ Technical Stack
* **Database:** PostgreSQL
* **Pipeline:** Python (pandas, SQLAlchemy, psycopg2)
* **Analysis:** SQL (Window Functions, ROLLUP, CUBE, DENSE_RANK)
* **Visualization:** Jupyter Notebooks / pgAdmin

## 🏗️ Data Warehouse Architecture
We designed a Star Schema to optimize query performance and provide a simplified view of complex retail transactions.
* **Fact Table:** `fact_sales` (captures line-item sales, quantity, discount, and profit).
* **Dimension Tables:** `dim_time`, `dim_customer`, `dim_product`, `dim_order`, and `dim_shipping`.

## 📊 Key Analytical Capabilities
The platform supports complex business intelligence, including:
* **Period-over-Period Comparison:** Tracking monthly sales growth.
* **Year-to-Date Performance:** Monitoring cumulative sales against annual goals.
* **Profitability Analysis:** Identifying top-performing products by region and category.
* **Multi-Dimensional Filtering:** Drilling down into specific segments, regions, and categories to isolate performance issues.

## 🚀 Key Data Quality Transformations
To ensure data integrity, our ETL pipeline performed:
1. **Deduplication:** Removing redundant transaction records.
2. **Imputation:** Handling missing location data (e.g., missing Postal Codes).
3. **Data Standardization:** Formatting inconsistent source date strings into a standardized time dimension.

## 👥 Team
- **Sithumi Samadhi** 
- **Pramudi Dulasha** 

---
*Developed for the Data Mining and Warehousing course module at the University of Kelaniya.*
