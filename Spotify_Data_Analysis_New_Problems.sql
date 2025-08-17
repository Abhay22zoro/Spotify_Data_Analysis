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

SELECT * FROM spotify LIMIT 5;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;

--Data Analysis Business problems
-----------------------------------------

---Q1. Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify
where stream > 1000000000;

---Q2. List all albums along with their respective artists.

select distinct album, artist from spotify;

---Q3. Get the total number of comments for tracks where licensed = TRUE.

select sum(comments) from spotify
where licensed = 'true'

---Q4. Find all tracks that belong to the album type single.

select * from spotify
where album_type = 'single'

---Q5. Count the total number of tracks by each artist.

select artist, count(*) from spotify
group by 1
order by 2 desc;

---Q6. calculate the average danceability of tracks in each album.

select
album,
avg(danceability)
from spotify
group by 1
order by 2 desc;

---Q7. Find the top 5 tracks with the highest energy values.

select
track,
energy
from spotify
order by 2 desc
limit 5;

---Q8. List all tracks along with their views and likes where official_video = TRUE.

select 
track,
sum(views) as total_views,
sum(likes) as total_likes
from spotify
where official_video = 'true'
group by 1
order by 2 desc;

---Q9. For each album, calculate the total views of all associated tracks.

select
distinct album,
sum(views) as total_views
from spotify
group by 1
order by 2 desc;

---Q10. Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from 
(
select track,
coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_yt,
coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1   
) as t1
where streamed_on_spotify > streamed_on_yt and streamed_on_yt != 0;


---Q11. Find the top 3 most—viewed tracks for each artist using window functions.

with ranking_artist
as
(
select
artist,
track,
sum(views),
dense_rank() over(partition by artist order by sum(views) desc) as rank
from spotify
group by 1, 2
order by 1, 3 desc
)
select * from ranking_artist
where rank <= 3;

---Q12. Write a query to find tracks where the liveness score is above the average.

select
track,
artist,
liveness
from spotify
where liveness > (select avg(liveness) from spotify);

--- Q13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

with cte
as
(
select
album,
max(energy) as highest_energy,
min(energy) as lowest_energy
from spotify
group by 1
)
select
album,
(highest_energy - lowest_energy) as difference
from cte
order by 2 desc;

---Q14. Find tracks where the energy—to—liveness ratio is greater than 1.2.

select 
track,
energy / liveness AS energy_to_liveness_ratio
from Spotify 
where energy / liveness > 1.2;

---Q15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

select 
track,
views,
likes,
sum(likes) over(order by views desc) AS cumulative_likes
from spotify;




