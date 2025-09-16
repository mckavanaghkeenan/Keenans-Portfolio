-- Data Cleaning PROJECT
-- 

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null/Blank values
-- 4. Remove any Columns or Rows

SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *##Create a staging table so you're not working off the RAW data.
FROM layoffs_staging;

INSERT INTO layoffs_staging##Pulls all data from layoffs table into staging table.
SELECT *
FROM layoffs;

##Using PARTITION BY to add unique row numbers. Anything 2 or more has duplicates.
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

##CTE to check duplicate rows. (i.e. row_num > 1)
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

##Double checking that duplicates are actually TRUE.
SELECT*
FROM layoffs_staging
WHERE company = 'Casper';

##Creating a new table to help with removal of duplicate rows since CTEs cannot be updated/deleted from.
##Right clicking the table you want to copy to clipboard create statement.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT*
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;
##Finished creating new table above.


##Pulling to check duplicate rows.
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

##Using the same statement to make sure exact rows are deleted.
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

##Updating table with new trim company column.
UPDATE layoffs_staging2
SET company = TRIM(company);

##Finding lookalike industries that should be standardized (ex. Crypto vs Crypto Currency)
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

##Removing a . from country names.
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

##Changing date column from text to date values.
SELECT `date`
FROM layoffs_staging2;

SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y')
WHERE `date` != 'NULL';

UPDATE layoffs_staging2##Removed the 'NULL' value by actually making it NULL.
SET `date` = NULL
WHERE `date` = '';

##Running into an issue with my particulary MySQL and the way it interpreted the data. (maybe because of the CSV to JSON conversion)
##NULL is a value that is currently populated in the date column and that is stopping
##me from changing the type of the date column.  SOLVED ABOVE.
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;

##Cleaning up string NULL values and replacing them with NULL
UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = 'NULL';

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'NULL';

SELECT *
FROM layoffs_staging2
WHERE industry = 'NULL'
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''
OR industry = 'NULL';

## Finding and updating industry values where we have duplicate companies with populated industry values.
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

##Finding all the rows that do not have any layoffs (that we can tell)
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


##In this case, the data probably isn't needed, especially if we are unable to obtain the info from somewhere else.
DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2;

##Need to drop the row_num column because it is no longer needed. (Was originally use for finding duplicate rows.)
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;