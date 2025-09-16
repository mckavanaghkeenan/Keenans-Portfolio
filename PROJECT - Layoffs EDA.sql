-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT company, total_laid_off, `date`
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL;

SELECT total_laid_off
FROM layoffs_staging2;

##Using the CONVERT function to change values to INT.
##Until I figure out a way to convert the whole column to INT values.
SELECT company, MAX(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Max_laid_off, MAX(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY Max_laid_off DESC;

SELECT MAX(CONVERT(total_laid_off,UNSIGNED INTEGER))
FROM layoffs_staging2;

##Checking where Layoffs were 100%, company went under.
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

##Checking how much was raised before going under. Again CONVERT because the columns were messed up in upload.
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY CONVERT(funds_raised_millions,UNSIGNED INTEGER) DESC;

SELECT company, SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

##Checking date range of data.
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

##Looks at every specific date.
SELECT `date`, SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 2 DESC;

##Grouped by YEAR.
SELECT YEAR(`date`), SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

##Stage.
SELECT stage, SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

##Rolling total of all layoffs by year/month.
##SUBSTRING(string, start, length)
SELECT SUBSTRING(`date`,1,7) as `Month`, SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` ASC;

##Creating a rolling total of layoffs over all months using a CTE.
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) as `Month`, SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `Month`
ORDER BY `Month` ASC
)
SELECT `Month`, 
Sum_total_layoff, 
SUM(Sum_total_layoff) OVER (ORDER BY `Month`) AS Rolling_total
FROM Rolling_Total;



##Sorting layoffs by Company per Year.
SELECT 
	company, 
	YEAR(`date`), 
	SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY company, `date`
ORDER BY company ASC;

##Highest layoffs by Company/year.
SELECT 
	company, 
	YEAR(`date`), 
	SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY company, `date`
ORDER BY 3 DESC;

##CTE for Ranking. DENSE_RANK
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT 
	company, 
	YEAR(`date`), 
	SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT 
	*, 
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking;

##CTE again but filtering down to pull top 5 companies only.
##Created Company_Year table to then query DENSE_RANK.
##Created Company_Year_Rank table to then filter that DENSE_RANK.
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT 
	company, 
	YEAR(`date`), 
	SUM(CONVERT(total_laid_off,UNSIGNED INTEGER)) AS Sum_total_layoff
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS##Second nested table in CTE query.
(
SELECT 
	*, 
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT
	*
FROM Company_Year_Rank
WHERE Ranking <= 5;##Pulls ranks 1-5 for each year.  There are doubles since some companies laid off the same amount.













