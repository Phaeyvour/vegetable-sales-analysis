# 🥦 Vegetable Sales Analysis Dashboard

This project analyzes supermarket vegetable sales data using **SQL** and visualizes key insights in **Power BI**.

## 📊 Project Overview

This analysis answers business questions like:
- What are the top-selling vegetables?
- Which items are most profitable?
- Are returns and losses affecting performance?
- Do discounts help or hurt sales?
- How are we performing over time?

## 🧩 Dataset Info

- Data Source: https://www.kaggle.com
- Tables Used:
  - `Vegetables list`: Item details (names, categories)
  - `Sales transaction data`: Sales transactions
  - `Cost data`: Wholesale pricing
  - `Loss data`: Loss/discount details

## 🛠️ Tools Used

- **SQL Server Management Studio (SSMS)** – for cleaning, joining, and analyzing raw data
- **Power BI** – for building an interactive dashboard with visuals

## 📌 Key SQL Queries

```sql
-- Total sales per item
SELECT TOP 10
    A1.Item_Name,
    SUM(A2.quantity_sold_kilo * A2.Unit_Selling_Price_RMB_kg) AS total_sales
FROM annex2 A2
JOIN annex1 AS A1 ON A2.Item_Code = A1.Item_Code
GROUP BY a1.item_name
ORDER BY total_sales DESC;

Dashboard Features
Total Sales & Profit Cards

Top & Least Selling Items

Category-Level Profit Analysis

Return Rates

Discount Effectiveness

Loss Analysis

Monthly Performance Trends

Interactive Filters (Slicers)

📁 Project Files
vegetable_sales.sql – All SQL queries used for analysis

Vegetable_Dataset – Raw dataset files 

vegetable_dashboard.pbix – Power BI dashboard file

README.md – Project documentation

✅ Getting Started
Open vegetable_sales.sql in SSMS to explore raw data and queries.

Open vegetable_dashboard.pbix in Power BI Desktop to view or edit the dashboard.

🤝 Contact
Built by @Phaeyvour
Feel free to connect or contribute!
