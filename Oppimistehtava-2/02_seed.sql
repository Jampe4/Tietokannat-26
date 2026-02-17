INSERT INTO customers (full_name, email) VALUES
('Emma Virtanen', 'emma@example.com'),
('Jussi Mäkinen', 'jussi@example.com'),
('Liisa Korhonen', 'liisa@example.com'),
('Olli Nieminen', NULL);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-01-15'),
(1, '2024-02-20'),
(2, '2024-01-22'),
(3, '2024-02-10'),
(4, '2024-03-01');

INSERT INTO order_items VALUES
(1,1,1,149.99),
(1,4,2,79.95),
(2,14,1,119.00),
(3,4,1,129.00),
(3,10,1,54.95),
(4,15,3,14.99),
(5,11,1,24.99),
(5,12,2,19.90);


