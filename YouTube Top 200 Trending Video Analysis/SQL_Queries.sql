CREATE TABLE trending_videos (
    video_id VARCHAR(50),
    title TEXT,
    description TEXT,
    published_at DATETIME,
    channel_id VARCHAR(50),
    channel_title VARCHAR(255),
    category_id INT,
    category TEXT,
    tags TEXT,
    duration VARCHAR(20),
    definition VARCHAR(10),
    caption BOOLEAN,
    view_count BIGINT,
    like_count BIGINT,
    dislike_count BIGINT,
    favorite_count BIGINT,
    comment_count BIGINT
);

-- 1)Count the total number of videos.
select count(*) As total_videos from trending_videos;

-- 2)List all distinct channel_title values.
select count(distinct channel_title) as channels 
from trending_videos;

-- 3)Find the top 10 most viewed videos.
select video_id, title, view_count 
from trending_videos
order by view_count desc 
limit 10;

-- 4)Count how many videos are in HD (definition='hd').
select count(video_id) as hd_videos 
from trending_videos
where definition = 'hd';

-- 5)Find the average like_count across all videos.
select round(avg(like_count),0) as avg_like_count
from trending_videos;

-- 6)Show all videos having caption
select title from trending_videos
where caption = 1;

-- 7)Get the top 5 channels by total view count.
select channel_title,view_count
from trending_videos
order by view_count desc
limit 5;

-- 8)Find the average view_count per category.
select category, avg(view_count)
from trending_videos
group by category;

-- 9)count videos where like_count is greater than comment_count.
select count(title) from trending_videos
where like_count>comment_count;

-- 10)Find the earliest published video in the dataset.
select title, published_at from trending_videos
order by published_at desc
limit 1;

-- 11)List channels that have more than 1 trending video.
select channel_title, count(title)
from trending_videos
group by channel_title
having count(title) >1;

-- 12)Get the average like-to-view ratio per category.
select category, 
round(sum(like_count)/sum(view_count),2)as like_to_view_ratio
from trending_videos
group by category;

-- 13)Find the video with the shortest title and the one with the longest title.
(select title, length(title) as title_length, 
'longest' as title_type
from trending_videos
order by length(title) desc
limit 1)
union all
(select title, length(title) as title_length,
 'shortest' as title_type
from trending_videos
order by length(title) asc
limit 1)
;

-- 14)Count the total number of videos in each definition type (HD vs SD).
select definition, count(title) as videos
from trending_videos
group by definition;

-- 15)Write a query to find videos whose view_count is 
-- greater than the average view count of their category.
select t. title,t.view_count,t.category, cat.avg_view_count from 
trending_videos t
join (
select category, avg(view_count) as avg_view_count
from trending_videos 
group by category) cat
on t.category = cat.category
where cat.avg_view_count <= t.view_count;


-- 16)Get the videos that never reached the top 10 in their category by view count.
with top_videos as
(select category, title, view_count,
rank() over (partition by category order by view_count desc) as rnk
from trending_videos)
select title from top_videos
where rnk > 10;


-- 16)Find the average likes per category for videos published in the last 30 days.
select category, avg(like_count) as avg_likes
from trending_videos
where published_at >= curdate() - INTERVAL 30 DAY
group by category;


-- 17)Get the average video duration in minutes per category.
select 
    category,
    ROUND(AVG((
        COALESCE(SUBSTRING_INDEX(SUBSTRING_INDEX(duration, 'H', 1), 'PT', -1), 0) * 3600 +
        COALESCE(SUBSTRING_INDEX(SUBSTRING_INDEX(duration, 'M', 1), 'T', -1), 0) * 60 +
        COALESCE(SUBSTRING_INDEX(SUBSTRING_INDEX(duration, 'S', 1), 'M', -1), 0)
    )/60),2)
    AS duration_minutes
FROM trending_videos
group by category;

-- 18)Classify videos as:

-- "Low" if view_count < 100000

-- "Medium" if 100000 ≤ view_count < 1000000

-- "High" if view_count ≥ 1000000. and count videos in each category

select CASE WHEN view_count < 100000 
				THEN 'Low'
			       WHEN view_count >= 100000 and view_count < 10000000
				THEN 'Medium'
				   ELSE 'High' 
				END AS Video_type,
		COUNT(*) as Video_count
from trending_videos
group by Video_type;


