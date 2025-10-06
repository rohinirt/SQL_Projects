# Instacart Market Baseket Analysis
## Introduction
Instacart is an on-demand grocery and household goods delivery and pickup services from a variety of retailers. The process is driven by its app, where customers select items from local stores and a personal shopper, who is an independent contractor, then hand-picks, pays for, and delivers the order to the customer's doorstep. Essentially, Instacart acts as a middleman, providing convenience and time savings for customers by connecting them with local retailers and a gig-economy workforce to handle the shopping and logistics.

## Objective
The objective of this analysis is to uncover actionable insights from Instacart’s order and product data to support data-driven business decisions. By analyzing customer purchase patterns, product performance, and ordering behavior, this project aims to identify loyal customers, understand retention trends, and highlight high-performing and underperforming product categories. The findings will help optimize product placement, tailor marketing campaigns, design loyalty offers, and improve customer experience by making the shopping journey more personalized and convenient.

## Dataset
The database used in the project is as follows:  
``order_products`` Links orders to the products purchased.  
``orders`` Contains order-level data such as order time, day of week, and user ID.  
``products``	Product-level details including aisle and department.  
``aisles``	Categories of grocery items (e.g., dairy eggs, beverages, snacks). 
``departments``	Higher-level grouping of aisles  

Find the dataset [here](https://www.kaggle.com/datasets/psparks/instacart-market-basket-analysis)

## Tools and Techniques
**Database**: Postgre SQL
**Querying Tool**: pgAdmin4

## Project Structure
**1) Database Creation**
- Created Instacard_db database and required tables inside it

``` sql  
CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY,
    department TEXT
);

CREATE TABLE aisles (
    aisle_id INTEGER PRIMARY KEY,
    aisle TEXT
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    aisle_id INTEGER,
    department_id INTEGER,
    FOREIGN KEY (aisle_id) REFERENCES aisles(aisle_id),
    FOREIGN KEY (department_id) REFERENCES public.departments(department_id)
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    eval_set VARCHAR(10),
    order_number INTEGER,
    order_dow SMALLINT,
    order_hour_of_day SMALLINT,
    day_since_prior_order NUMERIC
);

CREATE TABLE order_products (
    order_id INTEGER,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered SMALLINT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```
**2) Data Cleaning**  
- All tables were checked for null or duplicate values
- There was no missing vlues in important columns and no duplicate record found

**3) Data Analysis**
20 Business questions were solved to performa analysis and find actionable insights
CREATE TABLE departments (
department_id INTEGER  primary key,
department text
);

create table aisles (
aisle_id integer primary key,
aisle text
);

create table products (
product_id integer primary key,
product_name text,
aisle_id integer,
department_id integer,
foreign key (aisle_id) references aisles(aisle_id),
foreign key (department_id) references public.departments(department_id)
);

create table orders (
order_id integer primary key,
user_id integer not null,
eval_set varchar(10),
order_number integer,
order_dow smallint,
order_hour_of_day smallint,
day_since_prior_order numeric
);

create table order_products (
order_id integer,
product_id integer,
add_to_cart_order integer,
reordered smallint,
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products (product_id)
);

-- ===============================================================
-- BASIC / EXPLORATORY (easy) -- daily / product frequency & simple KPIs
-- ===============================================================

-- Q1: WHich are the top 10 selling products?
SELECT
  p.product_name,
  COUNT(op.product_id) AS total_orders
FROM order_products op
JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC
LIMIT 10;

-- Q2: Is there a pattern in orders throughout the week? Which days are popular for orders?
SELECT
  order_dow AS day_of_week,
  COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_dow
ORDER BY total_orders DESC;

-- Q3: What are the top products most commonly added to the cart first?
SELECT
  p.product_name,
  COUNT(op.order_id) AS frequency
FROM products p
JOIN order_products op ON p.product_id = op.product_id
WHERE op.add_to_cart_order = 1
GROUP BY p.product_name
ORDER BY frequency DESC
LIMIT 10;

