DROP TABLE IF EXISTS SPOTIFY;

CREATE TABLE SPOTIFY (
	ARTIST VARCHAR(255),
	TRACK VARCHAR(255),
	ALBUM VARCHAR(255),
	ALBUM_TYPE VARCHAR(50),
	DANCEABILITY FLOAT,
	ENERGY FLOAT,
	LOUDNESS FLOAT,
	SPEECHINESS FLOAT,
	ACOUSTICNESS FLOAT,
	INSTRUMENTALNESS FLOAT,
	LIVENESS FLOAT,
	VALENCE FLOAT,
	TEMPO FLOAT,
	DURATION_MIN FLOAT,
	TITLE VARCHAR(255),
	CHANNEL VARCHAR(255),
	VIEWS FLOAT,
	LIKES BIGINT,
	COMMENTS BIGINT,
	LICENSED BOOLEAN,
	OFFICIAL_VIDEO BOOLEAN,
	STREAM BIGINT,
	ENERGY_LIVENESS FLOAT,
	MOST_PLAYED_ON VARCHAR(50)
);

SELECT
	*
FROM
	SPOTIFY;

-- ### Easy Level
-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	STREAM > 1000000000;

-- 2. List all albums along with their respective artists.
SELECT DISTINCT
	ALBUM,
	ALBUM
FROM
	SPOTIFY;

-- 3. Get the total number of comments for tracks where `licensed = TRUE`.
SELECT
	SUM(COMMENTS)
FROM
	SPOTIFY
WHERE
	LICENSED = 'TRUE';

-- 4. Find all tracks that belong to the album type `single`.
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	ALBUM_TYPE = 'single';

-- 5. Count the total number of tracks by each artist.
SELECT
	ARTIST,
	COUNT(TRACK)
FROM
	SPOTIFY
GROUP BY
	ARTIST
ORDER BY
	COUNT(TRACK) DESC;

-- ### Medium Level
-- 1. Calculate the average danceability of tracks in each album.
SELECT
	ALBUM,
	TRACK,
	AVG(DANCEABILITY)
FROM
	SPOTIFY
GROUP BY
	ALBUM,
	TRACK;

-- 2. Find the top 5 tracks with the highest energy values.
SELECT
	TRACK,
	ENERGY
FROM
	SPOTIFY
ORDER BY
	ENERGY DESC
LIMIT
	5;

-- 3. List all tracks along with their views and likes where `official_video = TRUE`.
SELECT
	TRACK,
	LIKES,
	VIEWS
FROM
	SPOTIFY
WHERE
	OFFICIAL_VIDEO = 'TRUE';

-- 4. For each album, calculate the total views of all associated tracks.
SELECT
	ALBUM,
	TRACK,
	SUM(VIEWS) AS VIEWS
FROM
	SPOTIFY
GROUP BY
	ALBUM,
	TRACK;

-- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.
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

-- ### Advanced Level
-- 1. Find the top 3 most-viewed tracks for each artist using window functions.
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

-- 2. Write a query to find tracks where the liveness score is above the average.
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

-- 3. Use a `WITH` clause to calculate the difference between the highest and lowest 
-- energy values for tracks in each album.
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