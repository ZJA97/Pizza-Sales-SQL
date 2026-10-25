-- 1. How many orders per month?
SELECT MONTH(date) AS month_num,
       COUNT(*)          AS orders
FROM orders
GROUP BY MONTH(date)
ORDER BY month_num;
 
-- 2. How many orders per day of the week? (busiest first)
SELECT DAYNAME(date) AS weekday,
       COUNT(*)            AS orders
FROM orders
GROUP BY DAYNAME(date)
ORDER BY orders DESC;
 
-- 3. How many orders per hour of the day?
SELECT HOUR(time) AS hour_of_day,
       COUNT(*)         AS orders
FROM orders
GROUP BY HOUR(time)
ORDER BY hour_of_day;
 
-- 4. On how many different days did the shop take orders?
SELECT COUNT(DISTINCT date) AS trading_days
FROM orders;
 
-- 5. How many pizzas on the menu in each category?
SELECT category,
       COUNT(*) AS menu_items
FROM pizza_types
GROUP BY category
ORDER BY menu_items DESC;
 
-- 6. Average price for each size
SELECT size,
       ROUND(AVG(price), 2) AS avg_price
FROM pizzas
GROUP BY size
ORDER BY avg_price;
 
-- 7. Which orders had the most separate pizza lines?
SELECT order_id,
       COUNT(*) AS order_lines
FROM order_details
GROUP BY order_id
ORDER BY order_lines DESC
LIMIT 5;
 
-- 8. HAVING: which pizza sizes (pizza_id) sold more than 1,300 units?
SELECT pizza_id,
       SUM(quantity) AS units_sold
FROM order_details
GROUP BY pizza_id
HAVING SUM(quantity) > 1300
ORDER BY units_sold DESC;
 
-- 9. HAVING: which days had more than 100 orders?
SELECT date,
       COUNT(*) AS orders
FROM orders
GROUP BY date
HAVING COUNT(*) > 100
ORDER BY orders DESC;
 
 
-- 10. Peek: the value of each order line
SELECT od.order_details_id,
       od.pizza_id,
       od.quantity,
       p.price,
       od.quantity * p.price AS line_total
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
LIMIT 10;
 
-- 11. Total revenue for the year
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id;
 
-- 12. Average order value (total revenue / number of orders)
SELECT ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS avg_order_value
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id;
 
-- 13. Revenue by pizza size
SELECT p.size,
       SUM(od.quantity * p.price) AS revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY revenue DESC;
 
-- 14. Revenue by category (three tables joined)
SELECT pt.category,
       SUM(od.quantity * p.price) AS revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;
 
-- 15. Top 5 pizzas by revenue
SELECT pt.name,
       SUM(od.quantity * p.price) AS revenue
FROM order_details AS od
JOIN pizzas AS p
    ON od.pizza_id = p.pizza_id
JOIN pizza_types AS pt
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 5;