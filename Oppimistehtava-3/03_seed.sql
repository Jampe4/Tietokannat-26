INSERT INTO stores (name, type, city, street_address)
VALUES
('TrailShop Online', 'ONLINE', NULL, NULL),
('TrailShop Helsinki', 'PHYSICAL', 'Helsinki', 'Mannerheimintie 10'),
('TrailShop Kuopio', 'PHYSICAL', 'Kuopio', 'Puijonkatu 5');

INSERT INTO employees (full_name, role_title, hire_date, store_id)
VALUES
('Aino Laine', 'Store Manager', '2023-05-10', 1),
('Mikko Saarinen', 'Sales Support', '2024-01-15', 1),

('Ella Virtanen', 'Store Manager', '2022-09-01', 2),
('Jari Lehtonen', 'Sales Associate', '2023-11-20', 2),

('Niko Hakkarainen', 'Store Manager', '2021-04-12', 3),
('Salla Niemi', 'Sales Associate', '2024-02-05', 3);

INSERT INTO stocks (store_id, product_id, quantity) VALUES
(1,1,50),
(1,2,30),
(1,3,20),
(1,4,10),
(1,5,15),

(2,1,25),
(2,2,40),
(2,6,18),
(2,7,12),
(2,8,9),

(3,1,35),
(3,2,22),
(3,3,8),
(3,6,14),
(3,7,5);