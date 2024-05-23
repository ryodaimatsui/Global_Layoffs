-- GLOBAL LAYOFFS DATA SQL PROJECT PART 1: DATA CLEANING

/*Create the table
  Note that the data types are wrong for some columns.
  This is done intentionally to practice cleaning data.
*/
CREATE TABLE layoffs_ft(
	company TEXT,
	location TEXT,
	industry TEXT,
	total_laid_off INT,
	percentage_laid_off TEXT,
	date TEXT,
	stage TEXT,
	country TEXT,
	funds_raised_millions TEXT
);

-- Check to see if data was read in correctly.
SELECT * FROM layoffs_ft;

-- Create a copy of table (good practice so that you do not mess up raw dataset)
DROP TABLE IF EXISTS layoffs_staging;
CREATE TABLE layoffs_staging AS
TABLE layoffs_ft
WITH NO DATA;

-- Check 
SELECT * FROM layoffs_staging;

-- Insert Data 
INSERT INTO layoffs_staging
SELECT * FROM layoffs_ft;

-- Check 
SELECT * FROM layoffs_staging;

/* Another option would have been:
CREATE TABLE layoffs_staging
AS layoffs_ft;
*/

-- 1. REMOVE DUPLICATES

-- Subquery method to view duplicate rows
SELECT *
FROM (
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company,location,industry,total_laid_off,
		percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging
) AS numbered_row
WHERE row_num > 1;

-- Alternative method: create a CTE to view duplicate rows

WITH duplicates_cte AS
(
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company,location,industry,total_laid_off,
		percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
	FROM layoffs_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

-- Check to see whether the rows are in fact duplicates. Take one company as an example.
SELECT * 
FROM layoffs_staging
WHERE company = 'Cazoo';

-- Remove the duplicates after check.
DELETE FROM layoffs_staging
WHERE ctid IN (
    SELECT ctid
    FROM (
        SELECT 
            ctid,
            ROW_NUMBER() OVER (
                PARTITION BY company, location, industry, total_laid_off,
                    percentage_laid_off, date, stage, country, funds_raised_millions
            ) AS row_num
        FROM layoffs_staging
    ) AS subquery
    WHERE row_num > 1
);

-- 2. STANDARDIZING DATA

-- Trim column
UPDATE layoffs_staging
SET company = TRIM(company);

-- Check industry column for any errors
SELECT DISTINCT(industry)
FROM layoffs_staging
ORDER BY 1;

-- Fix error
UPDATE layoffs_staging
SET industry = 'Cryptocurrency'
WHERE industry LIKE 'Crypto%';

-- Skim through "location" to check for missing values / typos
SELECT DISTINCT(location)
FROM layoffs_staging

-- Found two potential errors, so update the location 
UPDATE layoffs_staging
SET location = 'Hangzhou'
WHERE company = 'WeDoctor'

UPDATE layoffs_staging
SET location = 'Victoria'
WHERE company = 'BitMEX'

-- Check the 'country' column
SELECT DISTINCT(country)
FROM layoffs_staging

-- View the error
SELECT DISTINCT(country), TRIM(TRAILING '.' from country)
FROM layoffs_staging
ORDER BY 1;

-- Fix "United States." to simply "United States"
UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' from country)
WHERE country LIKE 'United States%';

-- Check table
SELECT *
FROM layoffs_staging;


-- Update the format of the date column
UPDATE layoffs_staging
SET date = to_date(date, 'mm/dd/YYYY');

-- Change the data type of the date column to date
ALTER TABLE layoffs_staging
ALTER COLUMN date TYPE DATE
USING date::date;

-- 3. DEALING WITH NULL AND BLANK VALUES
SELECT *
FROM layoffs_staging
WHERE industry IS NULL
OR industry = '';

-- Manually updating the industry type based on the company name
SELECT *
FROM layoffs_staging
WHERE company = 'Carvana';

-- Matching companies with missing industry type to their respective industry types.
SELECT *
FROM layoffs_staging t1
JOIN layoffs_staging t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND (t2.industry IS NOT NULL OR t1.industry != '')
ORDER BY t2.company

-- Set blank values as NULL for easier manipulation 
UPDATE layoffs_staging
SET industry = NULL
WHERE industry = '';

-- Update the industry type based on the industry type listed for that same company
UPDATE layoffs_staging t1
SET industry = t2.industry
FROM layoffs_staging t2
WHERE t1.company = t2.company
AND t1.industry IS NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging
SET industry = 'Entertainment'
WHERE company = 'Bally''s Interactive'

-- Viewing null values in total_laid_off and percentage_laid_off
SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Deleting rows where both columns are null
DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Check
SELECT *
FROM layoffs_staging;

-- Change the data types of the columns
ALTER TABLE layoffs_staging
ALTER COLUMN percentage_laid_off TYPE FLOAT
USING percentage_laid_off::FLOAT;

ALTER TABLE layoffs_staging
ALTER COLUMN funds_raised_millions TYPE FLOAT
USING funds_raised_millions::FLOAT;
