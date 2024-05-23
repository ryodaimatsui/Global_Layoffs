# Global Layoff Trends During the Covid-19 Pandemic and Afterward
![the-new-york-public-library-Q0_u7YwXqh0-unsplash](https://github.com/ryodaimatsui/Global_Layoffs/assets/137141385/b7ff1ceb-ad55-4e8c-9b55-125396e27914)

## Project Overview:
This project analyzes global layoffs from 2020 to early 2023. As a direct result of the global shutdown caused by the Covid-19 pandemic, companies across the world have taken measures to conduct internal restructuring. Interestingly enough, the peak layoffs occurred "post-Covid", from 2022-23. I place the term "post-Covid" in quotes and use it rather reluctantly, because the pandemic effected each country differently and because the effects are experienced relative to the political, social, and economic systems in place in each country. Still, the distinction may be suitable in analysis like this one, to draw insights on global employment/unemployment trends.

In any case, the main Jupyter Notebook file titled "global_layoffs.ipynb" begins with a comprehensive data cleaning process. Initially, the data cleaning and analysis were planned to be conducted using PostgreSQL. However, due to discrepancies between the company names and their corresponding industry types, it was decided to perform the cleaning and analysis using Python, as web scraping was necessary to correct the data.

Following this, exploratory data analysis (EDA) was conducted to reveal global trends. 

## Structure of Repository:
As evident, this repository contains a "Resources" file. Within this file, you will find the three following files:
- "Webscrape_Tech_Companies.ipynb"
- "global_layoffs_cleaning.sql"
- "top_tech_companies.csv"

With regard to the SQL file, this was the original working file during the initial stage of the project. Although the data cleaning process was conducted again using Python following the transfer from PostgreSQL to Jupyter Notebook, hopefully someone may find it useful in learning data cleaning techniques using SQL. 
As noted earlier, discrepancies between companies and their respective industry types were found. While it was not feasible to correct all records, the top 100 tech companies were corrected using data scraped from the website provided in the "Webscrape_Tech_Companies.ipynb" file. The scraped data was saved as a CSV file — "top_tech_companies.csv" — and read into the main notebook. 

## Summary of Findings:
1. Among the top 10 countries in terms of layoff volume, the United States ranked number 1 with a staggering 256,559 total layoffs between 2020-23.
2. Among the top 10 companies for layoffs, 7 are headquartered in the United States. Notably, all of these companies are tech companies.
3. With regard to the previous point, the tech industry was ranked first in layoffs with over 76,000.
4. Finally, the number of layoffs begins to peak from December 2022 into early February 2023, where the data cuts off.

## A Note on Dependencies:
- Due to the dynamic nature of the website used for webscraping, Selenium instead of BeautifulSoup was used. If Selenium has not been installed, install before proceeding.

## Credit:
- Website used for Webscrape: https://companiesmarketcap.com/tech/largest-tech-companies-by-number-of-employees/
- Inspiration for the Project: "Alex the Analyst" on Youtube.
- Picture Credit: The New York Public Library via Unsplash.com

