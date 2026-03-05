-- Myymälän varastolista
SELECT
s.name AS store_name,
p.name AS product_name,
st.quantity
FROM stocks st
JOIN stores s ON st.store_id = s.store_id
JOIN products p ON st.product_id = p.id
ORDER BY s.name, p.name;

-- Alhaisen varaston raportti
SELECT
p.name,
SUM(st.quantity) AS total_stock
FROM stocks st
JOIN products p ON st.product_id = p.id
GROUP BY p.name
HAVING SUM(st.quantity) < 10;

-- Työntekijät per myymälä
SELECT
s.name,
COUNT(e.employee_id) AS employee_count
FROM stores s
LEFT JOIN employees e
ON s.store_id = e.store_id
GROUP BY s.name;

-- Eniten varastossa olevat tuotteet
SELECT
p.name,
SUM(st.quantity) AS total_stock
FROM stocks st
JOIN products p
ON st.product_id = p.id
GROUP BY p.name
ORDER BY total_stock DESC
LIMIT 5;