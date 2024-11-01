--Exploratory Data Analysis

SELECT *
FROM layoffs_staging;

SELECT MAX(total_laid_off), MAX(percentage_laid_off) --Highest total laid off at once is 12,000 workers 
FROM layoffs_staging;

SELECT *                          -- Quite a number of companies laid off 100% of workforce,
FROM layoffs_staging				--which means that a lot of companies went down
WHERE percentage_laid_off= 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off) -- Amazon, Google and Meta laid off the highest number of workers
FROM layoffs_staging
GROUP BY company
ORDER By 2 DESC;

SELECT MIN("date"), MAX("date") -- Data covers about 3 years
FROM layoffs_staging;

SELECT industry, SUM(total_laid_off) -- Consumer and Retail industry was hit the most 
FROM layoffs_staging				 --and Manufacturing took the lowest hit
GROUP BY industry
ORDER By 2 DESC	;
 
SELECT country, SUM(total_laid_off) -- United States was the country with the highest layoffs
FROM layoffs_staging				 
GROUP BY country
ORDER By 2 DESC	;

SELECT YEAR("date"), SUM(total_laid_off) -- The layoff numbers will likely be high because this data 
FROM layoffs_staging						-- was as at the 3rd month and its already 125,677
GROUP BY YEAR("date")
ORDER By 1 DESC	

SELECT stage, SUM(total_laid_off) --  The large companies in the post-ipo phase laid off the most
FROM layoffs_staging						
GROUP BY stage
ORDER By 2 DESC

WITH Rolling_total AS(
SELECT SUBSTRING(CAST("date" as varchar),1,7) as "month", SUM(total_laid_off) as total_layoff 
FROM layoffs_staging
WHERE SUBSTRING(CAST("date" as varchar),1,7) IS NOT NULL
GROUP BY SUBSTRING(CAST("date" as varchar),1,7)
)

SELECT "month", total_layoff,			
 SUM(total_layoff) OVER( ORDER BY "month") AS Rolling_total
FROM Rolling_total;
-- The world was most hit during between october 2022 and January 2023. The year 2021 was the least hit

SELECT company, YEAR("date") Annual, SUM(total_laid_off) total_layoff
FROM layoffs_staging						
GROUP BY company, YEAR("date") 
ORDER BY 3 DESC


WITH company_year AS
(SELECT company, YEAR("date") Annual, SUM(total_laid_off) total_layoff
FROM layoffs_staging						
GROUP BY company, YEAR("date")),

Company_Year_Rank AS
(SELECT company, Annual, total_layoff,
DENSE_RANK()  OVER(PARTITION BY Annual ORDER BY total_layoff DESC) AS Ranking
FROM company_year
WHERE Annual IS NOT NULL)

SELECT *
FROM Company_Year_Rank
WHERE Ranking <=5
-- Gives us the top 5 companies in terms of layoff per year over the period(about 3 years).
--A lot of the tech companies took some big hits.











