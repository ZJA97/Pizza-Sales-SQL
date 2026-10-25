-- =====================================================
-- Pizza Place Sales | MySQL 
-- Step 1: create the database and tables
-- Tables are created (and must be IMPORTED) in this order,
-- because later tables point at earlier ones via foreign keys:
--   pizza_types -> pizzas -> orders -> order_details
-- =====================================================

CREATE DATABASE IF NOT EXISTS pizza_place
    CHARACTER SET utf8mb4;

USE pizza_place;

-- One row per pizza on the menu (e.g. "The Greek Pizza")
CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(20)  PRIMARY KEY,
    name          VARCHAR(60)  NOT NULL,
    category      VARCHAR(20)  NOT NULL,
    ingredients   VARCHAR(150) NOT NULL
);

-- One row per pizza type AND size (e.g. the_greek_xl)
CREATE TABLE pizzas (
    pizza_id      VARCHAR(20)  PRIMARY KEY,
    pizza_type_id VARCHAR(20)  NOT NULL,
    size          VARCHAR(4)   NOT NULL,
    price         DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_types (pizza_type_id)
);

-- One row per customer order (date and time of the order)
CREATE TABLE orders (
    order_id   INT  PRIMARY KEY,
    date       DATE NOT NULL,
    time       TIME NOT NULL
);

-- One row per pizza line within an order
CREATE TABLE order_details (
    order_details_id INT         PRIMARY KEY,
    order_id         INT         NOT NULL,
    pizza_id         VARCHAR(20) NOT NULL,
    quantity         INT         NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas (pizza_id)
);
