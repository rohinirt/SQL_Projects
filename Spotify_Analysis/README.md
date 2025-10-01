# Spotify Songs Analysis

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

## Project Structure
**1)Database Setup**: Creation of the Spotify_db databse and the required table
```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
### 2) Data Exploration
The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 3). Querying the Data
After the data is inserted, various SQL queries written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

## Business Problems
### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
``` sql
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	STREAM > 1000000000;
```
2. List all albums along with their respective artists.
``` sql
SELECT DISTINCT
	ALBUM,
	ALBUM
FROM
	SPOTIFY;
```
3. Get the total number of comments for tracks where `licensed = TRUE`.
``` sql
SELECT
	SUM(COMMENTS)
FROM
	SPOTIFY
WHERE
	LICENSED = 'TRUE';
```
4. Find all tracks that belong to the album type `single`.
``` sql
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	ALBUM_TYPE = 'single';
```
5. Count the total number of tracks by each artist.
``` sql
SELECT
	ARTIST,
	COUNT(TRACK)
FROM
	SPOTIFY
GROUP BY
	ARTIST
ORDER BY
	COUNT(TRACK) DESC;
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
``` sql
SELECT
	ALBUM,
	TRACK,
	AVG(DANCEABILITY)
FROM
	SPOTIFY
GROUP BY
	ALBUM,
	TRACK;
```
2. Find the top 5 tracks with the highest energy values.
``` sql
SELECT
	TRACK,
	ENERGY
FROM
	SPOTIFY
ORDER BY
	ENERGY DESC
LIMIT
	5;
```
3. List all tracks along with their views and likes where `official_video = TRUE`.
``` sql
SELECT
	TRACK,
	LIKES,
	VIEWS
FROM
	SPOTIFY
WHERE
	OFFICIAL_VIDEO = 'TRUE';
```
4. For each album, calculate the total views of all associated tracks.
``` sql
SELECT
	ALBUM,
	TRACK,
	SUM(VIEWS) AS VIEWS
FROM
	SPOTIFY
GROUP BY
	ALBUM,
	TRACK;
```
5. Retrieve the track names that have been streamed on Spotify more than YouTube.
``` sql
SELECT
	*
FROM
	(
		SELECT
			TRACK,
			COALESCE(
				SUM(
					CASE
						WHEN MOST_PLAYED_ON = 'Youtube' THEN STREAM
					END
				),
				0
			) AS STREAM_ON_YOUTUBE,
			COALESCE(
				SUM(
					CASE
						WHEN MOST_PLAYED_ON = 'Spotify' THEN STREAM
					END
				),
				0
			) AS STREAM_ON_SPOTIFY
		FROM
			SPOTIFY
		GROUP BY
			TRACK
	) AS STREAMS
WHERE
	STREAM_ON_SPOTIFY > STREAM_ON_YOUTUBE
	AND STREAM_ON_YOUTUBE <> 0;
```
### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
``` sql
WITH
	ORDERED_TRACKS AS (
		SELECT
			ARTIST,
			TRACK,
			DENSE_RANK() OVER (
				PARTITION BY
					ARTIST
				ORDER BY
					SUM(VIEWS)
			) AS RNK
		FROM
			SPOTIFY
		GROUP BY
			ARTIST,
			TRACK
	)
SELECT
	*
FROM
	ORDERED_TRACKS
WHERE
	RNK <= 3;
```
2. Write a query to find tracks where the liveness score is above the average.
``` sql
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	LIVENESS > (
		SELECT
			AVG(LIVENESS)
		FROM
			SPOTIFY
	);
```
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
``` sql
WITH
	H AS (
		SELECT
			ALBUM,
			MAX(ENERGY) AS HIGHEST
		FROM
			SPOTIFY
		GROUP BY
			ALBUM
	),
	L AS (
		SELECT
			ALBUM,
			MIN(ENERGY) AS LOWEST
		FROM
			SPOTIFY
		GROUP BY
			ALBUM
	)
SELECT
	H.ALBUM,
	H.HIGHEST - L.LOWEST
FROM
	H
	JOIN L ON H.ALBUM = L.ALBUM;
```


Here’s an updated section for your **Spotify Advanced SQL Project and Query Optimization** README, focusing on the query optimization task you performed. You can include the specific screenshots and graphs as described.

---

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4, PostgreSQL

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.

## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.

