-- 1. Write a query that returns a list of all the unique values in the 'country' field.
SELECT DISTINCT country
FROM ksprojects;

-- 2. How many unique values are there for the main_category field? What about for the category field?
SELECT COUNT(DISTINCT main_category) unique_main_categories, 
	COUNT(DISTINCT category) unique_category
FROM ksprojects; 

-- 3. Get a list of all the unique combinations of main_category and category fields, sorted A to Z 
-- by main_category.
SELECT DISTINCT k.main_category, category
FROM ksprojects k
GROUP BY k.main_category, k.category 
ORDER BY k.main_category;

-- 4. How many unique categories are in each main_category?
SELECT DISTINCT k.main_category, COUNT(category) count_categories
FROM ksprojects k
GROUP BY k.main_category
ORDER BY k.main_category;

-- 5. Write a query that returns the average number of backers per main_category, rounded 
-- to the nearest whole number and sorted from high to low.
SELECT k.main_category, ROUND(AVG(backers),0) avg_backers
FROM ksprojects k 
GROUP BY k.main_category
ORDER BY avg_backers DESC;

-- 6. Write a query that shows, for each category, how many campaigns were successful and 
-- the average difference per project between dollars pledged and the goal.
SELECT k.category, ROUND(AVG(k.usd_pledged - k.goal)::numeric,2) avg_successful
FROM ksprojects k
GROUP BY category
HAVING AVG(k.usd_pledged - k.goal)>0;

-- 7. Write a query that shows, for each main category, how many projects had zero backers 
-- for that category and the largest goal amount for that category (also for projects with zero backers).
SELECT k.main_category, COUNT(k.backers) zero_backers, MAX(k.goal) max_goal
FROM ksprojects k 
WHERE k.backers=0
GROUP BY k.main_category;

-- 8. For each category, find the average USD per backer, and return only those results 
-- for which the average USD per backer is < $50, sorted high to low.
SELECT k.category, ROUND(AVG(k.usd_pledged/k.backers)::numeric,2) avg_per_backer
FROM ksprojects k
WHERE k.backers>0
GROUP BY k.category
HAVING AVG(k.usd_pledged)>50
ORDER BY avg_per_backer DESC;

-- 9. Write a query that shows, for each main_category, how many successful projects 
-- had between 5 and 10 backers.
SELECT k.main_category, COUNT(k.category) count_successful_projects
FROM ksprojects k 
WHERE k.backers between 5 and 10
GROUP BY k.main_category
HAVING SUM(k.goal-k.usd_pledged)>0;

-- 10. Get a total of the amount ‘pledged’ for each type of currency grouped by its respective 
-- currency. Sort by ‘pledged’ from high to low.
SELECT k.currency, TRUNC(SUM(k.pledged)::numeric,2) total_pledged
FROM ksprojects k
GROUP BY k.currency 
ORDER BY total_pledged DESC;

-- 11. Excluding Games and Technology records in the main_category field, return the total of 
-- all backers for successful projects by main_category where the total was more than 100,000. 
-- Sort by main_category from A to Z.
SELECT k.main_category, TRUNC(SUM(k.pledged)::numeric,2) 
FROM ksprojects k
WHERE k.main_category NOT IN('Games','Technology')
GROUP BY k.main_category 
HAVING SUM(k.goal-k.pledged)>100000;
