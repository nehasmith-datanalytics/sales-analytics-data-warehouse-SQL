# sales-analytics-data-warehouse-SQL
# SQL Sales Performance Analysis

## Project Overview
This project demonstrates **advanced SQL analytics on a retail sales dataset** stored in a data warehouse.  
The goal of the project is to analyze **sales performance, customer behavior, and product contribution** using SQL queries.

The analysis is performed on a **fact table (fact_sales)** and **dimension tables (dim_products, dim_customers)** following a **star schema structure**.

This project highlights practical SQL techniques used in **real-world data analytics and business intelligence workflows**.

---

## Dataset Structure

The project uses the following tables:

### Fact Table
**gold.fact_sales**
- order_date
- sales_amount
- quantity
- price
- customer_key
- product_key

### Dimension Tables

**gold.dim_products**
- product_key
- product_name
- category
- cost

**gold.dim_customers**
- customer_key
- customer attributes

---
## Key Performance Indicator (KPI) Questions

This project answers the following business questions using SQL analytics.

### Sales Performance KPIs
- What is the **total sales revenue over time**?
- How do **sales trends change monthly and yearly**?
- What is the **total quantity of products sold** across different periods?

### Customer KPIs
- How many **unique customers** made purchases each year?
- Is the **number of customers increasing or decreasing over time**?
- Which **customer segments contribute the most revenue**?

### Product Performance KPIs
- Which **products generate the highest sales revenue**?
- Which products are **performing above or below their average historical sales**?
- Which products show **year-over-year sales growth or decline**?

### Category Contribution KPIs
- Which **product categories contribute the most to total sales**?
- What **percentage of total revenue** does each category represent?

### Sales Trend KPIs
- What is the **cumulative sales growth over time**?
- What is the **running total of sales by month and year**?

### Pricing KPIs
- What is the **average product price over time**?
- How does the **moving average price trend change across years**?

### Customer Segmentation KPIs
- How many customers belong to **VIP, Regular, and New segments**?
- What is the **total spending behavior of different customer segments**?

### Product Segmentation KPIs
- How many products fall into **different cost ranges**?
- Which **price segment contains the highest number of products**?

---

# SQL Techniques Used

This project demonstrates several **advanced SQL concepts**:

- Aggregations (`SUM`, `AVG`, `COUNT`)
- Window Functions
- `LAG()` for Year-over-Year analysis
- `DATETRUNC`
- `CASE` statements
- Common Table Expressions (**CTEs**)
- Joins between fact and dimension tables
- Data segmentation

---

# Key Business Insights

From this analysis we can identify:

- Sales growth trends over time
- Product performance compared to historical averages
- Year-over-Year product sales changes
- High revenue product categories
- Customer spending patterns
- VIP customer identification

These insights help businesses make decisions regarding:

- Marketing strategy
- Product portfolio optimization
- Customer retention programs
- Revenue forecasting

---

# Project Outcomes

By completing this project, we achieve:

- A structured **SQL analytics workflow**
- Business KPI tracking
- Advanced SQL analytics implementation
- Data-driven insights from a retail dataset

This project demonstrates skills useful for:

- **Data Analyst roles**
- **Business Intelligence roles**
- **SQL Developer positions**

---

# Tools Used

- SQL Server
- T-SQL
- Data Warehouse (Star Schema)
- GitHub

---
