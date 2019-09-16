-- 1. How many records are in the vehicles table?
SELECT COUNT(id)
FROM vehicles;

-- 2. Write a query that returns all the records in the vehicles table.
SELECT *
FROM vehicles;

-- 3. Write a query that returns the id, make, and model fields for all the records for 2010 vehicles.
SELECT id, make, model
FROM vehicles v
WHERE v.year = 2010;

-- 4. Write a query that returns the count of vehicles from 2010. Also provide the answer.
-- RETURNS: 1109
SELECT COUNT(id)
FROM vehicles v
WHERE v.year = 2010;

-- 5. Write a query that returns the count of vehicles in the vehicles table between 
-- the years 2010 and 2015, inclusive. Provide the query as well as the answer.
-- RETURNS 5995
SELECT COUNT(id)
FROM vehicles v 
WHERE v.year BETWEEN 2010 AND 2015;

-- 6. Write a query that returns the count of vehicles from the years 
-- 1990, 2000, and 2010. Provide the query and the result. 
-- RETURNS: 3026
SELECT COUNT(id)
FROM vehicles v 
WHERE v.year IN(1990,2000,2010);

-- 7. Write a query that returns the count of all records between 1987 and 2005, 
-- exclusive of the years 1990 and 2000.
-- RETURNS: 17235
SELECT COUNT(id) 
FROM vehicles v 
WHERE v.year BETWEEN 1987 AND 2005 
	AND v.year NOT IN(1990,2000);
	
-- 8. Write a query that returns the year, make, model, and a field called average_mpg 
-- that calculates the average highway/city fuel consumption. (For example, if hwy is 24 and 
-- cty is 20, then average_mpg = (24 + 20)/ 2 = 22.)
SELECT v.year, v.make, v.model, (v.hwy+v.cty)/2 average_mpg
FROM vehicles v;

-- 9. Write a query that returns the year, make, model, and a text field 
-- displaying “X highway; Y city.” (For example, if hwy is 24 and cty is 20, then 
-- hwy_city is “24 highway; 20 city.”)

SELECT v.year, v.make, v.model, v.hwy || ' highway; ' || v.cty || ' city' hwy_city
FROM vehicles v;

-- 10. Write a query that returns the id, make, model, and year for all records 
-- that have NULL for either the cyl or displ fields.
SELECT v.id, v.make, v.model, v.year
FROM vehicles v 
WHERE v.cyl IS NULL 
	OR v.displ IS NULL;
	
-- 11. Write a query that returns all fields for records with rear-wheel drive and diesel 
-- vehicles since 2000, inclusive. Also sort by year and highway mileage, both descending. 
SELECT DISTINCT(drive)
FROM vehicles v;

SELECT DISTINCT(fuel)
FROM vehicles v;

SELECT *
FROM vehicles v 
WHERE v.drive = 'Rear-Wheel Drive'
	AND v.fuel = 'Diesel' 
	AND v.year > 2000;
	
-- 12. Write a query that counts the number of vehicles that are either Fords or Chevrolets 
-- and either compact cars or 2-seaters. Provide the query and the answer.
-- RETURNS: Ford: 287, Chevrolets: 325
SELECT DISTINCT(make) FROM vehicles;

SELECT v.make, COUNT(id)
FROM vehicles v
WHERE v.class IN('Compact Cars', 'Two Seaters') 
	AND v.make IN('Ford', 'Chevrolet')
GROUP BY v.make;

-- 13. Write a query that returns the records for 10 vehicles with the highest highway fuel mileage.
SELECT *
FROM vehicles v
ORDER BY hwy DESC
LIMIT 10;

-- 14. Write a query that returns all the records of vehicles since the year 2000 whose model 
-- name starts with a capital X. Sort the list A through Z by make. What happens when you 
-- use a lowercase “x” instead?
-- Postgresql is case-sensitive only with quoted names.
SELECT *
FROM vehicles v 
WHERE v.model LIKE 'X%'
ORDER BY make;

-- Write a query that returns the count of records where the “cyl” field is NULL. Provide 
-- the query as well as the answer.
-- RETURNS: 58
SELECT COUNT(id)
FROM vehicles v 
WHERE v.cyl IS NULL;

-- Write a query that returns the count of all records before the year 2000 that got 
-- more than 20 mpg hwy and had greater than 3 liters displacement (“displ” field). Provide the 
-- query as well as the answer.
-- RETURNS: 1964
SELECT COUNT(id)
FROM vehicles v
WHERE v.year<2000 
	AND hwy>20 
	AND displ>3;
	
-- Write a query that returns all records whose model name has a (capital) X in its 3rd 
-- position. Hint: make sure your wildcard operator accommodates for any characters after the “X”!
SELECT *
FROM vehicles v 
WHERE model LIKE '__X%';