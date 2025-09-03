-- NETFLIX PROJECT

CREATE TABLE Netflix
	(
		show_id VARCHAR(5),
		type VARCHAR(10),
		title VARCHAR(150),
		director VARCHAR(250),
		casts VARCHAR(1000),
		country VARCHAR(150),
		date_added VARCHAR(50),
		release_year INT,
		rating VARCHAR(10),
		duration VARCHAR(10),
		listed_in VARCHAR(100),
		description VARCHAR(250)
        );

SELECT * FROM Netflix;

-- 15 BUSINESS PROBLEMS AND THEIR SOLUTIONS:

-- 1. Count the number of Movies vs TV Shows.
SELECT type, COUNT(*) AS Total_Content
FROM Netflix
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows.
WITH RatingCounts AS (
    SELECT type, rating, COUNT(*) AS rating_count
    FROM Netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT type, rating, rating_count,
    RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT type, rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
SELECT release_year, title
FROM Netflix
WHERE type = 'Movie' AND release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix.
SELECT country, COUNT(*) AS total_content
FROM Netflix
GROUP BY country
ORDER BY total_content DESC
LIMIT 6;

-- 5. Identify the longest movie.
SELECT title, SPLIT_PART(duration, ' ', 1)::INT AS duration_value
FROM Netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY duration_value DESC
LIMIT 1;

-- 6. Find content added in the last 5 years.
SELECT * FROM Netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT title, type
FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons.
SELECT * FROM Netflix
WHERE type ='TV Show' AND SPLIT_PART(duration, ' ', 1):: INT > 5;

-- 9. Count the number of content items in each genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(*) AS total_content 
FROM Netflix
GROUP BY genre;

-- 10. Find each year and the total numbers of content release by India on netflix. Return top 5 year with highest yearly content release!
SELECT release_year, COUNT(show_id) AS yearly_count
FROM Netflix
WHERE country ILIKE '%India%'
GROUP BY release_year
ORDER BY yearly_count DESC
LIMIT 5;

-- 11.List all movies that are documentaries. 
SELECT title
FROM Netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';

-- 12. Find all content without a director.
SELECT * FROM Netflix 
WHERE director IS NULL;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT title, release_year
FROM Netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors, COUNT(show_id) AS no_of_movies
FROM Netflix
WHERE country ILIKE '%INDIA%'
AND type = 'Movie'
GROUP BY actors
ORDER BY no_of_movies DESC
LIMIT 10;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT category, COUNT(*)
FROM 
(
	SELECT *, 
	CASE
		WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
		ELSE 'Good'
	END AS category
	FROM Netflix
)t
GROUP BY category;
	
