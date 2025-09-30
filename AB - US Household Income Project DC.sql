# US Household Income Data Cleaning

SELECT *
FROM US_Project.US_Household_Income
;

SELECT *
FROM US_Project.US_household_income_statistics
;

# Counts to make sure we have all the rows needed.
SELECT COUNT(id)
FROM US_Project.US_Household_Income
;
SELECT COUNT(id)
FROM US_Project.US_household_income_statistics
;

# Removing duplicates.
SELECT id, COUNT(id)
FROM US_Project.US_Household_Income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id)
FROM US_Project.US_Household_Income
;

SELECT *
FROM(
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
FROM US_Project.US_Household_Income) as duplicates
WHERE row_num > 1
;

DELETE FROM US_Project.US_Household_Income
WHERE
	row_id IN (
    SELECT row_id
	FROM(
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) as row_num
		FROM US_Project.US_Household_Income) as duplicates
		WHERE row_num > 1)
;

# No duplicates found in this table so GOOD!
SELECT id, COUNT(id)
FROM US_Project.US_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

# Moving on to other checks. ------------------------------------

# State name has some issues.
SELECT State_Name, COUNT(State_Name)
FROM US_Project.US_Household_Income
GROUP BY State_Name
ORDER BY State_Name
;

SELECT DISTINCT(State_Name)
FROM US_Project.US_Household_Income
;

UPDATE US_Project.US_Household_Income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE US_Project.US_Household_Income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';



SELECT DISTINCT State_ab
FROM US_Project.US_Household_Income
;

SELECT *
FROM US_Project.US_Household_Income
WHERE County = 'Autauga County'
#WHERE Place IS NULL
ORDER BY 1
;

# Finding a NULL value and replacing it with a value that we can assume is correct (99.9%)
UPDATE US_Project.US_Household_Income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

# Checking Type next.

SELECT Type, COUNT(Type)
FROM US_Project.US_Household_Income
GROUP BY Type
;

# Borough and Boroughs are the same thing so lets standardize that.  CDP and CPD could possibly be the same but
# we don't have enough domain knowledge to make that decision.

UPDATE US_Project.US_Household_Income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

# We could check the other columns like zipcode and area code etc.
# However lets check the ALand and Awater columns since we did see some 0s in there before.

SELECT ALand, AWater
FROM US_Project.US_Household_Income
WHERE (AWater = 0 OR AWater = '' OR AWater IS NULL)
AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;

# So it looks like there are no entries that have 0s for BOTH Land and Water. Apparently some just have one or the other.alter












