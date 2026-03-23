--Q1: Total sales revenue by product category for each month
-- Joins fact_sales → dim_product (for category) → dim_date (for month/year)
-- Groups by year, month, and category to show monthly revenue trends per category
 
SELECT
    d.year,
    d.month,
    d.month_name,
    p.category,
    SUM(f.total_revenue)                          AS total_revenue,
    SUM(f.units_sold)                             AS total_units_sold,
    COUNT(f.transaction_id)                       AS total_transactions
FROM fact_sales f
JOIN dim_date    d ON f.date_key    = d.date_key
JOIN dim_product p ON f.product_key = p.product_key
GROUP BY
    d.year,
    d.month,
    d.month_name,
    p.category
ORDER BY
    d.year,
    d.month,
    total_revenue DESC;
 
 
-- Q2: Top 2 performing stores by total revenue
-- Joins fact_sales → dim_store to aggregate revenue per store
-- Uses LIMIT 2 to return only the top 2 stores
 
SELECT
    s.store_key,
    s.store_name,
    s.store_city,
    s.store_region,
    SUM(f.total_revenue)      AS total_revenue,
    SUM(f.units_sold)         AS total_units_sold,
    COUNT(f.transaction_id)   AS total_transactions,
    ROUND(AVG(f.total_revenue), 2) AS avg_transaction_value
FROM fact_sales f
JOIN dim_store s ON f.store_key = s.store_key
GROUP BY
    s.store_key,
    s.store_name,
    s.store_city,
    s.store_region
ORDER BY total_revenue DESC
LIMIT 2;
 
 
-- Q3: Month-over-month sales trend across all stores
-- Calculates total revenue per month, then computes MoM change
-- Uses a subquery/CTE to derive the previous month's revenue for comparison
 
WITH monthly_revenue AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        SUM(f.total_revenue) AS revenue
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY
        d.year,
        d.month,
        d.month_name
),
mom_trend AS (
    SELECT
        year,
        month,
        month_name,
        revenue                                                      AS current_month_revenue,
        LAG(revenue) OVER (ORDER BY year, month)                    AS prev_month_revenue,
        ROUND(
            (revenue - LAG(revenue) OVER (ORDER BY year, month))
            / NULLIF(LAG(revenue) OVER (ORDER BY year, month), 0)
            * 100, 2
        )                                                            AS mom_growth_percent
    FROM monthly_revenue
)
SELECT
    year,
    month,
    month_name,
    current_month_revenue,
    prev_month_revenue,
    mom_growth_percent,
    CASE
        WHEN mom_growth_percent > 0  THEN 'Growth'
        WHEN mom_growth_percent < 0  THEN 'Decline'
        WHEN mom_growth_percent = 0  THEN 'Flat'
        ELSE 'First Month'
    END AS trend_indicator
FROM mom_trend
ORDER BY year, month;
