# US Household Income Project Exploratory Data Analysis (EDA)

SELECT *
FROM US_Project.US_Household_Income
;

SELECT *
FROM US_Project.US_household_income_statistics
;


SELECT State_name, County, City, ALand, AWater
FROM US_Project.US_Household_Income
;

# Checking some interesting geographical data.

SELECT State_name, SUM(ALand), SUM(AWater)
FROM US_Project.US_Household_Income
GROUP BY State_name
ORDER by 2 DESC
LIMIT 10
;

SELECT State_name, SUM(ALand), SUM(AWater)
FROM US_Project.US_Household_Income
GROUP BY State_name
ORDER by 3 DESC
LIMIT 10
;

# Let's join the two tables together to bring in our income as well.

SELECT *
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id;
    
SELECT *
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
#WHERE us.id IS NULL
;

SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id;


# Lowest 5 states AVG Income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
GROUP BY u.State_name
ORDER BY 2
LIMIT 5
;

# Highest states AVG Income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
GROUP BY u.State_name
ORDER BY 2 DESC
LIMIT 10
;

# Highest states MEDIAN Income
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
GROUP BY u.State_name
ORDER BY 3 DESC
LIMIT 10
;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
GROUP BY u.State_name
ORDER BY 3
LIMIT 10
;

# Checking the Type.  BE CAREFUL OF LIMITS!
SELECT Type, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
GROUP BY 1
ORDER BY 2
LIMIT 20
;

# Removing certain types that have so few results so you don't have strange outliers.
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.US_Household_Income u
	JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
GROUP BY 1
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 20
;

SELECT *
FROM US_project.US_household_Income
WHERE Type = 'County'
;

SELECT Type, COUNT(Type)
FROM US_project.US_household_Income
GROUP BY Type
;

# Sorting by CITY
SELECT u.State_Name, City, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.US_Household_Income u
JOIN US_Project.US_household_income_statistics us
    ON u.id = us.id
GROUP BY u.State_Name, City
#HAVING State_Name = 'Nevada'
ORDER BY 3 DESC
;



