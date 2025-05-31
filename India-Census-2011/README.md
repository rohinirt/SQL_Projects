# Indian Census 2011 Analysis

## Overview
This project analyzes the Indian Census 2011 dataset to extract meaningful insights about the population, growth rates, sex ratios, literacy rates, and demographic distributions across states and districts in India. Using SQL queries, it explores various statistics such as total population, average growth, sex ratio, and literacy, helping understand regional disparities and demographic trends.

## Objective
- Determine total population and growth trends across states and districts
- Calculate average growth rate, sex ratio, and literacy rate for each state
- Identify districts with exceptional sex ratios and literacy rates
- Analyze the distribution of males and females in the population
- Compare populations between the previous and current census
- Calculate population density ratios relative to area
- List top-performing districts by literacy within each state
- Highlight states with highest and lowest demographic indicators

## Dataset
The analysis uses two primary datasets:
- **data1:** Contains demographic and socio-economic attributes for Indian districts, including growth rates, sex ratios, literacy, and area.
- **data2:** Contains population counts per district from the 2011 census.

The datasets are linked via the district name and state information to enable comprehensive analysis of census data.

## Conclusion
This analysis reveals critical demographic patterns such as population distribution, growth dynamics, literacy levels, and sex ratios across Indian states and districts. It highlights states with high literacy and growth rates as well as those with demographic challenges. The results can support policymakers and researchers in planning and implementing targeted development initiatives.

## Functions Used
- `SELECT`
- `JOIN`
- `GROUP BY`
- `ORDER BY`
- `LIMIT`
- Aggregate functions: `SUM()`, `AVG()`, `COUNT()`, `ROUND()`
- Subqueries
- Common Table Expressions (CTE) - `WITH`
- Window Functions - `ROW_NUMBER() OVER()`
- Filtering Conditions - `WHERE`
- String Matching - `LIKE`
- `DISTINCT`