-- Q4: How many unique products are typically included in a single order?
SELECT
  ROUND(AVG(products), 2) AS avg_unique_products
FROM (
  SELECT
    o.order_id,
    COUNT(DISTINCT op.product_id) AS products
  FROM orders o
  JOIN order_products op ON o.order_id = op.order_id
  GROUP BY o.order_id
) AS order_summary;

-- Q5: What is the average “product diversity” (distinct products bought) per customer?
WITH unique_products AS (
  SELECT
    o.user_id,
    COUNT(DISTINCT op.product_id) AS products
  FROM orders o
  JOIN order_products op ON o.order_id = op.order_id
  GROUP BY o.user_id
)
SELECT
  ROUND(AVG(products), 2) AS avg_product_bought,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY products) AS median_products,
  MIN(products) AS min_products,
  MAX(products) AS max_products
FROM unique_products;

-- ===============================================================
-- INTERMEDIATE (medium) -- customer lifecycle, cart behavior, peak hours
-- ===============================================================

-- Q6:For each customer, calculate their first and last order number, total number of orders placed, and average days between orders.
-- Then, identify the top 10 customers with the highest total orders
SELECT 
    user_id,
    MIN(order_number) AS first_order_number,
    MAX(order_number) AS last_order_number,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(day_since_prior_order), 2) AS avg_days_between_orders
FROM orders
WHERE day_since_prior_order IS NOT NULL
GROUP BY user_id
ORDER BY total_orders DESC
LIMIT 10;


-- Q7: Inactive customers: Identify customers who stopped ordering after fewer than 5 orders
WITH customers AS (
  SELECT
    user_id
  FROM orders
  GROUP BY user_id
  HAVING COUNT(order_number) < 5
)
SELECT
  COUNT(user_id) AS customers_with_fewer_than_5_orders
FROM customers;

-- Q8: Calculate the products reorder rate by cart position bucket (1–5, 6–10, >10)
SELECT
  CASE
    WHEN add_to_cart_order BETWEEN 1 AND 5 THEN '1-5'
    WHEN add_to_cart_order BETWEEN 6 AND 10 THEN '6-10'
    ELSE '>10'
  END AS cart_position_bucket,
  100.0 * SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS reorder_rate_pct
FROM order_products
GROUP BY cart_position_bucket
ORDER BY cart_position_bucket;

-- Q9: Peak order hours: For each day of week, find the top 3 hours with maximum order volume
WITH peak_hours AS (
  SELECT
    order_dow,
    order_hour_of_day,
    COUNT(order_id) AS orders,
    DENSE_RANK() OVER (PARTITION BY order_dow ORDER BY COUNT(order_id) DESC) AS hour_rank
  FROM orders
  GROUP BY order_dow, order_hour_of_day
)
SELECT
  order_dow,
  order_hour_of_day,
  orders
FROM peak_hours
WHERE hour_rank <= 3
ORDER BY order_dow, orders DESC;

-- Q10: Basket size trend: calculate average basket size (distinct products) by order_number
WITH basket_sizes AS (
  SELECT
    o.user_id,
    o.order_id,
    o.order_number,
    COUNT(DISTINCT p.product_id) AS basket_size
  FROM orders o
  JOIN order_products p ON o.order_id = p.order_id
  GROUP BY o.user_id, o.order_id, o.order_number
)
SELECT
  order_number,
  ROUND(AVG(basket_size)::numeric, 2) AS avg_basket_size
FROM basket_sizes
GROUP BY order_number
ORDER BY order_number;

