-- What is the total number of records in dataset?
SELECT count(*) as Records FROM sales;

-- What is the overall total sales, quantity sold, and profit?
select sum(sales),sum(Quantity),sum(profit) from sales;

-- How many orders were placed in each year?
select count(distinct Order_ID) as Orders from sales;

-- What is the average sales per month?
select date_format(Order_Date,'%Y-%m') as Month,
round(avg(sales),0)as Average_Sales
from sales
group by Month
order by Month;

-- What is the earliest and latest order date in the dataset?
select min(Order_Date) as earliest_date,max(Order_Date) as latest_date from sales;

-- How many orders were placed in each year?
select date_format(Order_Date,'%Y')as Year,
count(distinct Order_ID) as Orders
from sales
group by Year
order by Year;

-- What are the top 5 cities with highest sales
select City,
ROUND(sum(Sales),1) as Total_Sales from sales
group by City
order by Total_Sales DESC
limit 5;

-- Which region has the highest avg profit margin?
Select Region,ROUND(avg(Profit),1) as Average_Profit
from sales
group by Region 
order by Average_Profit DESC
LIMIT 1;

-- Find the distribution of sales across different states
select State, ROUND(sum(sales),1) as Total_Sales
from sales
group by State;

-- Identify the top 10 best-selling products by quantity and sales.
Select Product,
Sum(Quantity) as Quantity
from sales
group by Product
order by Quantity DESC
LIMIT 10;
Select Product,
ROUND(Sum(Sales),0) as Sales
from sales
group by Product
order by Sales DESC
LIMIT 10;

-- What is the total sales and quantity sold for each product category and sub-category?
Select Category,Sub_Category,
Sum(Sales) as Total_Sales,
Sum(Quantity) as Total_Quantity from sales
Group by Category, Sub_Category;

-- Determine the products with the highest and lowest profit margins.
Select Product, ROUND(sum(Profit),2) as Profit 
from sales
group by Product
order by Profit desc
limit 1;
-- Minimum Profit
Select Product, ROUND(sum(Profit),2) as Profit 
from sales
group by Product
order by Profit Asc
limit 1;

-- Who are the top 10 customers based on total sales?
Select Customer, ROUND(sum(Sales),2) as Sales
from sales
group by Customer
order by Sales desc 
limit 10;

-- Identify the customers who made the most and least purchases.
select Customer, sum(quantity) as Most_Purchases from sales
group by Customer
order by Most_Purchases Desc
limit 1;
select Customer, sum(quantity) as Least_Purchases from sales
group by Customer
order by Least_Purchases asc
limit 1;

-- What is the average discount given to customers in each segment?
select Segment, ROUND(Avg(Discount),2)
from sales
group by Segment;

-- Find the most common shipping mode.
select Ship_Mode,count(*) as count 
from sales
group by Ship_Mode;

-- 6.2 Calculate the average shipping time (difference between order and ship dates).
select avg(datediff(Ship_Date, Order_Date)) as Shipping_Time from sales
where Order_Date is not null and Ship_Date is not null;

-- Identify any trends or patterns in delayed shipments.
-- Create new table
alter table sales
add column Duration int;
update sales 
set Duration = datediff(Ship_Date, Order_Date);

select Region, count(distinct Order_ID ) as orders_late from sales
where Duration > (select avg(datediff(Ship_Date, Order_Date)) from sales)
group by Region
order by orders_late desc;

-- Investigate the relationship between discounts and profit.
SELECT
Discount,ROUND(avg(Profit),0) as Profit
FROM sales
GROUP BY Discount;

-- Determine the impact of discounts on sales and quantity.
select Discount, ROUND(avg(Sales),2) as AVG_Sales,ROUND(avg(Quantity),2) as AVG_Quantity
from sales
group by Discount;

-- What is the distribution of sales and profit across different segments?
select Segment,
 round(sum(Sales),2) as Avg_sales,
 round(sum(Profit),2) as Avg_Profit
from sales
group by Segment;
   
-- Compare the average sales and profit for each segment.
select Segment,
 round(avg(Sales),2) as Avg_sales,
 round(avg(Profit),2) as Avg_Profit
from sales
group by Segment;


SELECT
    ROUND((COUNT(*) * SUM(Sales * Profit) - SUM(Sales) * SUM(Profit)) /
    (SQRT((COUNT(*) * SUM(Sales * Sales) - POW(SUM(Sales), 2)) *
          (COUNT(*) * SUM(Profit * Profit) - POW(SUM(Profit), 2)))),2) AS Sales_Profit_Correlation,
	ROUND((COUNT(*) * SUM(Quantity * Profit) - SUM(Quantity) * SUM(Profit)) /
    (SQRT((COUNT(*) * SUM(Quantity * Quantity) - POW(SUM(Quantity), 2)) *
          (COUNT(*) * SUM(Profit * Profit) - POW(SUM(Profit), 2)))),2) AS Quantity_Profit_Correlation,
	ROUND((COUNT(*) * SUM(Discount * Profit) - SUM(Discount) * SUM(Profit)) /
    (SQRT((COUNT(*) * SUM(Discount * Discount) - POW(SUM(Discount), 2)) *
          (COUNT(*) * SUM(Profit * Profit) - POW(SUM(Profit), 2)))),2) AS Discount_Profit_Correlation
FROM sales;







