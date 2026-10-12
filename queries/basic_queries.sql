USE ecommerce_db_;

-- 1. Display all customers
SELECT *
FROM customers;

-- 2. Display all products
SELECT *
FROM products;

-- 3. Find products costing more than 1000
SELECT product_id, product_name, price
FROM products
WHERE price > 1000;

-- 4. Display the 10 most expensive products
SELECT product_id, product_name, price
FROM products
ORDER BY price DESC
LIMIT 10;

-- 5. Count the total number of customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 6. Find the average product price
SELECT AVG(price) AS average_price
FROM products;

-- 7. Display unique product categories
SELECT DISTINCT category_id
FROM products;

-- 8. Find products with prices between 500 and 5000
SELECT product_id, product_name, price
FROM products
WHERE price BETWEEN 500 AND 5000;

-- 9. Find customers whose names start with A
SELECT customer_id, customer_name
FROM customers
WHERE customer_name LIKE 'A%';

-- 10. Display the 10 most recent orders
SELECT order_id, customer_id, order_date
FROM orders
ORDER BY order_date DESC
LIMIT 10;
