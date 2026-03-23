-- Q1: Total Revenue by Product Category
-- Business Justification: Identifies which product categories generate the most income.
SELECT 
    p.category,
    SUM(oi.quantity * p.unit_price) AS total_revenue
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    p.category
ORDER BY 
    total_revenue DESC;

-- Q2: Top 3 Customers by Total Spend
-- Business Justification: Identifies high-value clients for loyalty programs.
SELECT 
    c.customer_name,
    c.customer_city,
    SUM(oi.quantity * p.unit_price) AS total_spent
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    c.customer_id, c.customer_name, c.customer_city
ORDER BY 
    total_spent DESC
LIMIT 3;

-- Q3: Sales Representative Performance (Order Volume & Revenue)
-- Business Justification: Evaluates staff productivity based on orders handled and revenue generated.
SELECT 
    sr.sales_rep_name,
    COUNT(DISTINCT o.order_id) AS total_orders_handled,
    SUM(oi.quantity * p.unit_price) AS total_revenue_generated
FROM 
    sales_reps sr
JOIN 
    orders o ON sr.sales_rep_id = o.sales_rep_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    sr.sales_rep_id, sr.sales_rep_name
ORDER BY 
    total_revenue_generated DESC;
