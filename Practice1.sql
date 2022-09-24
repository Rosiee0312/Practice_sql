CREATE SCHEMA dannys_diner;

CREATE TABLE sales (
    customer_id VARCHAR(1),
    order_date DATE,
    product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

CREATE TABLE menu (
    product_id INTEGER,
    product_name VARCHAR(5),
    price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
    customer_id VARCHAR(1),
    join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
-- Answer the question:
/* 
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

*/

SELECT 
    s.customer_id, SUM(m.price)
FROM
    sales AS S
        JOIN
    menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY customer_id;

-- 2. How many days has each customer visited the restaurant?
SELECT 
    s.customer_id, COUNT(s.order_date)
FROM
    sales s
GROUP BY s.customer_id
ORDER BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?
WITH recursive CTE1 AS
(
SELECT s.customer_id, 
	s.order_date,
    m.product_name,
    dense_rank() OVER (partition by s.customer_id ORDER BY s.order_date) AS bought_item_order
FROM sales s
JOIN menu m
ON s.product_id = m.product_id  
group by customer_id
) 


select customer_id, product_name
FROM CTE1
WHERE bought_item_order = 1
group by customer_id, product_name
order by customer_id; 

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name, COUNT(*) AS purchased_total_amount
FROM menu m
JOIN sales s
ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY purchased_total_amount desc
LIMIT 1;

-- 5. Which item was the most popular for each customer?
WITH recursive CTE3 AS
(
select s.customer_id, m.product_name, COUNT(*) AS item_quantity
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
GROUP BY s.customer_id, m.product_name
),
CT4 AS
(
SELECT customer_id, product_name,
RANK() OVER (partition by customer_id order by item_quantity  DESC) AS rank_
FROM CTE3
)
SELECT customer_id, product_name
FROM CT4
WHERE rank_ = 1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT s.customer_id, m.product_name AS first_date_item
FROM sales s
JOIN menu AS m
ON s.product_id = m.product_id
JOIN
(
SELECT s.customer_id, MIN(s.order_date) AS first_date_joined
FROM sales s
LEFT JOIN members mem
ON s.customer_id = mem.customer_id
WHERE mem.join_date <= s.order_date
GROUP BY s.customer_id
) AS CTE5
ON s.customer_id = CTE5.customer_id AND s.order_date = CTE5	.first_date_joined;

-- 7. Which item was purchased just before the customer became a member?
SELECT s.customer_id, m.product_name AS before_customer_item
FROM sales s
JOIN menu AS m
ON s.product_id = m.product_id
JOIN
(
SELECT s.customer_id, MAX(s.order_date) AS before_customer_date
FROM sales s
LEFT JOIN members mem
ON s.customer_id = mem.customer_id
WHERE mem.join_date > s.order_date
GROUP BY s.customer_id
) AS CTE6
ON s.customer_id = CTE6.customer_id AND s.order_date = CTE6	.before_customer_date;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id, COUNT(*) AS total_item_before_join, SUM(m.price) AS total_spent_before_join
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
LEFT JOIN members mem
ON s.customer_id = mem.customer_id
WHERE mem.join_date > s.order_date
group by s.customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH recursive CT7 AS
(
SELECT s.customer_id,
	m.product_name,
    m.price,
CASE WHEN product_name = "sushi" THEN m.price * 20 ELSE m.price * 10 END AS item_point
FROM sales s
JOIN menu m
ON s.product_id = m.product_id
)
SELECT customer_id,
item_point
FROM CT7
GROUP BY customer_id;

 








    


