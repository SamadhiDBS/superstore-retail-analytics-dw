--2.2 OLAP Query Suite

--Q1: ROLLUP with GROUPING()
--Business Question: "What are the total sales figures broken down by Region and Category, including regional subtotals and the grand total?"

SELECT 
    o.region, 
    p.category, 
    SUM(f.sales) AS total_sales,
    CASE 
        WHEN GROUPING(o.region) = 1 THEN 'Grand Total'
        WHEN GROUPING(p.category) = 1 THEN o.region || ' Subtotal'
        ELSE o.region 
    END AS region_label
FROM fact_sales f
JOIN dim_order o ON f.orderkey = o.orderkey
JOIN dim_product p ON f.productkey = p.productkey
GROUP BY ROLLUP(o.region, p.category)
ORDER BY o.region, p.category;

--Insight: "The output shows the 'West' region as our top-performing territory with $725,457.93 in total sales, significantly outperforming the 'South' region which generated $391,721.90. The subtotal rows allow us to confirm that while 'Technology' is a major driver of sales in the West ($251,991.86), 'Furniture' contributes the largest share in the Central region ($163,797.26). The 'Grand Total' of $2,297,201.07 confirms the total revenue across all regions over the recorded period."

-----------------------------------------------

-- Q2: CUBE (Cross-Tabulation)
--Business Question: "How does total profit vary across all combinations of Region and Segment, including subtotals for each?"

SELECT 
    o.region, 
    c.segment, 
    SUM(f.profit) AS total_profit
FROM fact_sales f
JOIN dim_order o ON f.orderkey = o.orderkey
JOIN dim_customer c ON f.customerkey = c.customerkey
GROUP BY CUBE(o.region, c.segment)
ORDER BY o.region, c.segment;

--Insight: "The cross-tabulation identifies that the 'West' region's 'Consumer' segment is our most profitable combination, contributing $134,119.33 in profit. Conversely, our analysis shows that 'Corporate' and 'Home Office' segments in the South region generate a combined profit of $19,836.08, which is lower than expected. By reviewing the '[null]' rows in our cube, we can see the total profit contribution for each region independently, showing that the West leads with a total regional profit of $286,397.79."

----------------------------------------------------

--Q3: LAG (Period-over-Period)
--Business Question: "How do current monthly sales compare to the sales of the previous month?"

WITH Monthly_Sales AS (
    SELECT t.year, t.month, SUM(f.sales) as monthly_total
    FROM fact_sales f
    JOIN dim_time t ON f.timekey = t.timekey
    GROUP BY t.year, t.month
)
SELECT 
    year, month, monthly_total,
    LAG(monthly_total, 1) OVER (ORDER BY year, month) as prev_month_sales,
    (monthly_total - LAG(monthly_total, 1) OVER (ORDER BY year, month)) as growth
FROM Monthly_Sales
ORDER BY year, month;

--Insight: "The period-over-period comparison highlights significant volatility, with December 2016 showing our highest monthly performance at $96,999.07, a growth of $17,587.04 from the previous month. In contrast, February 2017 saw a sharp decline in sales, dropping to $20,301.12 from $43,971.37 in January. This cyclical pattern indicates a strong end-of-year performance followed by a post-holiday slump, suggesting that promotional campaigns should be increased during Q1 to stabilize revenue."

------------------------------------------------


--Q4: Running Total
--Business Question: "What is the Year-to-Date (YTD) cumulative sales performance for each month?"

WITH Monthly_Sales AS (
    SELECT t.year, t.month, SUM(f.sales) as monthly_total
    FROM fact_sales f
    JOIN dim_time t ON f.timekey = t.timekey
    GROUP BY t.year, t.month
)
SELECT 
    year, month, monthly_total,
    SUM(monthly_total) OVER (PARTITION BY year ORDER BY month) as ytd_total
FROM Monthly_Sales
ORDER BY year, month;

--Insight: "Our cumulative year-to-date (YTD) performance tracking confirms consistent growth, with 2016 closing at a total revenue of $609,205.86. By the end of Q2 in 2017, the running total had reached $256,909.17, indicating we are on a steady trajectory compared to the same period in previous years. This running total view allows management to monitor progress against our annual revenue goals in real-time."

------------------------------------------------




--Q5: DENSE_RANK (Top-N Entities)
--Business Question: "Who are the top 3 most profitable products within each Category?"

WITH Ranked_Products AS (
    SELECT 
        p.category, 
        p.productname, 
        SUM(f.profit) as total_profit,
        DENSE_RANK() OVER(PARTITION BY p.category ORDER BY SUM(f.profit) DESC) as profit_rank
    FROM fact_sales f
    JOIN dim_product p ON f.productkey = p.productkey
    GROUP BY p.category, p.productname
)
SELECT * FROM Ranked_Products 
WHERE profit_rank <= 3
ORDER BY category, profit_rank;

--Insight: "The DENSE_RANK analysis reveals that the 'Canon imageCLASS 2200' copier is the most profitable product in the 'Technology' category, generating $25,199.94 in profit. This product dominates its category by a wide margin compared to the 2nd ranked item, which earned $6,983.89. Maintaining high stock levels for these top-ranked items is essential, as they are clearly the primary contributors to the company’s bottom line."

---------------------------------------------------


--Q6: Multi-Dimension Filter
--Business Question: "What are the sales and profit totals for 'Technology' items shipped via 'Standard Class' in the 'West' region?"

SELECT 
    p.subcategory,
    o.state,
    SUM(f.sales) as total_sales,
    SUM(f.profit) as total_profit
FROM fact_sales f
JOIN dim_product p ON f.productkey = p.productkey
JOIN dim_order o ON f.orderkey = o.orderkey
WHERE p.category = 'Technology' 
  AND o.shipmode = 'Standard Class'
  AND o.region = 'West'
GROUP BY p.subcategory, o.state
ORDER BY total_sales DESC;

--Insight: "Filtering for 'Technology' items shipped via 'Standard Class' to the 'West' region highlights that 'Phones' are the highest-selling subcategory in California, with $41,021.34 in sales and $3,968.77 in profit. However, some items, such as 'Machines' in Arizona, show a negative profit of -$866.95, even within the 'Standard Class' shipping channel. This specific drill-down allows the management team to identify that while 'Phones' are successful, the pricing or cost of 'Machines' in Arizona requires an urgent business review."

---------------------------------------------------

