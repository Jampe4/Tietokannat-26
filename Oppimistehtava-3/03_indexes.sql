-- Stocks lookup index
CREATE INDEX idx_stocks_store_product
ON stocks(store_id, product_id);

-- Employee lookup index
CREATE INDEX idx_employees_store
ON employees(store_id);

-- Orders by customer
CREATE INDEX idx_orders_customer
ON orders(customer_id);

-- Product name search
CREATE INDEX idx_products_name
ON products(name);