USE Sales_data

--TO CHECK FOR NULL VALUES IN THE DATASET
SELECT COUNT(*) - COUNT(Unit_Selling_Price_RMB_kg) AS missing_count FROM annex2;
SELECT
  COUNT(*) - COUNT(Quantity_Sold_kilo) AS missing_quantity_sold,
  COUNT(*) - COUNT(Unit_Selling_Price_RMB_kg) AS missing_unit_price,
  COUNT(*) - COUNT(Item_Code) AS missing_item_code
FROM annex2;
-- TO CHECK FOR DISTINT VALUES IN THE DATASET
SELECT DISTINCT Item_Code FROM annex2
EXCEPT
SELECT item_code FROM annex1;

--JOINING THE TABLES TO GET INSIGHTS
SELECT Top 10 * FROM annex1 as A1
JOIN annex2 AS A2
ON A1.Item_Code = A2.Item_Code
JOIN annex3 AS A3 
ON A2.Item_Code = A3.Item_Code
JOIN annex4 AS A4 
ON A3.Item_Code = A4.Item_Code

--TOP 10 SELLING ITEM
SELECT TOP 10
    A1.Item_Name,
    SUM(A2.quantity_sold_kilo * A2.Unit_Selling_Price_RMB_kg) AS total_sales
FROM annex2 A2
JOIN annex1 AS A1 ON A2.Item_Code = A1.Item_Code
GROUP BY a1.item_name
ORDER BY total_sales DESC;

--LAST 10 SELLING ITEMS
SELECT TOP 10
    A1.Item_Name,
    SUM(A2.quantity_sold_kilo * A2.Unit_Selling_Price_RMB_kg) AS total_sales
FROM annex2 A2
JOIN annex1 AS A1 ON A2.Item_Code = A1.Item_Code
GROUP BY a1.item_name
ORDER BY total_sales ASC;

--Most Profitable Categories
SELECT
    A1.category_name,
    SUM(A2.quantity_sold_kilo * (A2.Unit_Selling_Price_RMB_kg - A3.Wholesale_Price_RMB_kg)) AS total_profit
FROM annex2 A2
JOIN annex1 A1 ON A2.Item_Code = A1.item_code
JOIN annex3 A3 ON A2.Item_Code = A3.item_code AND a2.date = A3.date
GROUP BY A1.category_name
ORDER BY total_profit DESC;

--Return Rate, Which items are often returned?
SELECT
    a1.item_name,
    COUNT(CASE WHEN a2.sale_or_return = 'Return' THEN 1 END) * 1.0 / COUNT(*) AS return_rate,
    COUNT(*) AS total_transactions,
    COUNT(CASE WHEN a2.sale_or_return = 'Return' THEN 1 END) AS total_returns
FROM annex2 a2
JOIN annex1 a1 ON a2.Item_Code = a1.item_code
GROUP BY a1.item_name
ORDER BY return_rate DESC;

--Are We Improving Over Time? Here, you look at how your sales and profit change month by month.
SELECT
    FORMAT(a2.date, 'yyyy-MM') AS sales_month,
    SUM(a2.quantity_sold_kilo) AS total_quantity_sold,
    SUM(a2.quantity_sold_kilo * a2.Unit_Selling_Price_RMB_kg) AS total_sales,
    SUM(a2.quantity_sold_kilo * (a2.Unit_Selling_Price_RMB_kg - a3.Wholesale_Price_RMB_kg)) AS total_profit,
    COUNT(*) AS total_transactions
FROM annex2 a2
JOIN annex3 a3 ON a2.Item_Code = a3.item_code AND a2.date = a3.date
GROUP BY FORMAT(a2.date, 'yyyy-MM')
ORDER BY sales_month;

--Loss & Discount Analysis – Where Are We Losing Money? 1: Loss Types: What types of losses do we see the most?”
SELECT
    a1.category_name,
    a4.Loss_Rate,
    COUNT(*) AS number_of_occurrences
FROM annex4 a4
JOIN annex1 a1 ON a4.item_code = a1.item_code
GROUP BY a1.category_name, a4.Loss_Rate
ORDER BY number_of_occurrences DESC;

--Discount Effectiveness: Do discounts help us sell more or earn less profit?
SELECT
    a2.Discount_Yes_No,
    COUNT(*) AS total_transactions,
    SUM(a2.quantity_sold_kilo) AS total_quantity_sold,
    SUM(a2.quantity_sold_kilo * a2.Unit_Selling_Price_RMB_kg) AS total_sales,
    SUM(a2.quantity_sold_kilo * (a2.Unit_Selling_Price_RMB_kg - a3.Wholesale_Price_RMB_kg)) AS total_profit
FROM annex2 a2
JOIN annex3 a3 ON a2.Item_Code = a3.item_code AND a2.date = a3.date
GROUP BY a2.Discount_Yes_No;
--Segmentation & Ranking – “What Should We Focus On? Use ranking to create a leaderboard of items or categories.
SELECT
    a1.item_name,
    SUM(a2.quantity_sold_kilo) AS total_quantity_sold,
    SUM(a2.quantity_sold_kilo * a2.Unit_Selling_Price_RMB_kg) AS total_sales,
    SUM(a2.quantity_sold_kilo * (a2.Unit_Selling_Price_RMB_kg - a3.Wholesale_Price_RMB_kg)) AS total_profit,
    RANK() OVER (ORDER BY SUM(a2.quantity_sold_kilo * (a2.unit_selling_price_RMB_kg - a3.Wholesale_price_RMB_kg)) DESC) AS profit_rank
FROM annex2 a2
JOIN annex1 a1 ON a2.Item_Code = a1.item_code
JOIN annex3 a3 ON a2.Item_Code = a3.item_code AND a2.date = a3.date
GROUP BY a1.item_name
ORDER BY profit_rank;