# Music Store Analysis

## Overview
This SQL Music Store Analysis project explores customer behavior, sales trends, and genre preferences within a music store database. The analysis focuses on identifying key insights such as senior employees, top-selling countries, high-spending customers, and best-selling albums. By leveraging advanced SQL queries, the project uncovers customer spending patterns on artists, popular genres by country, and top customers, providing actionable insights to support strategic marketing and business decisions.

## Objective
- Analyze customer behavior and spending patterns
- Identify senior employees and their impact on sales
- Determine top-selling countries and market opportunities
- Highlight high-spending customers to target for promotions
- Discover best-selling albums and popular genres
- Explore customer spending habits by artist and genre
- Provide data-driven recommendations to enhance marketing strategies

## Dataset
The dataset includes multiple tables related to a music store’s operations:

<img width="594" alt="schema_diagram" src="https://github.com/user-attachments/assets/748d8171-7503-44b5-8946-20752dab48c3" />

- **Customers:** Contains customer demographic and contact information
- **Employees:** Details about employees, including hire dates
- **Invoices:** Records of sales transactions with dates and amounts
- **InvoiceLines:** Line items for each invoice, including album and track information
- **Albums:** Information about albums and their corresponding artists
- **Artists:** Artist details linked to albums
- **Tracks:** Individual track details, including genre
- **Genres:** Genre information for tracks

The dataset structure allows for deep exploration of sales, customer preferences, and employee performance.
## Functions Used

- `SELECT`
- `JOIN`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- Aggregate Functions: `SUM()`, `COUNT()`, `AVG()`, `ROUND()`
- Subqueries
- Common Table Expressions (CTE) - `WITH`
- Window Functions - `ROW_NUMBER() OVER()`
- Filtering Conditions - `WHERE`
- String Matching - `LIKE`
- `DISTINCT`

## Conclusion
This project provides valuable insights into the music store’s sales dynamics and customer preferences. By identifying top performers, customer segments, and popular products, the analysis equips stakeholders with the knowledge needed to optimize marketing efforts, improve customer engagement, and enhance overall business performance.
