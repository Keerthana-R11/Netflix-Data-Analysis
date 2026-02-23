select * from netflix_data ;

-- 1) Write a query to retrieve all Movie titles with a 'PG-13' rating that were released after 2010. 

select title from netflix_data 
where type = 'Movie' 
and rating = 'PG-13'
and release_year >2010 ;
      
-- 2)Find all TV Show entries added to Netflix in 2020 that are produced in the United States. 

select title from netflix_data
where type='TV Show'
and extract(Year from Netflix_date_added) = 2020
and country = 'United States' ;

-- 3) List all titles (movies or TV shows) with a duration over 100 minutes.

select title from netflix_data
where type in ('TV Show','Movie')
and duration > 100;

-- 4)Use GROUP BY on the type column to see how many Movies and TV Shows there are.

select type, count(*) as total_count
from netflix_data
group by type ;

-- 5)Aggregate titles by release_year to find how many were released each year

select release_year, count(title) as total_titles
from netflix_data
group by release_year
order by release_year ;

-- 6)Group by the rating column to see the distribution of content ratings.

select rating, count(*) as num_totles
from netflix_data
group by rating
order by num_totles desc;

-- 7)Group by the country column to find how many titles come from each country. 

select country,count(title) as country_total
from netflix_data
group by country
order by country_total desc ;

-- 8)Use a window function to rank titles by duration within each content type.

select title, type, duration,
rank() over(partition by type order by duration desc) as duration_rank
from netflix_data ;

-- 9)Find the top 3 longest titles for each type using a window function.

SELECT title, type, duration
FROM (SELECT title,type,duration,
RANK() OVER (PARTITION BY type ORDER BY duration DESC) AS rnk
FROM netflix_data

) AS ranked
WHERE rnk <= 3
ORDER BY type, rnk;

-- 10)Use a window function on aggregated data to rank countries by their number of titles.

SELECT country,COUNT(title) AS total_titles,
RANK() OVER (ORDER BY COUNT(title) DESC) AS country_rank
FROM netflix_data
GROUP BY country
ORDER BY country_rank;

-- 11)Use a CTE to count how many titles each director has, then select directors with more than 5 titles.

WITH director_counts AS (SELECT director,COUNT(title) AS total_titles
FROM netflix_data
GROUP BY director)
SELECT director,total_titles
FROM director_counts
WHERE total_titles > 5
ORDER BY total_titles DESC;

-- 12)Use a CTE to isolate TV shows, then group by year.

WITH tv_shows AS (SELECT *FROM netflix_data
WHERE type = 'TV Show')
SELECT release_year,COUNT(*) AS total_shows
FROM tv_shows
GROUP BY release_year
ORDER BY release_year;

-- 13)Use a CTE to calculate average duration per type, then find which movies exceed their type’s average.

WITH avg_duration AS (SELECT type,AVG(duration) AS avg_duration
FROM netflix_data
GROUP BY type)
SELECT n.title,n.type,n.duration,a.avg_duration
FROM netflix_data AS n
JOIN avg_duration AS a
ON n.type = a.type
WHERE n.duration > a.avg_duration
ORDER BY n.type, n.duration DESC;

