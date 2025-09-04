# Superstore Sales Analysis 

## Overview  
This project focuses on analyzing sales data using SQL to extract meaningful business insights. Various queries were written to understand sales performance, customer behavior, shipping efficiency, and the relationship between discounts, sales, and profits. The analysis helps in identifying trends, best-performing products, customer segments, and operational bottlenecks.  

## Objective  
The main objectives of this project are:  
- To perform exploratory data analysis (EDA) using SQL.  
- To answer key business questions related to sales, profits, customers, and products.  
- To identify patterns and correlations that can guide decision-making.  
- To gain hands-on experience in writing efficient SQL queries for real-world datasets.  

## Dataset  
- **Table Used**: `sales`  
- **Sample Fields**:  
  - `Order_ID`, `Order_Date`, `Ship_Date`  
  - `Customer`, `Segment`, `Region`  
  - `Product`, `Category`, `Sub_Category`  
  - `City`, `State`  
  - `Sales`, `Quantity`, `Profit`, `Discount`, `Ship_Mode`  
The dataset resembles a transactional sales dataset, commonly used in retail/business intelligence analysis.  

## Functions and SQL Concepts Used  
The analysis leveraged a wide range of SQL functionalities:  

- **Aggregate Functions**: `SUM()`, `AVG()`, `COUNT()`, `ROUND()`, `MIN()`, `MAX()`  
- **Date Functions**: `DATE_FORMAT()`, `DATEDIFF()`  
- **Grouping & Ordering**: `GROUP BY`, `ORDER BY`, `LIMIT`  
- **String/Value Formatting**: Rounding values for readability  
- **Table Alteration & Update**: `ALTER TABLE`, `UPDATE` (for adding shipping duration)  
- **Correlation Calculation**: Manual formula for correlation coefficients  

## Key Analysis Performed  
- Total number of records in the dataset  
- Overall sales, profit, and quantity sold  
- Yearly and monthly order trends  
- Earliest and latest order dates  
- Top-performing cities, states, and regions  
- Best-selling products by sales and quantity  
- Profitability analysis by category, sub-category, and product  
- Customer analysis (top customers, most/least purchases)  
- Discount impact on profit, sales, and quantity  
- Shipping analysis (common modes, average shipping time, delayed shipments)  
- Segment-wise sales and profit distribution  
- Correlation analysis between sales, profit, quantity, and discount  

## Conclusion  
This SQL data analysis project provided valuable insights into sales performance, customer behavior, product profitability, and operational efficiency. The analysis revealed that a few cities, states, and products contribute significantly to overall sales, while profit margins vary across regions and categories, highlighting opportunities for targeted strategies.
