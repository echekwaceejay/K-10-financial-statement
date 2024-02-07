use ceejay

-- Set the SQL mode to the desired value

SET GLOBAL sql_mode = 'desired_mode';

SET GLOBAL sql_mode = '';


-- Verify the change
SELECT @@GLOBAL.sql_mode;

select * from financial_statement

-- Number of reviewed company and Industry sector on their database --
SELECT 
	COUNT(DISTINCT company) AS num_of_company,
    COUNT(DISTINCT category) AS num_of_sector
FROM financial_statement;

-- List of companies 
SELECT 
	DISTINCT company
FROM financial_statement;

-- List of sectors
SELECT 
DISTINCT category AS sector
FROM financial_statement;

-- Number of company in each sector.
SELECT 
	DISTINCT category AS sectors,
	COUNT(DISTINCT company) AS num_of_company
FROM financial_statement
GROUP BY 1;

--  Revenue, Net income and Net income margin of Each Sector per year.
SELECT
	`year`,
    category AS sector,
    SUM(revenue) AS total_revenue,
    SUM(net_income) AS total_net_income,
    SUM(net_income) / SUM(revenue) * 100 AS net_profit_mragin
FROM financial_statement
GROUP BY 2, 1
ORDER BY 1,5 DESC; 

-- compare net_income in sector category
SELECT
	year,
	AVG(CASE WHEN category = 'IT' THEN net_income ELSE NULL END ) AS IT_Net_income,
    AVG(CASE WHEN category = 'FinTech' THEN net_income ELSE NULL END ) AS FinTech_Net_income,
    AVG(CASE WHEN category = 'Bank' THEN net_income ELSE NULL END ) AS Bank_Net_income,
    AVG(CASE WHEN category = 'Manufacturing' THEN net_income ELSE NULL END ) AS Manufacturing_Net_income,
    AVG(CASE WHEN category = 'Finance' THEN net_income ELSE NULL END ) AS Finance_Net_income,
    AVG(CASE WHEN category = 'FOOD' THEN net_income ELSE NULL END ) AS Food_Net_income,
    AVG(CASE WHEN category = 'ELEC' THEN net_income ELSE NULL END ) AS Electric_Net_income,
    AVG(CASE WHEN category = 'LOGI' THEN net_income ELSE NULL END ) AS Logistics_Net_income
FROM financial_statement
GROUP BY 1
ORDER BY 1;

-- Ranked Revenue, Gross profit  and Net income of Each Sector per year
SELECT 
	year,
    sector,
	RANK () OVER (PARTITION  BY year ORDER BY total_revenue desc) AS revenue_rank,
    RANK () OVER (PARTITION  BY year ORDER BY total_profit desc) AS profit_rank,
    RANK () OVER (PARTITION  BY year ORDER BY total_net_income desc) AS net_income_rank
FROM
(SELECT
	`year`,
    category AS sector,
    SUM(revenue) AS total_revenue,
    SUM(gross_profit) AS total_profit,
    SUM(net_income) AS total_net_income
FROM financial_statement
GROUP BY 2, 1
ORDER BY 1,3 DESC
) e; 

-- Market Capitalization of each Sector 
SELECT
	year,
	AVG(CASE WHEN category = 'IT' THEN `market_cap(in_b_usd)` ELSE NULL END) AS IT,
    AVG(CASE WHEN category = 'FinTech' THEN `market_cap(in_b_usd)` ELSE NULL END) AS FinTech,
    AVG(CASE WHEN category = 'Bank' THEN `market_cap(in_b_usd)` ELSE NULL END) AS Bank,
    AVG(CASE WHEN category = 'Manufacturing' THEN `market_cap(in_b_usd)` ELSE NULL END) AS Manufacturing,
    AVG(CASE WHEN category = 'Finance' THEN `market_cap(in_b_usd)` ELSE NULL END) AS Finance,
    AVG(CASE WHEN category = 'FOOD' THEN `market_cap(in_b_usd)` ELSE NULL END) AS Food,
    AVG(CASE WHEN category = 'ELEC' THEN `market_cap(in_b_usd)` ELSE NULL END) AS Electric,
    AVG(CASE WHEN category = 'LOGI' THEN `market_cap(in_b_usd)` ELSE NULL END) AS Logistics
FROM financial_statement
GROUP BY 1
ORDER BY 1;
	
