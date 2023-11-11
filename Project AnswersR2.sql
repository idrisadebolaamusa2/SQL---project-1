SELECT * FROM all_sessions
SELECT * FROM analytics
SELECT * FROM products
SELECT * FROM sales_by_sku
SELECT * FROM sales_report
SELECT * FROM temp_tab1

----Normalizing the data---

UPDATE all_sessions
SET city = null
WHERE city = '(not set)' OR city = 'not available in demo dataset'

UPDATE analytics
SET unit_price = unit_price/1000000

UPDATE analytics
SET unit_price = ROUND(unit_price, 2) 

---Questions & Answers

--Answer the following questions and provide the SQL queries used to find the answer.
--Question 1: Which cities and countries have the highest level of transaction revenues on the site?

SQL Queries:

--1A (Countries with the highest level of transaction revenues)
SELECT country, ROUND(SUM(totaltransactionrevenue), 2) AS TotalRevCountry 
FROM all_sessions
WHERE city IS NOT null AND totaltransactionrevenue IS NOT null
GROUP BY country 
ORDER BY TotalRevCountry DESC
LIMIT 5;

--1B (Cities with the highest level of transaction revenues)
SELECT city, country, ROUND(SUM(totaltransactionrevenue), 2) AS TotalRevCity 
FROM all_sessions
WHERE city IS NOT null AND totaltransactionrevenue IS NOT null
GROUP BY city, country
ORDER BY TotalRevCity DESC
LIMIT 5;


--Question 2: What is the average number of products ordered from visitors in each city and country?

SQL Queries:
--2A
							
CREATE TABLE temp_tab1 AS	SELECT all_sessions.fullvisitorid, all_sessions.city, all_sessions.country, all_sessions.totaltransactionrevenue, 
							all_sessions.v2productcategory, all_sessions.v2productname, all_sessions.productsku, analytics.units_sold, analytics.unit_price 
							FROM all_sessions
							JOIN analytics ON all_sessions.fullvisitorid = analytics.fullvisitorid
							
CREATE TABLE temp_tab2 AS	SELECT * FROM all_sessions AS alls
							JOIN products AS pro ON alls.productsku = pro.sku
							
CREATE TABLE temp_tab3 AS	SELECT * FROM all_sessions AS alls
							JOIN sales_by_sku AS sbs USING(productsku)
							
CREATE TABLE temp_tab4 AS	SELECT * FROM all_sessions AS alls
							JOIN sales_report AS sr USING(productsku)

--TABLE LEGEND
			--temp_tab1 = allsessions + analytics
			--temp_tab2 = allsessions + products
			--temp_tab3 = allsessions + sales_by_sku
			--temp_tab4 = allsessions + sales_report

SELECT * FROM all_sessions --- (15134 rows)   - ALIAS:alls - fullvisitorid, city, country, totaltransactionrevenue, v2productcategory, v2productname, productsku
SELECT * FROM analytics    --- (1048575 rows) - ALIAS:ana - visitid, fullvisitorid, units_sold, unit_price
SELECT * FROM products     --- (1092 rows) - ALIAS:pro - sku, orderedquantity
SELECT * FROM sales_by_sku ---(462 rows) - ALIAS:sbs - productsku, total_ordered
SELECT * FROM sales_report ---(454 rows) - ALIAS:sr - productsku, total_ordered, name
SELECT * FROM temp_tab1
SELECT * FROM temp_tab2
SELECT * FROM temp_tab3
SELECT * FROM temp_tab4


SELECT country, ROUND(AVG(orderedquantity), 2) AS avg_qty_country
FROM temp_tab2
WHERE orderedquantity IS NOT NULL
GROUP BY country
ORDER BY avg_qty_country DESC;

--2B
SELECT city, country, ROUND(AVG(orderedquantity), 2) AS avg_qty_city
FROM temp_tab2
WHERE orderedquantity IS NOT NULL AND city IS NOT null 
GROUP BY city, country 
ORDER BY avg_qty_city DESC;

--Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?

SQL Queries:
--3A
SELECT country, v2productcategory, COUNT(v2productcategory) AS prd_cat_country
FROM temp_tab1
WHERE country IS NOT null  
GROUP BY country, v2productcategory
ORDER BY prd_cat_country DESC;

