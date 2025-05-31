-- SET  1

ALTER TABLE trans
ADD COLUMN date_col DATE,
ADD COLUMN time_col TIME;

UPDATE trans
SET date_col = STR_TO_DATE(SUBSTRING_INDEX(t_date, ' ', 1), '%Y-%m-%d'),
    time_col = SUBSTRING_INDEX(t_date, ' ', -1);
ALTER TABLE trans
CHANGE COLUMN time_col trans_time time;
CHANGE COLUMN date_col trans_date date;
ALTER TABLE trans DROP  t_date;

SELECT * FROM trans;


-- 1.For each card, calculate the total transaction amount for each month.
SELECT card,MONTHNAME(trans_date) as 'Month', ROUND(SUM(amount),2) AS Amount
FROM trans
GROUP BY card, MONTHNAME(trans_date);

-- 2. Determine the 90th percentile of transaction amounts for each cardholder.


-- 3. Determine if cardholders have different spending patterns on weekdays compared to weekends.
-- 4. Assign RFM scores to cardholders based on their recency, frequency, and monetary values.
-- 5. Calculate the running total of transaction amounts for each card, ordered by date.
-- 6. Find transactions where the amount is more than two standard deviations away from the mean for each card.
-- 7. Identify transactions that occurred outside regular business hours for each cardholder.
-- 8. List cardholders who made transactions at merchants they haven't visited in the last month.
-- 9. List the top 5 cardholders with the highest standard deviation in transaction amounts.
-- 10. Find instances where a card is used for multiple transactions within an hour.
-- 11. Find transactions where a single card is used at multiple merchants within a 30-minute window.
-- 12. Calculate the average number of transactions per day for each cardholder.
-- 13. For each cardholder, calculate the percentage change in the total transaction amount from the previous month.
-- 14. Identify transactions where the time between consecutive transactions is significantly different from the average time difference for each cardholder.
-- 15. Identify the transactions with the highest frequency per day.
-- 16. Identify cardholders with a significant increase or decrease in the total transaction amount compared to the previous month.
-- 17. Identify groups of cardholders with interconnected transactions and calculate the average number of connections for each cardholder.
-- 18. List the top 3 merchants where a small number of cardholders contribute to the largest percentage of total transactions.
-- 19. For each card, calculate the percentage of the total transaction amount represented by each individual transaction.
-- 20. Identify merchants whose total transaction amounts have increased the most over the past month.
-- 21. Calculate the time difference between consecutive transactions for each cardholder and identify instances where the time difference is less than the 10th percentile.

-- SET 2 
-- 1. What is the total number of transactions in the dataset?
SELECT COUNT(id) as Total_Transaction FROM trans;

-- 2. What is the average transaction amount?
SELECT ROUND(AVG(amount),2) as Avg_Transaction FROM trans;

-- 3. How many unique card holders are there in the dataset?
SELECT COUNT(id_card_holder) as Unique_Card_Holders FROM card_holder;

-- 4. What is the total amount spent by each card holder?
SELECT H.holder_name as Holder,ROUND(SUM(T.amount),0) as Amount
FROM credit_card C
JOIN trans T ON C.card = T.card
JOIN card_holder H on C.id_card_holder= H.id_card_holder
GROUP BY Holder
ORDER BY Amount DESC;

-- 5. Identify the top 5 merchants with the highest transaction amounts.
SELECT merchant_name as Merchant, ROUND(SUM(amount),0) as Amount
FROM merchant M
JOIN  trans T on M.id_merchant = T.id_merchant
GROUP BY merchant_name
ORDER BY Amount DESC LIMIT 5;

-- 6. What is the average transaction amount for each merchant category?
SELECT MC.category_name as Category,ROUND(AVG(T.amount),2) as Amount 
FROM merchant M
JOIN trans T on M.id_merchant = T.id_merchant
JOIN merchant_category MC ON M.id_merchant_category = MC.id_merchant_category
GROUP BY MC.category_name
ORDER BY Amount DESC;


-- 7. Find the day with the highest total transaction amount.
SELECT DATE(trans_date) AS 'Day',ROUND(SUM(amount),0) AS Amount
FROM trans 
GROUP BY DATE(trans_date)
ORDER BY Amount DESC 
LIMIT 1;

-- 8. Calculate the average transaction amount per day.
SELECT DATE(trans_date) AS 'Day',ROUND(AVG(amount),0) AS Amount
FROM trans 
GROUP BY DATE(trans_date)
ORDER BY DATE(trans_date) DESC; 

/* 9.Identify transactions where the amount is 
significantly higher than the average amount for that card holder.*/
SELECT T.ID, C.card, H.holder_name, T.amount,
(SELECT ROUND(AVG(T2.amount),2)
FROM trans T2
JOIN credit_card C2 ON T2.card = C2.card
WHERE C2.id_card_holder = H.id_card_holder) AS Average_Amount
FROM credit_card C
JOIN trans T ON C.card = T.card
JOIN card_holder H ON C.id_card_holder = H.id_card_holder
HAVING T.amount > Average_Amount;


/*10.Detect any transactions with the same amount and 
occurring on the same day for a single card*/
SELECT t1.id AS transaction_id_1, t1.amount AS amount_1, t1.trans_date AS date_1,
       t2.id AS transaction_id_2, t2.amount AS amount_2, t2.trans_date AS date_2,
       c.card AS card_number,id_card_holder
