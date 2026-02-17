ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES categories(id)
ON DELETE RESTRICT;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name TEXT NOT NULL,
    email TEXT UNIQUE
);

CREATE TABLE orders (
	order_id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	order_date DATE NOT NULL,
	CONSTRAINT fk_orders_customer
		FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE RESTRICT
);

CREATE TABLE order_items (
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 1),
    unit_price NUMERIC(10,2) NOT NULL,

    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,

    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);