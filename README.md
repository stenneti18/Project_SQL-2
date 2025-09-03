# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix Logo](

**Project Title**: Netflix 
**Database**: SQL_PROJECT_2

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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

```
## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type, COUNT(*) AS Total_Content
FROM Netflix
GROUP BY type;
```
**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```
**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT release_year, title
FROM Netflix
WHERE type = 'Movie' AND release_year = 2020;
```
**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT country, COUNT(*) AS total_content
FROM Netflix
GROUP BY country
ORDER BY total_content DESC
LIMIT 6;
```
**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT title, SPLIT_PART(duration, ' ', 1)::INT AS duration_value
FROM Netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY duration_value DESC
LIMIT 1;
```
**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT * FROM Netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT title, type
FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```
**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT * FROM Netflix
WHERE type ='TV Show' AND SPLIT_PART(duration, ' ', 1):: INT > 5;
```
**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(*) AS total_content 
FROM Netflix
GROUP BY genre;
```
**Objective:** Count the number of content items in each genre.

### 10.Find each year and the total numbers of content release by India on netflix. Return top 5 year with highest yearly content release!

```sql
SELECT release_year, COUNT(show_id) AS yearly_count
FROM Netflix
WHERE country ILIKE '%India%'
GROUP BY release_year
ORDER BY yearly_count DESC
LIMIT 5;
```
**Objective:** Calculate and rank years by the total number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT title
FROM Netflix
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';
```
**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * FROM Netflix 
WHERE director IS NULL;
```
**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT title, release_year
FROM Netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors, COUNT(show_id) AS no_of_movies
FROM Netflix
WHERE country ILIKE '%INDIA%'
AND type = 'Movie'
GROUP BY actors
ORDER BY no_of_movies DESC
LIMIT 10;
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```sql
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
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author - Santhosh Tenneti

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/santhoshtenneti/)

Thank you, and I look forward to connecting with you!
