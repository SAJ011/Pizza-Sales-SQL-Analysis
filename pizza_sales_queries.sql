/* ============================================================
   PIZZA SALES ANALYSIS — SQL Query Report
   Dataset: pizza_sales_excel_file (transactional pizza order records)
   Key fields: order_id, order_date, quantity, total_price
   ============================================================ */


-- QUERY 01: Total Revenue
-- Headline P&L metric; also a data-quality sanity check.
SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales_excel_file;


-- QUERY 02: Average Order Value (AOV)
-- Revenue efficiency metric — distinguishes growth from volume vs. spend per order.
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Average_Order_Value
FROM pizza_sales_excel_file;


-- QUERY 03: Total Pizzas Sold
-- Volume metric that complements revenue; feeds supply chain / staffing planning.
SELECT SUM(quantity) AS Total_Pizza_Sold
FROM pizza_sales_excel_file;


-- QUERY 04: Total Orders
-- COUNT(DISTINCT order_id) avoids double-counting multi-item orders.
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales_excel_file;


-- QUERY 05: Average Pizzas Per Order (integer division — quick estimate)
SELECT SUM(quantity) / COUNT(DISTINCT order_id) AS Average_Pizza_Per_Order
FROM pizza_sales_excel_file;


-- QUERY 06: Pizzas Per Order — Precise
-- Explicit DECIMAL casting avoids the silent integer-truncation seen in Query 05.
SELECT CAST(
         CAST(SUM(quantity) AS DECIMAL(10,2))
         / CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2))
       AS DECIMAL(10,2)) AS Pizza_Per_Order
FROM pizza_sales_excel_file;


-- QUERY 07: Total Orders by Day of Week
-- DATENAME(DW, ...) surfaces demand patterns (e.g. Friday/weekend peaks) for staffing/promo decisions.
SELECT
    DATENAME(DW, order_date) AS Order_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales_excel_file
GROUP BY DATENAME(DW, order_date);


-- QUERY 08: Total Orders by Month
-- DATENAME(MONTH, ...) reveals seasonality for revenue forecasting and inventory planning.
SELECT
    DATENAME(MONTH, order_date) AS Order_Month,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales_excel_file
GROUP BY DATENAME(MONTH, order_date);


/* ============================================================
   SUMMARY
   - AOV and pizzas-per-order together reveal whether revenue growth
     is driven by order volume or by higher spend per customer.
   - Query 06 vs. Query 05 demonstrates a core SQL discipline: always
     validate data types before division to avoid silent truncation
     errors reaching a production report.
   - Day-of-week and monthly views turn a static revenue figure into
     an actionable staffing, promotion and inventory-planning tool.
   ============================================================ */
