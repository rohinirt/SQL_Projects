# 📖 Project Overview
This project involves a comprehensive analysis of **Pizza Hut's sales data** using **SQL**.  
The goal was to dive deep into the data to extract meaningful insights about sales performance, popular menu items, customer ordering patterns, and revenue trends.  
This analysis demonstrates core data analysis skills, from basic data retrieval to advanced window functions, which are essential for making data-driven business decisions.

---

## 🎯 Business Problem
For a business like **Pizza Hut**, understanding key metrics is vital for:

- Identifying best-selling products to optimize inventory and marketing.  
- Understanding revenue patterns to drive profitability.  
- Analyzing customer behavior to improve service and operational efficiency.  

This project answers these questions through **structured SQL queries**.

---

## 🛠 Tech Stack
- **Database:** MySQL  
- **Tools:** MySQL Workbench  

---

## 🗄️ Database Schema
The analysis is based on a relational database with four key tables:

| **Table** | **Description** |
|------------|-----------------|
| **orders** | Contains order details (`order_id`, `order_date`, `order_time`). |
| **order_details** | Records the pizzas and quantities for each order (`order_details_id`, `order_id`, `pizza_id`, `quantity`). |
| **pizzas** | Holds pizza information including size and price (`pizza_id`, `pizza_type_id`, `size`, `price`). |
| **pizza_types** | Describes the pizza category and name (`pizza_type_id`, `name`, `category`, `ingredients`). |

---

## 🔍 Key Analysis & Insights

### **1. Basic Performance Metrics**
- **Total Orders:** 21,350 orders were placed.  
- **Total Revenue:** Generated over **44k** from pizza sales.  
- **Menu Analysis:** The **Greek Pizza** was identified as the highest-priced pizza, and **Large** was the most commonly ordered size.  
- **Top Products:** The **Thai Chicken Pizza** was the top-selling pizza by quantity.

---

### **2. Category and Time Analysis**
- **Category Performance:** Classic pizzas were the most ordered category, significantly leading in volume.  
- **Peak Order Times:** The busiest hours were in the afternoon and evening (**12-13 PM** and **17-19 PM**), providing clear guidance for optimal staffing schedules.

---

### **3. Advanced Revenue Analytics**
- **Revenue Contribution:** The **Thai Chicken Pizza** contributed the highest percentage (**over 3.8%**) to total revenue.  
- **Cumulative Revenue Growth:** Utilized a **window function** to track cumulative revenue over time, visualizing the business's daily earnings trajectory.  
- **Category Leaders:** For each pizza category (e.g., **Classic**, **Veggie**, **Supreme**), the top 3 pizzas by revenue were identified, crucial for category management and promotional strategies.

---

## 🛠️ Technical Skills Demonstrated
This project showcases a strong command of **SQL**, including:

- **Data Definition Language (DDL):** `CREATE DATABASE`, `CREATE TABLE`  
- **Data Query Language (DQL):** `SELECT`, `FROM`, `WHERE`  
- **Joins:** `INNER JOIN` to combine data from multiple tables  
- **Aggregation Functions:** `COUNT()`, `SUM()`, `MAX()`, `AVG()`  
- **Grouping and Sorting:** `GROUP BY`, `ORDER BY`, `LIMIT`  
- **Subqueries:** Using subqueries within `WHERE` and `SELECT` clauses  
- **Common Table Expressions (CTEs):** Using `WITH` clauses for organizing complex queries  
- **Window Functions:** `RANK()` for ranking items within categories and `SUM() OVER()` for calculating running totals (cumulative revenue)  
- **Mathematical Operations:** Calculating percentages and revenues dynamically  

---

## 📝 Conclusion
This project successfully translates **raw sales data** into **actionable business intelligence**.  
The insights gained can directly inform decisions related to:

- **Inventory Management:** Stocking ingredients for best-selling pizzas.  
- **Marketing Strategies:** Promoting high-revenue and popular items.  
- **Staff Scheduling:** Aligning workforce with predicted peak order times.  
- **Menu Optimization:** Identifying underperforming items or categories for review.
