# World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM world_life_expectancy
;



SELECT Country, 
MIN(Lifeexpectancy), 
MAX(Lifeexpectancy),
ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy),1) as Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(Lifeexpectancy) <> 0
AND MAX(Lifeexpectancy) <> 0
ORDER BY Life_Increase_15_Years DESC
;


SELECT *
FROM world_life_expectancy
;


SELECT Year, ROUND(AVG(Lifeexpectancy),2)
FROM world_life_expectancy
#WHERE Lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year
;


SELECT Country, ROUND(AVG(Lifeexpectancy),1) as Life_exp, ROUND(AVG(GDP),1) as GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

SELECT *
FROM world_life_expectancy
;



SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END) High_GDP_Life_expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END) Low_GDP_Life_expectancy
FROM world_life_expectancy
;


SELECT Status, ROUND(AVG(Lifeexpectancy),1)
FROM world_life_expectancy
GROUP BY status
;

SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(Lifeexpectancy),1)
FROM world_life_expectancy
GROUP BY Status
;



SELECT Country, 
FROM world_life_expectancy
;

SELECT Country, ROUND(AVG(Lifeexpectancy),1) as Life_exp, ROUND(AVG(BMI),1) as BMI, Status
FROM world_life_expectancy
GROUP BY Country, Status
HAVING Life_exp > 0
AND BMI > 0
ORDER BY BMI ASC
;




SELECT Country,
Year,
Lifeexpectancy,
AdultMortality,
SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY Year) as Rolling_total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;













