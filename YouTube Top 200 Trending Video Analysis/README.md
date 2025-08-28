# YouTube Top 200 Trending Videos Analysis Project

## 📖 Project Overview
This project demonstrates an end-to-end data pipeline for analyzing YouTube's top 200 trending videos. It involves collecting real-time data using YouTube's API, storing it in a MySQL database, and performing comprehensive analysis to uncover insights about video performance, content categories, and viewer engagement patterns. The goal is to understand what makes videos trend in India.

## 🎯 Business & Analytical Objectives
The project aims to answer key questions that are crucial for content creators, marketers, and platform analysts:

- **Performance Analysis:** Which videos and channels are performing best in terms of views and engagement?  
- **Content Strategy:** What types of content (categories) are most popular and have the highest engagement rates?  
- **Technical Insights:** How do video qualities (HD vs. SD) and features (captions) impact viewership?  
- **Audience Behavior:** What is the relationship between likes, comments, and views?  
- **Content Optimization:** What are the characteristics of top-performing videos in each category?  

## 🛠️ Technical Skills Demonstrated
- **API Integration:** Using Google's YouTube Data API v3 to fetch real-time data.  
- **Python Programming:** Data collection, cleaning, and preprocessing with pandas and google-api-python-client.  
- **Database Management:** Designing a SQL table schema and performing ETL (Extract, Transform, Load) operations into MySQL.  
- **SQL Analysis:** Writing complex SQL queries including aggregations, joins, CTEs, window functions, and conditional logic.  
- **Data Analysis:** Deriving actionable insights from raw data to answer business questions.  

## 📊 Dataset Description
The dataset contains **200 trending videos** from the Indian region (`regionCode='IN'`), collected via the YouTube API. Each record includes:

- **Identifiers:** video_id, channel_id, channel_title  
- **Content Details:** title, description, tags, category_id, category_name  
- **Metadata:** published_at, duration, definition (HD/SD), caption (boolean)  
- **Engagement Metrics:** view_count, like_count, dislike_count, favorite_count, comment_count  

## 🔄 Project Workflow (Step-by-Step)

### **1. Data Collection (Youtube_data_collection.ipynb)**
- Set up a project in the Google Cloud Console and obtained an API key.  
- Used the `googleapiclient.discovery` library to build a service object for the YouTube API.  
- Fetched video category mappings for accurate categorization.  
- Called the `videos().list()` method with the `chart='mostPopular'` parameter to retrieve trending videos.  
- Extracted and structured the relevant JSON response into a list of dictionaries.  
- Handled pagination to collect up to **200 videos**.  

### **2. Data Preprocessing & Storage**
- Loaded the collected data into a pandas DataFrame for cleaning and exploration.  
- Handled missing values in the description field.  
- Converted the `published_at` string to a DateTime object for time-based analysis.  
- Established a connection to a local MySQL database using `mysql.connector`.  
- Designed and created the `trending_videos` table with an appropriate schema.  
- Executed an `INSERT` statement for each row to transfer the data from Python to the MySQL database.  

### **3. Data Analysis (SQL Queries)**
Performed a multi-faceted analysis using SQL, which can be categorized as follows:

#### **A. Basic Metrics & Overview**
- Total video and distinct channel counts.  
- Videos with HD quality and captions.  
- Average engagement metrics (likes, views).  

#### **B. Top-Performance Analysis**
- Identified the top **10 most viewed videos** and **top 5 channels**.  
- Found the earliest published video in the dataset.  

#### **C. Category-Level Insights**
- Calculated average views and average like-to-view ratio for each category.  
- Helps identify which genres are not just popular but also have highly engaged audiences.  

#### **D. Advanced SQL Techniques**
- **Subqueries & Joins:** To find videos performing above the average view count of their category.  
- **Common Table Expressions (CTEs) & Window Functions:** Used `RANK()` to identify videos that never reached the top 10 in their category, showcasing mastery over advanced analytical functions.  
- **Complex Conditional Logic:** Used a `CASE` statement to classify videos into Low, Medium, and High viewership tiers and then aggregated them.  
- **String Manipulation:** Parsed the ISO 8601 duration field (e.g., `PT2H22M16S`) to calculate average video length per category in minutes—a non-trivial task that demonstrates problem-solving skills.  

## 📈 Key Insights
- **Most Popular Category:** Music 
- **Engagement vs. Views:** People and Blogs has the highest like-to-view ratio  
- **Content Volume:** No channel has more than 1 trending videos in top 200 
- **Video Quality:** A significant majority of trending videos are in HD, highlighting production quality's importance.  

## 📝 Conclusion
This project successfully demonstrates the entire data analysis lifecycle, from collecting raw data from a live API to storing it and performing analysis. The SQL queries go beyond simple filters and aggregates, utilizing advanced techniques to derive meaningful insights that can directly inform content strategy and platform understanding. It showcases strong technical proficiency in Python, SQL, and data manipulation, making it a valuable asset for any data analytics portfolio.

