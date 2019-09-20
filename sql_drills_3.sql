-- 2. Write a query that returns the namefirst and namelast fields of the people table, along with the 
-- inducted field from the hof_inducted table. All rows from the people table should be returned, and NULL 
-- values for the fields from hof_inducted should be returned when there is no match found.
SELECT people.namefirst, people.namelast, hof_inducted.inducted 
FROM people 
LEFT JOIN hof_inducted 
ON people.playerid = hof_inducted.playerid;

-- 3. In 2006, a special Baseball Hall of Fame induction was conducted for players from the negro baseball 
-- leagues of the 20th century. In that induction, 17 players were posthumously inducted into the Baseball Hall of 
-- Fame. Write a query that returns the first and last names, birth and death dates, and birth countries for these 
-- players. Note that the year of induction was 2006, and the value for votedby will be “Negro League.”
SELECT people.namefirst, people.namelast, 
	people.birthyear, people.deathyear, 
	people.birthcountry
FROM people
INNER JOIN hof_inducted 
ON people.playerid = hof_inducted.playerid 
WHERE hof_inducted.yearid = 2006 
	AND hof_inducted.votedby = 'Negro League';
	
-- 4. Write a query that returns the yearid, playerid, teamid, and salary fields from the salaries table, along 
-- with the category field from the hof_inducted table. Keep only the records that are in both salaries and 
-- hof_inducted. Hint: While a field named yearid is found in both tables, don’t JOIN by it. You must, however, explicitly 
-- name which field to include.
SELECT salaries.yearid, salaries.playerid, salaries.teamid, 
	salaries.salary
FROM salaries 
INNER JOIN hof_inducted 
ON salaries.playerid = hof_inducted.playerid;

-- 5. Write a query that returns the playerid, yearid, teamid, lgid, and salary fields from the 
-- salaries table and the inducted field from the hof_inducted table. Keep all records from both tables.
SELECT salaries.playerid, salaries.yearid, salaries.teamid, 
	salaries.lgid, salaries.salary, hof_inducted.inducted
FROM salaries 
FULL OUTER JOIN hof_inducted 
ON salaries.playerid = hof_inducted.playerid;

-- 6. There are 2 tables, hof_inducted and hof_not_inducted, indicating successful and unsuccessful inductions 
-- into the Baseball Hall of Fame, respectively.
--   a. Combine these 2 tables by all fields. Keep all records.
--   b. Get a distinct list of all player IDs for players who have been put up for HOF induction.
SELECT * FROM hof_inducted UNION SELECT * FROM hof_not_inducted;

-- 7. Write a query that returns the last name, first name (see people table), and total recorded 
-- salaries for all players found in the salaries table.
SELECT people.namelast, people.namefirst, salaries.salary 
FROM people
RIGHT JOIN salaries 
ON people.playerid = salaries.playerid;

-- 8. Write a query that returns all records from the hof_inducted and hof_not_inducted tables that include 
-- playerid, yearid, namefirst, and namelast.
SELECT hof_inducted.playerid, hof_inducted.yearid, people.namefirst, 
	people.namelast
FROM hof_inducted 
LEFT JOIN people 
ON hof_inducted.playerid = people.playerid 
UNION 
SELECT hof_not_inducted.playerid, hof_not_inducted.yearid, people.namefirst, 
	people.namelast
FROM hof_not_inducted 
LEFT JOIN people 
ON hof_not_inducted.playerid = people.playerid; 

-- 9. Return a table including all records from both hof_inducted and hof_not_inducted, and include a new 
-- field, namefull, which is formatted as namelast , namefirst (in other words, the last name, followed by a comma, then 
-- a space, then the first name). The query should also return the yearid and inducted fields. Include only 
-- records since 1980 from both tables. Sort the resulting table by yearid, then inducted so that Y comes before N. 
-- Finally, sort by the namefull field, A to Z.
SELECT hof_inducted.playerid, hof_inducted.yearid, people.namefirst, 
	people.namelast, people.namelast || ', ' || people.namefirst namefull, 
	hof_inducted.yearid, hof_inducted.inducted
FROM hof_inducted 
LEFT JOIN people 
ON hof_inducted.playerid = people.playerid 
UNION 
SELECT hof_not_inducted.playerid, hof_not_inducted.yearid, people.namefirst, 
	people.namelast, people.namelast || ', ' || people.namefirst namefull, 
	hof_not_inducted.yearid, hof_not_inducted.inducted
FROM hof_not_inducted 
LEFT JOIN people 
ON hof_not_inducted.playerid = people.playerid 
ORDER BY 6 ASC, 7 DESC;

-- 10. Write a query that returns the highest annual salary for each teamid, ranked from high to low, along 
-- with the corresponding playerid. Bonus! Return namelast and namefirst in the resulting table.
WITH max_sals AS(
	SELECT salaries.teamid, MAX(salaries.salary) max_sal
	FROM salaries
	GROUP BY salaries.teamid)
SELECT salaries.teamid, salaries.playerid, max_sals.max_sal
FROM salaries 
INNER JOIN max_sals 
ON salaries.teamid = max_sals.teamid 
	AND salaries.salary = max_sals.max_sal 
WHERE max_sals.max_sal IS NOT NULL;

-- 11. Select birthyear, deathyear, namefirst, and namelast of all the players born since the birth year of 
-- Babe Ruth (playerid = ruthba01). Sort the results by birth year from low to high.
SELECT people.birthyear, people.deathyear, people.namefirst, people.namelast
FROM people 
WHERE people.birthyear > (
	SELECT people.birthyear
	FROM people 
	WHERE people.playerid = 'ruthba01'
)
ORDER BY people.birthyear ASC;

-- 12. Using the people table, write a query that returns namefirst, namelast, and a field called usaborn 
-- where. The usaborn field should show the following: if the player's birthcountry is the USA, then the record is 'USA.' 
-- Otherwise, it's 'non-USA.' Order the results by 'non-USA' records first.
SELECT people.namefirst, people.namelast, 
	CASE
		WHEN people.birthcountry = 'USA' THEN people.birthcountry
		ELSE 'non-USA'
	END usaborn
FROM people;

-- 13. Calculate the average height for players throwing with their right hand versus their left hand. Name 
-- these fields right_height and left_height, respectively.
SELECT ROUND(AVG(CASE WHEN people.throws = 'R' THEN people.height END)::numeric,2) avg_right,
	ROUND(AVG(CASE WHEN people.throws = 'L' THEN people.height END)::numeric,2) avg_left
FROM people;

-- 14. Get the average of each team's maximum player salary since 2010.
WITH max_sals AS(
	SELECT salaries.teamid, MAX(salaries.salary) max_sal
	FROM salaries 
	WHERE salaries.yearid>2010
	GROUP BY salaries.teamid)
SELECT ROUND(AVG(max_sals.max_sal)::numeric,2) avg_max
FROM max_sals;