USE ecommerce_db_;

-- 1. Find customers whose total spending is
-- greater than the average spending of all customers.

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spending
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) > (
    SELECT AVG(customer_spending)
    FROM (
        SELECT
            customer_id,
            SUM(total_amount) AS customer_spending
        FROM orders
        GROUP BY customer_id
    ) AS spending_summary
)
ORDER BY total_spending DESC;


-- 2. Find the second-highest product price.

SELECT MAX(price) AS second_highest_price
FROM products
WHERE price < (
    SELECT MAX(price)
    FROM products
);


-- 3. Rank products based on total quantity sold.

WITH ProductSales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity
    FROM products AS p
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    total_quantity,
    RANK() OVER (
        ORDER BY total_quantity DESC
    ) AS sales_rank
FROM ProductSales;


-- 4. Find the highest-selling product in each category.

WITH ProductSales AS (
    SELECT
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity
    FROM categories AS c
    INNER JOIN products AS p
        ON c.category_id = p.category_id
    INNER JOIN order_items AS oi
        ON p.product_id = oi.product_id
    GROUP BY
        c.category_id,
        c.category_name,
        p.product_id,
        p.product_name
),
RankedProducts AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY category_id
            ORDER BY total_quantity DESC
        ) AS product_rank
    FROM ProductSales
)
SELECT
    category_name,
    product_name,
    total_quantity
FROM RankedProducts
WHERE product_rank = 1;


-- 5. Classify products based on stock quantity.

SELECT
    product_id,
    product_name,
    stock_quantity,
    CASE
        WHEN stock_quantity = 0
            THEN 'Out of Stock'
        WHEN stock_quantity <= 10
            THEN 'Low Stock'
        WHEN stock_quantity <= 50
            THEN 'Medium Stock'
        ELSE 'High Stock'
    END AS stock_status
FROM products;


-- 6. Find products that have never received a review.

SELECT
    p.product_id,
    p.product_name
FROM products AS p
LEFT JOIN reviews AS r
    ON p.product_id = r.product_id
WHERE r.review_id IS NULL;


-- 7. Calculate total revenue by month.

SELECT
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY
    YEAR(o.order_date),
    MONTH(o.order_date)
ORDER BY order_year, order_month;


-- 8. Find the previous order date for each customer.

SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_order_date
FROM orders;


-- 9. Find customers who have never placed an order.

SELECT
    c.customer_id,
    c.customer_name
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- 10. Calculate the total number of products
-- in each stock availability category.

SELECT
    CASE
        WHEN stock_quantity = 0
            THEN 'Out of Stock'
        WHEN stock_quantity <= 10
            THEN 'Low Stock'
        ELSE 'Available'
    END AS stock_status,
    COUNT(*) AS total_products
FROM products
GROUP BY
    CASE
        WHEN stock_quantity = 0
            THEN 'Out of Stock'
        WHEN stock_quantity <= 10
            THEN 'Low Stock'
        ELSE 'Available'
    END;