-- Q11: Most reordered products: products with highest reorder rate (%) excluding low-frequency products (min 100 orders)
SELECT
  p.product_id,
  p.product_name,
  100.0 * SUM(CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS reorder_rate_pct,
  COUNT(*) AS total_orders
FROM order_products op
JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(*) >= 100
ORDER BY reorder_rate_pct DESC
LIMIT 10;

-- Q12: Find the top product pairs that are ordered together frequently
WITH total_orders AS (
  SELECT COUNT(DISTINCT order_id) AS total_orders
  FROM order_products
),
pair_counts AS (
  SELECT
    op1.product_id AS product_a,
    op2.product_id AS product_b,
    COUNT(DISTINCT op1.order_id) AS pair_order_count
  FROM order_products op1
  JOIN order_products op2
    ON op1.order_id = op2.order_id
    AND op1.product_id < op2.product_id  
  GROUP BY op1.product_id, op2.product_id
)
SELECT
  pc.product_a,
  pa.product_name AS product_a_name,
  pc.product_b,
  pb.product_name AS product_b_name,
  pc.pair_order_count,
  ROUND(pc.pair_order_count::numeric / t.total_orders, 6) AS support
FROM pair_counts pc
CROSS JOIN total_orders t
LEFT JOIN products pa ON pa.product_id = pc.product_a
LEFT JOIN products pb ON pb.product_id = pc.product_b
ORDER BY pc.pair_order_count DESC
LIMIT 10;

-- (Alternative/efficient) Q12b: Top product pairs using array aggregation + generate_subscripts
WITH order_product_arrays AS (
  SELECT
    order_id,
    array_agg(DISTINCT product_id ORDER BY product_id) AS products
  FROM order_products
  GROUP BY order_id
),
order_pairs AS (
  SELECT
    opa.order_id,
    opa.products[i] AS product_a,
    opa.products[j] AS product_b
  FROM order_product_arrays opa
  JOIN generate_subscripts(opa.products, 1) AS s1(i) ON TRUE
  JOIN generate_subscripts(opa.products, 1) AS s2(j) ON s2.j > s1.i
),
pair_counts AS (
  SELECT
    product_a,
    product_b,
    COUNT(*) AS pair_order_count
  FROM order_pairs
  GROUP BY product_a, product_b
),
total_orders AS (
  SELECT COUNT(*) AS total_orders FROM order_product_arrays
)
SELECT
  pc.product_a,
  pa.product_name AS product_a_name,
  pc.product_b,
  pb.product_name AS product_b_name,
  pc.pair_order_count,
  ROUND(pc.pair_order_count::numeric / t.total_orders, 6) AS support
FROM pair_counts pc
CROSS JOIN total_orders t
LEFT JOIN products pa ON pa.product_id = pc.product_a
LEFT JOIN products pb ON pb.product_id = pc.product_b
ORDER BY pc.pair_order_count DESC
LIMIT 10;

-- ===============================================================
-- ADVANCED (hard) -- RFM-like, loyalty, ranking, pair transitions
-- ===============================================================

-- Q13: find the RFM-like segmentation
-- Recency = last order_number (higher means more recent),
-- Frequency = total orders,
-- Monetary = average basket size (distinct products per order)
WITH ppo AS (
  SELECT
    o.order_id,
    COUNT(DISTINCT p.product_id) AS products
  FROM orders o
  JOIN order_products p ON o.order_id = p.order_id
  GROUP BY o.order_id
),
user_rfm AS (
  SELECT
    o.user_id,
    MAX(o.order_number) AS recency,
    COUNT(o.order_number) AS frequency,
    ROUND(AVG(ppo.products)::numeric, 2) AS monetary
  FROM orders o
  JOIN ppo ON o.order_id = ppo.order_id
  GROUP BY o.user_id
)
SELECT
  user_id,
  recency,
  frequency,
  monetary
FROM user_rfm
ORDER BY frequency DESC
LIMIT 20;

-- Q14: Customer loyalty distribution: Find the % of users whose reorder_rate > 70%
WITH user_products AS (
  SELECT
    o.user_id,
    op.product_id,
    op.reordered
  FROM order_products op
  JOIN orders o USING (order_id)
),
user_stats AS (
  SELECT
    user_id,
    COUNT(*) AS total_products,
    SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) AS reordered_products,
    100.0 * SUM(CASE WHEN reordered = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS reorder_rate
  FROM user_products
  GROUP BY user_id
),
users_over_70 AS (
  SELECT COUNT(*) AS users_count FROM user_stats WHERE reorder_rate > 70.0
),
total_users AS (
  SELECT COUNT(*) AS total_users FROM user_stats
)
SELECT
  u.users_count,
  t.total_users,
  ROUND(100.0 * u.users_count::numeric / NULLIF(t.total_users, 0), 4) AS pct_of_users_over_70
FROM users_over_70 u
CROSS JOIN total_users t;

-- Q15: Product reorder ranking: top 5 products by reorder probability within each department
WITH product_rank AS (
  SELECT
    d.department,
    p.product_name,
    100.0 * SUM(CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS reorder_rate_pct,
    DENSE_RANK() OVER (PARTITION BY d.department ORDER BY 100.0 * SUM(CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) DESC) AS rnk
  FROM departments d
  JOIN products p ON d.department_id = p.department_id
  JOIN order_products op ON p.product_id = op.product_id
  GROUP BY d.department, p.product_name
)
SELECT
  department,
  product_name,
  ROUND(reorder_rate_pct, 2) AS reorder_rate_pct,
  rnk
FROM product_rank
WHERE rnk <= 5
ORDER BY department, rnk;

-- Q16: Calculate top 10% customers by lifetime volume by total products ordered per user
WITH user_volume AS (
  SELECT
    o.user_id,
    COUNT(op.product_id) AS total_products
  FROM orders o
  JOIN order_products op ON o.order_id = op.order_id
  GROUP BY o.user_id
),
user_percentile AS (
  SELECT
    user_id,
    total_products,
    PERCENT_RANK() OVER (ORDER BY total_products ASC) AS pct_rank_asc
  FROM user_volume
)
SELECT
  user_id,
  total_products
FROM user_percentile
WHERE pct_rank_asc >= 0.90 
ORDER BY total_products DESC;

-- Q17: Find customers who buy from more than 5 different departments in a single order
WITH product_dept AS (
  SELECT
    o.user_id,
    o.order_id,
    p.department_id
  FROM orders o
  JOIN order_products op ON o.order_id = op.order_id
  JOIN products p ON op.product_id = p.product_id
),
orders_dept AS (
  SELECT
    user_id,
    order_id,
    COUNT(DISTINCT department_id) AS dept_count
  FROM product_dept
  GROUP BY user_id, order_id
  HAVING COUNT(DISTINCT department_id) > 5
)
SELECT DISTINCT user_id, order_id, dept_count
FROM orders_dept
ORDER BY dept_count DESC
LIMIT 100;

--Q18: Is there any difference in orders in Organic and Inorganic products?
WITH product_type AS (
  SELECT
    op.order_id,
    p.product_id,
    p.product_name,
    CASE WHEN p.product_name ILIKE '%organic%' THEN 'Organic' ELSE 'Inorganic' END AS product_type
  FROM products p
  JOIN order_products op ON p.product_id = op.product_id
)
SELECT
  product_type,
  COUNT(DISTINCT product_id) AS unique_products,
  COUNT(*) AS total_product_orders
FROM product_type
GROUP BY product_type
ORDER BY total_product_orders DESC;

-- Q19: Which Aiscles are most pouplar among frequent customers?
WITH customer_orders AS (
    SELECT user_id, COUNT(order_id) AS total_orders
    FROM orders
    GROUP BY user_id
    HAVING COUNT(order_id) > 50
)
SELECT 
    a.aisle,
    COUNT(op.product_id) AS total_orders_by_loyal_customers
FROM order_products op
JOIN orders o ON op.order_id = o.order_id
JOIN customer_orders c ON o.user_id = c.user_id
JOIN products p ON op.product_id = p.product_id
JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY total_orders_by_loyal_customers DESC
LIMIT 10;

-- Q20. What percentage of total orders does each aisle contribute?
SELECT 
    a.aisle,
    ROUND(100.0 * COUNT(op.product_id) / 
        (SELECT COUNT(*) FROM order_products), 2) AS percent_of_total_orders
FROM order_products op
JOIN products p ON op.product_id = p.product_id
JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY percent_of_total_orders DESC
LIMIT 10;








