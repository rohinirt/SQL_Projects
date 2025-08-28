create database pizzahut;
create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));

-- Basic:
-- 1)Retrieve the total number of orders placed.
select	count(order_id) as total_orders from orders;

-- 2)Calculate the total revenue generated from pizza sales.
select sum(o.quantity*p.price) as revenue
from order_details o
join pizzas p on p.pizza_id = o.pizza_id;

-- 3)Identify the highest-priced pizza.
select t.name from pizza_types t
join pizzas p 
on t.pizza_type_id = p.pizza_type_id
where p.price IN 
(select max(price) from pizzas);

-- 4)Identify the most common pizza size ordered.
select size as orders
from pizzas p join order_details o
on p.pizza_id = o.pizza_id
group by size
order by count(order_details_id) desc
limit 1;

-- 5)List the top 5 most ordered pizza types along with their quantities.
select t.name, SUM(quantity) as quantity
from pizza_types t join pizzas p
on t.pizza_type_id = p.pizza_type_id
join order_details o
on p.pizza_id = o.pizza_id
group by t.name
order by quantity desc limit 5;


-- Intermediate:
-- 1)Join the necessary tables to find the total quantity of each pizza category ordered.
select t.category, SUM(quantity) as quantity
from pizza_types t join pizzas p
on t.pizza_type_id = p.pizza_type_id
join order_details o
on p.pizza_id = o.pizza_id
group by t.category;

-- 2)Determine the distribution of orders by hour of the day.
select hour(order_time) as hour_of_the_day , count(d.order_id) as orders
from orders o join order_details d
on o.order_id = d.order_id
group by hour(order_time);

-- 3)Join relevant tables to find the category-wise distribution of pizzas.
select category, count(p.pizza_id) as pizzas
from pizza_types t join pizzas p
on t.pizza_type_id = p.pizza_type_id
group by category;

-- 4)Group the orders by date and calculate the average number of pizzas ordered per day.
with quant as 
(select order_date, sum(quantity) as quantity
from orders o join order_details d
on o.order_id = d.order_id
group by order_date)
select round(avg(quantity),0) as avg_quantity
from quant;


-- 5)Determine the top 3 most ordered pizza types based on revenue.
select name, round(sum(quantity*price),0) as revenue
from pizza_types t
join pizzas p on t.pizza_type_id = p.pizza_type_id
join order_details o 
on p.pizza_id = o.pizza_id
group by name
order by sum(quantity*price) desc
limit 3;


-- Advanced:
-- 1)Calculate the percentage contribution of each pizza type to total revenue.
select name, ROUND(100*sum(quantity*price)/
(select sum(quantity*price)
from order_details o
join pizzas p on o.pizza_id = p.pizza_id),2) as Revenue_contribution
from pizza_types t
join pizzas p on t.pizza_type_id = p.pizza_type_id
join order_details o 
on p.pizza_id = o.pizza_id
group by name; 

-- ***2)Analyze the cumulative revenue generated over time.
with total_rev as 
(select r.order_date,  round(sum(quantity*price),0)  as revenue
from pizza_types t
join pizzas p on t.pizza_type_id = p.pizza_type_id
join order_details o 
on p.pizza_id = o.pizza_id
join orders r
on o.order_id = r.order_id
group by r.order_date)
select order_date,revenue , 
sum(revenue) over(order by order_date) as cumm_revenue
from  total_rev;

-- 3)Determine the top 3 most ordered pizza types based on revenue for each pizza category.
with pizza_rank as
(select category, name, sum(quantity*price) as  revenue,
rank() over (partition by category order by sum(quantity*price) DESC) as ranks
from pizza_types t
join pizzas p on t.pizza_type_id = p.pizza_type_id
join order_details o 
on p.pizza_id = o.pizza_id
group by category, name)
select category, ranks, name, revenue
from pizza_rank
where ranks<=3;








