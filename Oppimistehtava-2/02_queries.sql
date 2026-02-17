--> Kysely 1
SELECT o.order_id, o.order_date, c.full_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

--> Kysely 2
SELECT oi.order_id,
       p.name,
       oi.quantity,
       oi.unit_price
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.id
ORDER BY oi.order_id, p.name;

--> Kysely 3
SELECT o.order_id,
       o.order_date,
       c.full_name,
       p.name,
       oi.quantity,
       oi.unit_price
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
INNER JOIN order_items oi
    ON o.order_id = oi.order_id
INNER JOIN products p
    ON oi.product_id = p.id
ORDER BY o.order_id, p.name;

--> Kysely 4
SELECT c.full_name,
       COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY order_count DESC, c.full_name;

--> kysely 5
SELECT p.name
FROM products p
LEFT JOIN order_items oi
    ON p.id = oi.product_id
WHERE oi.order_id IS NULL;
