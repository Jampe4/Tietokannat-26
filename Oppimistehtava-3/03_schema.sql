-- STORES TABLE
CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('ONLINE','PHYSICAL')),
    city VARCHAR(100),
    street_address VARCHAR(150)
);

-- STOCKS TABLE
CREATE TABLE stocks (
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),

    PRIMARY KEY (store_id, product_id),

    FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE RESTRICT
);


-- EMPLOYEES TABLE
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    role_title VARCHAR(100) NOT NULL,
    hire_date DATE,
    store_id INT NOT NULL,

    FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
        ON DELETE RESTRICT
);