FROM trans t1
JOIN trans t2 ON t1.card = t2.card
JOIN credit_card c ON t1.card = c.card
WHERE t1.id <> t2.id -- Exclude comparing the same transaction
AND DATE(t1.trans_date) = DATE(t2.trans_date)
AND t1.card = t2.card
AND t1.amount = t2.amount
ORDER BY t1.trans_date;

-- 11. Identify merchants with the highest number of transactions.
SELECT M.merchant_name, count(id) as Transactions
FROM merchant M
JOIN trans T ON M.id_merchant = T.id_merchant
GROUP BY M.merchant_name
ORDER BY Transactions DESC;

-- 12. Calculate the average transaction amount for each card holder's name.
SELECT holder_name,ROUND(AVG(amount),2) as Amount
FROM card_holder h
JOIN (SELECT id_card_holder,c.card,t.amount 
FROM credit_card c JOIN trans t ON  c.card = t.card) AS T
ON h.id_card_holder = T.id_card_holder
GROUP BY holder_name 
ORDER BY Amount DESC;



-- 13. Find the top 10 card holders with the highest total transaction amounts.
SELECT holder_name,ROUND(SUM(amount),2) as Amount
FROM card_holder h
JOIN (SELECT id_card_holder,c.card,t.amount 
FROM credit_card c JOIN trans t ON  c.card = t.card) AS T
ON h.id_card_holder = T.id_card_holder
GROUP BY holder_name 
ORDER BY Amount DESC;

-- 14. Identify any transactions with amounts that deviate significantly from the average amount for that merchant.
SELECT m.id_merchant, 
       m.merchant_name, 
       t.id AS transaction_id,
       t.amount AS transaction_amount,
       AVG(t.amount) AS average_amount,
       ABS(t.amount - AVG(t.amount)) AS deviation -- ABS for Absolute deviation
FROM merchant m
JOIN trans t ON m.id_merchant = t.id_merchant
GROUP BY m.id_merchant, m.merchant_name, t.id, t.amount
HAVING ABS(t.amount - AVG(t.amount)) > (SELECT STDDEV_POP(amount) * 2 FROM trans)
ORDER BY m.id_merchant, deviation DESC;

-- 15. Detect any transactions where the card holder's name does not match the provided card information.
SELECT t.id, t.card, ch.holder_name
FROM trans t
JOIN credit_card cc ON t.card = cc.card
JOIN card_holder ch ON cc.id_card_holder = ch.id_card_holder
WHERE t.card NOT IN (SELECT card FROM credit_card 
WHERE id_card_holder = ch.id_card_holder);

-- 16. Find the merchant categories with the highest total transaction amounts.
SELECT category_name,ROUND(SUM(amount),2) AS Amount
FROM merchant_category c
JOIN merchant m ON c.id_merchant_category = m.id_merchant_category
JOIN trans t ON m.id_merchant = t.id_merchant
GROUP BY category_name
ORDER BY Amount DESC;


-- 17. Identify any anomalies in transaction amounts using window functions.
WITH TransactionStats AS (
    SELECT
        amount,
        AVG(amount) OVER () AS mean_amount,
        STDDEV(amount) OVER () AS stddev_amount
    FROM trans
)

SELECT
    t.id,
    t.amount,
    ts.mean_amount,
    ts.stddev_amount,
    ABS(t.amount - ts.mean_amount) AS deviation_from_mean,
    CASE
        WHEN ABS(t.amount - ts.mean_amount) >ts.stddev_amount THEN 'Anomaly'
        ELSE 'Normal'
    END AS anomaly_status
FROM
    trans t
JOIN TransactionStats ts ON true;

/*18. Identify merchants that have a high frequency of 
transactions within a short time frame*/
SELECT
    m.id_merchant,
    m.merchant_name,
    DATE(t.trans_date) AS transaction_date,
    COUNT(t.id) AS transaction_count
FROM
    trans t
JOIN
    merchant m ON t.id_merchant = m.id_merchant
GROUP BY
    m.id_merchant,
    m.merchant_name,
    DATE(t.trans_date)
HAVING
    COUNT(t.id) > (
        SELECT
            AVG(transaction_count) + STDDEV(transaction_count)
        FROM (
            SELECT
                COUNT(id) AS transaction_count
            FROM
                trans
            GROUP BY
                id_merchant, 
                DATE(trans_date)  -- Grouping by date to calculate transactions per day
        ) AS daily_transaction_counts
    );


/* 20. Find transactions where the card holder has made 
purchases from multiple merchants in a single day.*/
SELECT
    t.id AS transaction_id,
    t.trans_date AS transaction_date,
    t.card AS card_number,
    ch.id_card_holder AS card_holder_id,
    ch.holder_name AS card_holder_name,
    COUNT(DISTINCT m.id_merchant) AS num_unique_merchants
FROM
    trans t
JOIN
    credit_card cc ON t.card = cc.card
JOIN
    card_holder ch ON cc.id_card_holder = ch.id_card_holder
JOIN
    merchant m ON t.id_merchant = m.id_merchant
GROUP BY
    t.id,
    t.trans_date,
    t.card,
    ch.id_card_holder,
    ch.holder_name;
HAVING
    COUNT(DISTINCT m.id_merchant) > 1;







