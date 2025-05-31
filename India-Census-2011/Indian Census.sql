-- How many rows are there in the dataset in 'data1'?
SELECT COUNT(*) AS unique_records FROM data1;
-- How many rows are there in the dataset in 'data2'?
SELECT COUNT(*) AS unique_records FROM data2;
-- What is the population of India?
SELECT SUM(Population) FROM data2;

-- What is the average growth rate for each state?
SELECT state,ROUND(AVG(growth),2) AS 'avg_growth_%'
FROM data1
GROUP BY state
ORDER BY state;
-- What is the average sex ratio for each state?
SELECT state,ROUND(AVG(Sex_Ratio),2) AS 'avg_growth_%'
FROM data1
GROUP BY state
ORDER BY state;
-- What is the average literacy rate in each state?
SELECT state,ROUND(AVG(literacy),2) AS 'avg_literacy_%'
FROM data1
GROUP BY state
ORDER BY state;

-- How many districts have a sex ratio above 1000?
SELECT District,Sex_Ratio FROM data1
WHERE Sex_Ratio>1000
GROUP BY District,Sex_Ratio;

-- What is the maximum sex ratio recorded among all districts?
SELECT District,Sex_Ratio FROM data1
GROUP BY District,Sex_Ratio
ORDER BY Sex_Ratio DESC
LIMIT 1;

-- What are the states with an average literacy rate higher than 90%, 
-- and what are their average literacy rates?
SELECT State,ROUND(AVG(Literacy),2) AS Literacy
FROM data1
GROUP BY State
HAVING AVG(Literacy)>90;

-- What are the top 3 states with the highest growth ratio?
SELECT State,ROUND(CONCAT(AVG(Growth),'%'),2) as Growth
FROM data1
GROUP BY State
ORDER BY Growth DESC
LIMIT 3;

-- What are the bottom 3 states with the lowest sex ratio?
SELECT State,ROUND(CONCAT(AVG(Sex_Ratio),'%'),2) as Sex_Ratio
FROM data1
GROUP BY State
ORDER BY Growth ASC
LIMIT 3;

-- What are the top 3 states with the highest average literacy rates?
SELECT State,ROUND(AVG(Literacy),2) as Literacy
FROM data1
GROUP BY State
ORDER BY Literacy DESC
LIMIT 3;

-- What are the bottom 3 states with the lowest average literacy rates?
SELECT State,ROUND(AVG(Literacy),2) as Literacy
FROM data1
GROUP BY State
ORDER BY Literacy ASC
LIMIT 3;

-- What are the states starting with the letter 'A' or 'B'?
SELECT DISTINCT State 
FROM data1
WHERE State LIKE 'A%' OR 'B%';

-- What are the states starting with the letter 'A' and containing the letter 'M'?
SELECT DISTINCT State
FROM data1
WHERE State LIKE 'A%' AND State LIKE '%M%';

-- What is the total number of males and females
SELECT d1.State,
       d2.Population,
       d1.Sex_Ratio,
       ROUND(Population*1000 / (Sex_Ratio + 1000),0) AS Num_Males,
	   ROUND(Population*Sex_Ratio / (Sex_Ratio + 1000),0) AS Num_Females
FROM data1 d1
JOIN data2 d2
ON d1.District = d2.District;

-- Calculates the total number of literate and illiterate people for each state 
SELECT
    d1.State,d2.Population AS total_Popualtion,
    SUM(ROUND(d1.Literacy / 100 * d2.Population, 0)) AS total_literate_pop,
    SUM(ROUND((1 - d1.Literacy / 100) * d2.Population, 0)) AS total_illiterate_pop
FROM
   data1 d1
INNER JOIN
   data2 d2 ON d1.District = d2.District
GROUP BY
    d1.State,d2.Population;

-- What is the population in the previous census versus the current census
-- for each state?
SELECT d1.State, ROUND(SUM(d2.Population/(1+d1.Growth)),0) AS Previous_Cenusus_Population,
SUM(d2.Population) AS Current_Census_Population
FROM data1 d1 
JOIN data2 d2
ON d1.District = d2.District
GROUP BY State;

-- What is the population versus area ratio for both the previous and current census?
With CURR_PREV_RATIO
AS (SELECT d1.State,SUM(Area_km2) AS Area, 
ROUND(SUM(d2.Population/(1+d1.Growth)),0) AS Prev_Census_Pop,
SUM(d2.Population) AS Curr_Census_Pop
FROM data1 d1 
JOIN data2 d2
ON d1.District = d2.District
GROUP BY State)
SELECT State,
SUM(Curr_Census_Pop)/Area AS Curr_Ratio,
SUM(Prev_Census_Pop)/Area AS Prev_Ratio
FROM CURR_PREV_RATIO
GROUP BY State;

-- Output the top 3 districts from each state with the highest literacy rate.
WITH TOP_DIST AS 
(SELECT State, District,Literacy,
ROW_NUMBER() OVER(PARTITION BY State ORDER BY Literacy DESC) AS District_Rank
FROM data1)
SELECT State,District,Literacy,District_Rank
FROM TOP_DIST
WHERE District_Rank<=3
ORDER BY State ASC,Literacy DESC;


-- Which state has the highest average growth percentage?
SELECT State,AVG(Growth) AS Avg_Growth
FROM data1
GROUP BY State
ORDER BY Avg_Growth DESC 
LIMIT 1;






