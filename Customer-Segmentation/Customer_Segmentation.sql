use data_analysis;
update ecom
set Dt_Customer = str_to_date(Dt_Customer,'%d-%m-%Y');

-- Customer Segmentation
-- 1. Retrieve the total number of customers in the dataset.
SELECT COUNT(DISTINCT ID) FROM ecom;

-- 2. List unique education levels present in the dataset.
select distinct Education,count(*) as Customers from ecom group by Education;

-- 3. Calculate the average income of customers.
select avg(Income) from ecom;

-- 4. Find the customer with the highest amount spent on clothes.
select ID as Customer_ID,A_Clothes as Amount_on_Clothes 
from ecom order by A_Clothes desc limit 1;

-- 5. Count the number of customers who made a complaint.
select count(*) as complains from ecom 
where Complain = 1;

-- 6. Identify the most common payment method used by customers.
select Payment_Method,count(*) as count
from ecom
group by Payment_Method
order by count desc limit 1;

-- 7. List the unique years of customer enrollment.
select distinct year(Dt_Customer) as Yr from ecom order by Yr;

-- 8.Retrieve the customer ID, education level, and income of top 5 customers who spent the most on furniture.
select ID,Education,Income, A_Furniture 
from ecom order by A_Furniture desc limit 5;


-- 9. Calculate the Recency,Frequency, and Monetary values for each customer (RFM analysis).
select ID,Recency,NumDealsPurchases+NumWebPurchases as Frequecy,
A_Clothes+A_Tech_Electronics+A_Books+A_Furniture+A_Foods+A_Cosmetics as Monetary
from ecom;

-- 10. Determine the percentage of customers who have churned.
select concat(ROUND((sum(Churns)/count(Churns))*100,2),'%') as
Cust_Churn_Percentage from ecom;

-- 11. Retrieve the top 5 customers with the highest overall spending.
select ID,A_Clothes+A_Tech_Electronics+A_Books+A_Furniture+A_Foods+A_Cosmetics
 as Overall_Spending from ecom
 order by Overall_Spending desc
 limit 5;
 
-- 12. Identify the most popular category (highest total spending) among customers.
select 'Clothes' as Category ,sum(A_Clothes) as Spending from ecom
union
select 'Tech_Electronics' as Tech_Electronics ,sum(A_Tech_Electronics) as Spending from ecom
union
select 'Books' as Books ,sum(A_Books) as Spending from ecom
union
select 'Furniture' as Furniture ,sum(A_Furniture) as Spending from ecom
union
select 'Foods' as Foods ,sum(A_Foods) as Spending from ecom
union
select 'Cosmetics' as Cosmetics ,sum(A_Cosmetics) as Spending from ecom
order by Spending desc
;

-- 13. Calculate the average satisfaction level for each education level.
SELECT 
    education_level,
    AVG(CASE 
            WHEN satisfaction_level = 'Unsatisfied' THEN 1
            WHEN satisfaction_level = 'Neutral' THEN 2
            WHEN satisfaction_level = 'Satisfied' THEN 3
            ELSE 0
        END) AS average_satisfaction_level
FROM 
    responses
GROUP BY 
    education_level;
SELECT Education,
    ROUND(AVG(CASE 
            WHEN Satisfaction_Level = 'Unsatisfied' THEN 1
            WHEN Satisfaction_Level = 'Neutral' THEN 2
            WHEN Satisfaction_Level = 'Satisfied' THEN 3
            ELSE 0
        END),2) AS average_satisfaction_level
FROM ecom GROUP BY Education;

-- 14. List customers who made purchases on more than three websites.
select ID from ecom where NumWebPurchases >=3;

-- 15. Perform a cohort analysis based on the year of customer enrollment.
select year(Dt_Customer) as Enrollment_Year,
month(Dt_Customer) as Enrollment_Month,
avg(A_Clothes+A_Tech_Electronics+A_Books+A_Furniture+A_Foods+A_Cosmetics) as Avg_monthly_Spending
from ecom 
group by Enrollment_Year, Enrollment_Month
order by Enrollment_Year, Enrollment_Month;

-- 16. Calculate the average time between purchases for each customer.


-- 17. Identify customers who have not made any purchases in the last six months.
select ID from ecom where Recency>6;

-- 18. Determine the correlation between the number of web visits and the amount spent on technology.
WITH CorrelationCalculation AS (
    SELECT
        AVG(NumWebVisitsMonth) AS AvgWebVisits,
        AVG(A_Tech_Electronics) AS AvgTechSpending,
        COUNT(*) AS N
    FROM
        ecom
)
SELECT
    SUM((NumWebVisitsMonth - AvgWebVisits) * (A_Tech_Electronics - AvgTechSpending)) /
    SQRT(SUM(POWER(NumWebVisitsMonth - AvgWebVisits, 2)) * SUM(POWER(A_Tech_Electronics - AvgTechSpending, 2))) AS PearsonCorrelation
FROM
    ecom, CorrelationCalculation;


-- 19. 
SELECT
	id,
    (A_Clothes+A_Tech_Electronics+A_Books+A_Furniture+A_Foods+A_Cosmetics) As Spending,
    YEAR(NOW())-YEAR(Dt_Customer) AS Lifetime_Years,
     ROUND(((A_Clothes+A_Tech_Electronics+A_Books+A_Furniture+A_Foods+A_Cosmetics) /
     (YEAR(NOW())-YEAR(Dt_Customer))),2) AS Revenue_per_Year
FROM ecom;
