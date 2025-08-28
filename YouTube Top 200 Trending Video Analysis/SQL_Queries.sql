UPDATE videos
SET Published_At = STR_TO_DATE(Published_At, '%d-%m-%Y');

-- 1)What are the top 5 keywords by average video views?
SELECT Keyword, ROUND(AVG(Views),0) AS avg_views
FROM videos
GROUP BY Keyword
ORDER BY avg_views DESC
LIMIT 5;

-- 2)Which videos have the highest like-to-view ratio, and what keywords do they use?
SELECT Video_ID, Title, ROUND(100*SUM(Likes)/SUM(Views),2) AS like_to_View_ratio
FROM videos
GROUP BY Video_ID, Title
ORDER BY like_to_View_ratio DESC
LIMIT 5;

-- 3)What is the average sentiment score for comments on videos published in the last 30 days?
SELECT AVG(Sentiment) AS Avg_Sentiment
FROM comments c
JOIN videos v
ON c.Video_ID = v.Video_ID
WHERE Published_At BETWEEN 
(SELECT MAX(Published_At) FROM videos)- INTERVAL 30 DAY 
AND (SELECT MAX(Published_At) FROM videos);

-- 4)Which keyword generates the most commented videos on average?
SELECT Keyword, SUM(Comments)/COUNT(DISTINCT Video_ID) AS Average_Comment_Per_Video
FROM videos
GROUP BY Keyword
ORDER BY Average_Comment_Per_Video DESC
LIMIT 10;

-- 5)Create a simple engagement score (views + likes + comments) and find top 10 videos?
SELECT Video_ID, SUM(Likes)+SUM(Views)+SUM(Comments) AS Engagement
FROM videos
GROUP BY Video_ID
ORDER BY Engagement DESC
LIMIT 10;


