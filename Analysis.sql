-- -----------------------------------------------------
-- SETUP: a view that does the joins once, so every query
-- below is shorter. A view is a saved query you can treat
-- like a table.
-- -----------------------------------------------------
CREATE OR REPLACE VIEW v_sales AS
SELECT od.order_details_id,
       od.order_id,
       o.date,
       o.time,
       pt.name,
       pt.category,
       p.size,
       od.quantity,
       p.price,
       od.quantity * p.price AS line_revenue
FROM order_details AS od
JOIN orders AS o
    ON od.order_id = o.order_id
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id;
    
    -- 1. Top 5 pizzas by units sold
SELECT s.name,
       SUM(s.quantity) AS units_sold
FROM v_sales AS s
GROUP BY s.name
ORDER BY units_sold DESC
LIMIT 5;

-- 2. Bottom 5 pizzas by units sold
SELECT s.name,
       SUM(s.quantity) AS units_sold
FROM v_sales AS s
GROUP BY s.name
ORDER BY units_sold ASC
LIMIT 5;

-- 3. Revenue by month
SELECT MONTH(s.date)       AS month_num,
       SUM(s.line_revenue) AS revenue
FROM v_sales AS s
GROUP BY MONTH(s.date)
ORDER BY month_num;

-- 4. On average, how many pizzas are in an order?
SELECT ROUND(SUM(s.quantity) / COUNT(DISTINCT s.order_id), 2) AS avg_pizzas_per_order
FROM v_sales AS s;
 
-- 5. The 3 highest-revenue days of the year
SELECT s.date,
       SUM(s.line_revenue) AS revenue
FROM v_sales AS s
GROUP BY s.date
ORDER BY revenue DESC
LIMIT 3;

-- 6. How many orders in the morning, afternoon and evening?
SELECT CASE
           WHEN HOUR(o.time) < 12 THEN '1. Morning (before 12)'
           WHEN HOUR(o.time) < 17 THEN '2. Afternoon (12 to 4:59pm)'
           ELSE                        '3. Evening (5pm onwards)'
       END AS period_of_day,
       COUNT(*) AS orders
FROM orders AS o
GROUP BY period_of_day
ORDER BY period_of_day;

-- 7. What % of total revenue does each category bring in?
WITH category_revenue AS (
    SELECT s.category,
           SUM(s.line_revenue) AS revenue
    FROM v_sales AS s
    GROUP BY s.category
)
SELECT category,
       revenue,
       ROUND(revenue / (SELECT SUM(revenue) FROM category_revenue) * 100, 1) AS pct_of_total
FROM category_revenue
ORDER BY revenue DESC;
 
-- 8. STRETCH: which days of 2015 have NO orders at all?
WITH RECURSIVE calendar AS (
    SELECT CAST('2015-01-01' AS DATE) AS calendar_date
    UNION ALL
    SELECT calendar_date + INTERVAL 1 DAY
    FROM calendar
    WHERE calendar_date < '2015-12-31'
)
SELECT c.calendar_date,
       DAYNAME(c.calendar_date) AS weekday
FROM calendar AS c
LEFT JOIN orders AS o
    ON o.date = c.calendar_date
WHERE o.order_id IS NULL
ORDER BY c.calendar_date;

-- 9. Top 3 pizzas by revenue within each category
WITH pizza_revenue AS (
    SELECT s.category,
           s.name,
           SUM(s.line_revenue) AS revenue
    FROM v_sales AS s
    GROUP BY s.category, s.name
),
ranked AS (
    SELECT category,
           name,
           revenue,
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS revenue_rank
    FROM pizza_revenue
)
SELECT category, name, revenue, revenue_rank
FROM ranked
WHERE revenue_rank <= 3
ORDER BY category, revenue_rank;
 
-- 10. Monthly revenue with a running (cumulative) total
WITH monthly AS (
    SELECT MONTH(s.date)       AS month_num,
           SUM(s.line_revenue) AS revenue
    FROM v_sales AS s
    GROUP BY MONTH(s.date)
)
SELECT month_num,
       revenue,
       SUM(revenue) OVER (ORDER BY month_num) AS running_total
FROM monthly
ORDER BY month_num;
 
-- 11. Month-over-month revenue change (%) using LAG
WITH monthly AS (
    SELECT MONTH(s.date)       AS month_num,
           SUM(s.line_revenue) AS revenue
    FROM v_sales AS s
    GROUP BY MONTH(s.date)
)
SELECT month_num,
       revenue,
       LAG(revenue) OVER (ORDER BY month_num) AS previous_month,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY month_num))
             / LAG(revenue) OVER (ORDER BY month_num) * 100, 1) AS pct_change
FROM monthly
ORDER BY month_num;