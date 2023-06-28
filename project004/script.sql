--------------------------------------------------------------------------------

CREATE USER sherlock WITH PASSWORD 'drugs';
CREATE USER watson WITH PASSWORD 'vietnam';

CREATE ROLE rol_admin NOINHERIT;
GRANT SELECT, UPDATE, DELETE ON users, products, orders, order_details TO rol_admin;
CREATE ROLE rol_visit NOINHERIT;
GRANT SELECT ON  users, products TO rol_visit;

--------------------------------------------------------------------------------

GRANT rol_admin TO sherlock;
GRANT rol_visit TO watson;

--------------------------------------------------------------------------------

CREATE VIEW order_summary AS
SELECT
  orders.id AS order_id,
  orders.order_date AS date,
  SUM(order_details.quantity) AS total_products,
  SUM(products.price * order_details.quantity) AS total_price
FROM
  orders
  INNER JOIN order_details ON orders.id = order_details.order_id
  INNER JOIN products ON order_details.product_id = products.id
GROUP BY
  orders.id;

SELECT * FROM order_summary;

--------------------------------------------------------------------------------

CREATE VIEW user_purchases AS
SELECT 
  users.username,
  users.email,
  COUNT(orders.id) AS number_of_purchases
FROM 
  users
  INNER JOIN orders ON users.id = orders.user_id
  INNER JOIN order_details ON orders.id = order_details.order_id
GROUP BY 
  users.username, users.email
ORDER BY 
  number_of_purchases DESC;

SELECT * FROM user_purchases;

