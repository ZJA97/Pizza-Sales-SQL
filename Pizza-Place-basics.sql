-- 1. Take a look at each table
SELECT * FROM pizza_types;
SELECT * FROM pizzas;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_details LIMIT 10;
 
-- 2. Sanity check: how many rows are in each table?
SELECT COUNT(*) FROM pizza_types;
SELECT COUNT(*) FROM pizzas;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_details;
 
-- 3. What pizza categories are on the menu?
SELECT DISTINCT category
FROM pizza_types;
 
-- 4. What sizes do the pizzas come in?
SELECT DISTINCT size
FROM pizzas;
 
-- 5. List all the Veggie pizzas, A to Z
SELECT name, category
FROM pizza_types
WHERE category = 'Veggie'
ORDER BY name;
 
-- 6. The 5 most expensive pizzas on the menu
SELECT pizza_id, price
FROM pizzas
ORDER BY price DESC
LIMIT 5;
 
-- 7. Cheapest and most expensive price
SELECT MIN(price) AS cheapest,
       MAX(price) AS most_expensive
FROM pizzas;
 
-- 8. What period does the data cover?
SELECT MIN(date) AS first_order,
       MAX(date) AS last_order
FROM orders;
 
-- 9. How many orders were placed on 4 July 2015?
SELECT COUNT(*) AS orders_on_4_july
FROM orders
WHERE date = '2015-07-04';
 
-- 10. How many orders were placed in December 2015?
SELECT COUNT(*) AS december_orders
FROM orders
WHERE date BETWEEN '2015-12-01' AND '2015-12-31';
 
-- 11. How many order lines had more than one of the same pizza?
SELECT COUNT(*) AS multi_quantity_lines
FROM order_details
WHERE quantity > 1;
 
-- 12. How many pizzas were sold in total?
SELECT SUM(quantity) AS total_pizzas_sold
FROM order_details;
 
-- 13. Which pizza types have "Chicken" in the name?
SELECT name, category
FROM pizza_types
WHERE name LIKE '%Chicken%';