--3B
SELECT city, country, v2productcategory, COUNT(v2productcategory) AS prd_cat_city
FROM temp_tab1
WHERE city IS NOT null  
GROUP BY city, country, v2productcategory
ORDER BY prd_cat_city DESC;

--Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?

SQL Queries:

--4A --top-selling product from each country
WITH CTE AS 
			(
  				SELECT country, v2productname AS top_selling_product, 
    			SUM(orderedquantity) AS max_qty_country
  				FROM temp_tab2
  				WHERE country IS NOT NULL AND orderedquantity IS NOT NULL
  				GROUP BY country, v2productname
			),
				RankedTable AS 
				(
  					SELECT country, top_selling_product, max_qty_country,
  					RANK() OVER (PARTITION BY country ORDER BY max_qty_country DESC) AS rank_country 
  					FROM CTE
				)
					SELECT * FROM RankedTable WHERE rank_country = 1;

--4B ---top-selling product from each city
WITH CTE AS 
			(
  				SELECT city, country, v2productname AS top_selling_product, 
    			SUM(orderedquantity) AS max_qty_city
  				FROM temp_tab2
  				WHERE city IS NOT NULL AND country IS NOT NULL AND orderedquantity IS NOT NULL
 				GROUP BY city, country, v2productname
  				ORDER BY max_qty_city DESC
			),
				RankedTable AS 
				(
  					SELECT city, country, top_selling_product, max_qty_city,
    				RANK() OVER (PARTITION BY city ORDER BY max_qty_city DESC) AS rank_city 
  					FROM CTE
				)
					SELECT * FROM RankedTable WHERE rank_city = 1;
					

--Question 5: Can we summarize the impact of revenue generated from each city/country?

SQL Queries:
--5A
SELECT country, ROUND(SUM(totaltransactionrevenue), 2) AS Total_Sum1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Total_Sum1 DESC;

SELECT country, ROUND(MAX(totaltransactionrevenue), 2) AS Total_Max1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Total_Max1 DESC;

SELECT country, ROUND(MIN(totaltransactionrevenue), 2) AS Total_Min1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Total_Min1 DESC;

SELECT country, ROUND(AVG(totaltransactionrevenue), 2) AS Avg_Total1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Avg_Total1 DESC;

--5B
SELECT city, country, ROUND(SUM(totaltransactionrevenue), 2) AS Total_Sum2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Total_Sum2 DESC;

SELECT city, country, ROUND(MAX(totaltransactionrevenue), 2) AS Total_Max2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Total_Max2 DESC;

SELECT city, country, ROUND(MIN(totaltransactionrevenue), 2) AS Total_Min2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Total_Min2 DESC;

SELECT city, country, ROUND(AVG(totaltransactionrevenue), 2) AS Avg_Total2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Avg_Total2 DESC;
 



--Starting with Data questions--

SELECT * FROM all_sessions

--Consider the data you have available to you.  You can use the data to:
--    - find all duplicate records
--    - find the total number of unique visitors (`fullVisitorID`)
--    - find the total number of unique visitors by referring sites
--    - find each unique product viewed by each visitor
--    - compute the percentage of visitors to the site that actually makes a purchase

--    - find all duplicate records

SELECT COUNT(visitid) AS visit_count, MAX(visitid) AS dup_visitid
FROM all_sessions
GROUP BY visitid
HAVING COUNT(visitid) > 1;

--    - find the total number of unique visitors (`fullVisitorID`)

SELECT COUNT(DISTINCT fullvisitorid) 
FROM all_sessions;

--    - find the total number of unique visitors by referring sites

SELECT COUNT(DISTINCT fullvisitorid) 
FROM all_sessions
WHERE channelgrouping = 'Referral';

--    - find each unique product viewed by each visitor

SELECT DISTINCT productsku, fullvisitorid
FROM temp_tab1
WHERE fullvisitorid IS NOT NULL;

--    - compute the percentage of visitors to the site that actually makes a purchase

SELECT CONCAT(ROUND(((SELECT COUNT(fullvisitorid) * 1.0 FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL) /
      (SELECT COUNT(fullvisitorid) FROM all_sessions) * 100), 2), '%') AS Percentage;





