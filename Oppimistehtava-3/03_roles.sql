-- ROLES
CREATE ROLE role_store_manager;
CREATE ROLE role_sales_associate;
CREATE ROLE role_analyst;


-- STORE MANAGER PERMISSIONS
GRANT SELECT, INSERT, UPDATE ON stocks TO role_store_manager;
GRANT SELECT ON products TO role_store_manager;
GRANT SELECT ON stores TO role_store_manager;
GRANT SELECT ON employees TO role_store_manager;


-- SALES ASSOCIATE PERMISSIONS
GRANT SELECT ON products TO role_sales_associate;
GRANT SELECT ON stocks TO role_sales_associate;


-- ANALYST PERMISSIONS
GRANT SELECT ON customers TO role_analyst;
GRANT SELECT ON orders TO role_analyst;
GRANT SELECT ON order_items TO role_analyst;
GRANT SELECT ON products TO role_analyst;
GRANT SELECT ON stores TO role_analyst;
GRANT SELECT ON stocks TO role_analyst;


-- USERS
CREATE ROLE manager1 WITH PASSWORD 'manager1';
CREATE ROLE sales1 WITH PASSWORD 'sales1';
CREATE ROLE analyst1 WITH PASSWORD 'analyst1';


-- ASSIGN ROLES
GRANT role_store_manager TO manager1;
GRANT role_sales_associate TO sales1;
GRANT role_analyst TO analyst1;