-- Earning per Share of each Sector
SELECT
	year,
	AVG(CASE WHEN category = 'IT' THEN earning_per_share ELSE NULL END) AS IT,
    AVG(CASE WHEN category = 'FinTech' THEN earning_per_share ELSE NULL END) AS FinTech,
    AVG(CASE WHEN category = 'Bank' THEN earning_per_share ELSE NULL END) AS Bank,
    AVG(CASE WHEN category = 'Manufacturing' THEN earning_per_share ELSE NULL END) AS Manufacturing,
    AVG(CASE WHEN category = 'Finance' THEN earning_per_share ELSE NULL END) AS Finance,
    AVG(CASE WHEN category = 'FOOD' THEN earning_per_share ELSE NULL END) AS Food,
    AVG(CASE WHEN category = 'ELEC' THEN earning_per_share ELSE NULL END) AS Electric,
    AVG(CASE WHEN category = 'LOGI' THEN earning_per_share ELSE NULL END) AS Logistics
FROM financial_statement
GROUP BY 1
ORDER BY 1;

-- Shareholder equity per industry
SELECT
	year,
	AVG(CASE WHEN category = 'IT' THEN share_holder_equity ELSE NULL END) AS IT,
    AVG(CASE WHEN category = 'FinTech' THEN share_holder_equity ELSE NULL END) AS FinTech,
    AVG(CASE WHEN category = 'Bank' THEN share_holder_equity ELSE NULL END) AS Bank,
    AVG(CASE WHEN category = 'Manufacturing' THEN share_holder_equity ELSE NULL END) AS Manufacturing,
    AVG(CASE WHEN category = 'Finance' THEN share_holder_equity ELSE NULL END) AS Finance,
    AVG(CASE WHEN category = 'FOOD' THEN share_holder_equity ELSE NULL END) AS Food,
    AVG(CASE WHEN category = 'ELEC' THEN share_holder_equity ELSE NULL END) AS Electric,
    AVG(CASE WHEN category = 'LOGI' THEN share_holder_equity ELSE NULL END) AS Logistics
FROM financial_statement
GROUP BY 1
ORDER BY 1;

-- companies that held the 1st 2nd & 3rd in Financial ranking from 2019 to 2023
SELECT * 
 FROM
 (SELECT
	`year`,
    category AS sector,
    company,
    revenue,
    net_income,
    RANK() OVER(PARTITION BY year ORDER BY net_income DESC) AS net_income_ranking
FROM financial_statement) r
WHERE r.net_income_ranking IN (1,2,3);

 -- Extract company that ranked 1st in each year
SELECT * 
 FROM
 (SELECT
	`year`,
    category AS sector,
    company,
    revenue,
    net_income,
    RANK() OVER(PARTITION BY year ORDER BY net_income DESC) AS net_income_ranking
FROM financial_statement) r
WHERE r.net_income_ranking =1;

-- Number of times this companies held the 1st lead from 2019 to 2023
SELECT
	r.category AS sector,
	r.company,
	COUNT(r.company) AS num_1st_lead
 FROM
 (SELECT
	`year`,
    category,
    company,
    revenue,
    gross_profit,
    net_income,
    RANK() OVER(PARTITION BY year ORDER BY net_income DESC) AS net_income_ranking
FROM financial_statement) r
WHERE r.net_income_ranking =1
GROUP BY 1, 2;

-- Cost of Goods sold and gross profit margin on each company over the years 
SELECT
	year,
    company,
    category,
    revenue,
    gross_profit,
    revenue - gross_profit AS COGS,
    (revenue - gross_profit) / revenue * 100 AS gross_profit_margin
FROM financial_statement
ORDER BY 1;

-- Average revenue and Net income On each sector in each year 
SELECT 
	year,
    category,
	AVG(revenue) AS Avg_in_Revenue,
    AVG(net_income) AS Avg_in_Net_income
FROM financial_statement
GROUP BY 1,2
ORDER BY 1, 3 desc, 4 DESC;

-- Averaged with the highest Ranked in Revenue and Net Income in each year 
WITH ranked_data AS (
    SELECT
        year,
        category,
        Avg_in_Revenue,
        Avg_in_Net_income,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY Avg_in_Revenue DESC) AS max_revenue,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY Avg_in_Net_income DESC) AS max_net_income
    FROM (
        SELECT 
            year,
            category,
            AVG(revenue) AS Avg_in_Revenue,
            AVG(net_income) AS Avg_in_Net_income
        FROM financial_statement
        GROUP BY 1, 2
    ) e
)
SELECT year, category, Avg_in_Revenue, Avg_in_Net_income
FROM ranked_data
WHERE max_revenue = 1 OR max_net_income = 1
ORDER BY 1, 2 desc;

