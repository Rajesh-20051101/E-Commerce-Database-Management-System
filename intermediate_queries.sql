USE ecommerce_db_;

-- 1. Find the top 10 customers by total spending
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spending
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 10;


-- 2. Find the top 10 products by total quantity sold
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products AS p
INNER JOIN order_items AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- 3. Find the top 10 products by revenue
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products AS p
INNER JOIN order_items AS oi
    ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;


-- 4. Find customers who placed more than 5 orders
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;


-- 5. Find products that have never been ordered
SELECT
    p.product_id,
    p.product_name,
    p.price
FROM products AS p
LEFT JOIN order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;


-- 6. Find the average price of products in each category
SELECT
    c.category_name,
    AVG(p.price) AS average_price
FROM categories AS c
INNER JOIN products AS p
    ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
ORDER BY average_price DESC;


-- 7. Calculate total revenue from all order items
SELECT
    SUM(quantity * unit_price) AS total_revenue
FROM order_items;
