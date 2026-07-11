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
