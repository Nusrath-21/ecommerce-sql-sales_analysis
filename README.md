This project analyzes an e-commerce sales dataset using PostgreSQL to derive key business insights around revenue, customer behavior, and payment trends. The dataset simulates a retail business with customers, products, orders, and order line items, and was built and queried entirely in PostgreSQL/pgAdmin.
Tools Used
PostgreSQL
pgAdmin (Query Tool)
Database Schema
The database consists of 4 relational tables:
customers — customer_id, customer_name, gender, city, signup_date
products — product_id, product_name, category, price
orders — order_id, customer_id, order_date, order_status, payment_method
order_items — order_item_id, order_id, product_id, quantity, unit_price
Dataset size: 30 customers, 15 products, 100 orders, 201 order items.
SQL Concepts Used
SELECT, WHERE, GROUP BY, ORDER BY, JOINs (multi-table), Aggregate Functions, FILTER clause, DATE_TRUNC, ALTER TABLE, ROUND, LIMIT.
Key Findings
1. Revenue by Payment Method
2. Cash on Delivery Share: 28%
3. Delivered Orders: 81 out of 100
4. Average Order Value (AOV): ₹16,287.65
5. Top 5 Customers by RevenueMonthly Revenue Trend

## Extended Analysis (Product, Customer & Operations)

Beyond the initial revenue and payment analysis, this project also covers:

- **Best-selling products & category mix** — Electronics accounts for 57% of total revenue, driven heavily by a single product (Laptop)
- **Order cancellation rate** — 19% of all orders are cancelled, flagged as an operational concern
- **City-wise revenue** — Delhi leads in total revenue, but Kolkata shows higher revenue-per-customer
- **Customer loyalty** — 79% of customers are repeat buyers, indicating strong retention

## Python Analysis & Visualization

In addition to the SQL queries above, this project includes a Python layer (Pandas + Matplotlib) for deeper analysis and dashboard-style visualizations:
- `analysis.py` — summary dashboard (revenue, payment methods, top customers)
- `analysis_extended.py` — deep-dive dashboard (products, categories, cities, loyalty)
- `Ecommerce_Orders_Analysis.ipynb` — full Kaggle notebook combining SQL + Python + narrative insights

**📊 Live notebook on Kaggle:** [https://www.kaggle.com/code/nusrathbegum/e-commerce-sales-analysis]

**Files included:**
| File | Description |
|---|---|
| `project.sql` | All SQL queries used in the analysis |
| `analysis.py` / `analysis_extended.py` | Python scripts for charts |
| `Ecommerce_Orders_Analysis.ipynb` | Full Kaggle-ready notebook |
| `*.csv` | Raw data tables (customers, orders, order_items, products) |
| `ecommerce_dashboard*.png` | Static dashboard exports |
