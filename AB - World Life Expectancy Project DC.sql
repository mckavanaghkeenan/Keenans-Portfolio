# World Life Expectancy (Data Cleaning) Project

SELECT *
FROM world_life_expectancy
;

# Let's look for duplicates first
# Since these rows each have an individual Row_ID number.  We will need to identify a different way to find duplicates
# Country and Year put together is a good bet because there should not be doubles of those

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
;

SELECT Country, Year, Status
FROM world_life_expectancy
WHERE status = ''
;

SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE status <> ''
;

UPDATE world_life_expectancy
SET status = 'Developing'
WHERE 