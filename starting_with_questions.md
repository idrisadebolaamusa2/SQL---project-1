Answer the following questions and provide the SQL queries used to find the answer.

    
**Question 1: Which cities and countries have the highest level of transaction revenues on the site?**


SQL Queries:

--1A (Countries with the highest level of transaction revenues)
```
SELECT country, ROUND(SUM(totaltransactionrevenue), 2) AS TotalRevCountry 
FROM all_sessions
WHERE city IS NOT null AND totaltransactionrevenue IS NOT null
GROUP BY country 
ORDER BY TotalRevCountry DESC
LIMIT 5;
```
--1B (Cities with the highest level of transaction revenues)
```
SELECT city, country, ROUND(SUM(totaltransactionrevenue), 2) AS TotalRevCity 
FROM all_sessions
WHERE city IS NOT null AND totaltransactionrevenue IS NOT null
GROUP BY city, country
ORDER BY TotalRevCity DESC
LIMIT 5;
```

Answer:
Countries: Top 5: United States, Israel, Australia, Canada, Switzerland
Cities: Top 5: San Francisco, Sunnyvale, Atlanta, Palo Alto, Tel Aviv-Yafo 


**Question 2: What is the average number of products ordered from visitors in each city and country?**


SQL Queries:

--2A--average number of products ordered from visitors in each country
```							
CREATE TABLE temp_tab1 AS	SELECT all_sessions.fullvisitorid, all_sessions.city, all_sessions.country, all_sessions.totaltransactionrevenue, 
							all_sessions.v2productcategory, all_sessions.v2productname, all_sessions.productsku, analytics.units_sold, analytics.unit_price 
							FROM all_sessions
							JOIN analytics ON all_sessions.fullvisitorid = analytics.fullvisitorid
```
```							
CREATE TABLE temp_tab2 AS	SELECT * FROM all_sessions AS alls
							JOIN products AS pro ON alls.productsku = pro.sku
```
```							
CREATE TABLE temp_tab3 AS	SELECT * FROM all_sessions AS alls
							JOIN sales_by_sku AS sbs USING(productsku)
```
```						
CREATE TABLE temp_tab4 AS	SELECT * FROM all_sessions AS alls
							JOIN sales_report AS sr USING(productsku)
```


```
SELECT country, ROUND(AVG(orderedquantity), 2) AS avg_qty_country
FROM temp_tab2
WHERE orderedquantity IS NOT NULL
GROUP BY country
ORDER BY avg_qty_country DESC;
```

--2B--average number of products ordered from visitors in each city

```
SELECT city, country, ROUND(AVG(orderedquantity), 2) AS avg_qty_city
FROM temp_tab2
WHERE orderedquantity IS NOT NULL AND city IS NOT null 
GROUP BY city, country 
ORDER BY avg_qty_city DESC;
```

Answer:

*The answers are too long. The answer can be fetched once the above codes are run.



**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**


SQL Queries:

--3A--(product categories) of products ordered from visitors in each country
```
SELECT country, v2productcategory, COUNT(v2productcategory) AS prd_cat_country
FROM temp_tab1
WHERE country IS NOT null  
GROUP BY country, v2productcategory
ORDER BY prd_cat_country DESC;
```

--3B--(product categories) of products ordered from visitors in each city
```
SELECT city, country, v2productcategory, COUNT(v2productcategory) AS prd_cat_city
FROM temp_tab1
WHERE city IS NOT null  
GROUP BY city, country, v2productcategory
ORDER BY prd_cat_city DESC;
```

Answer:

1. The highest orders are in the United States and in the Mountain View city.
2. The most popular product category ordered in the United States and also in the Mountain View city is the Home/Apparel/Men's/Men's-T-Shirts/.
3. The top 3 product categories per country are; (1) Home/Apparel/Men's/Men's-T-Shirts/, (2) Home/Electronics/ and, (3) Home/Shop by Brand/YouTube/. They are all in the United States.
4. The top 3 product categories per city are; (1) Home/Apparel/Men's/Men's-T-Shirts/, (2) Home/Nest/Nest-USA/ and, (3) Home/Electronics/. They are all in the Mountain View city in the United States.




**Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**


SQL Queries:

--4A --top-selling product from each country
```
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
```

--4B ---top-selling product from each city
```
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
```					

Answer:

1. For countries, the top selling product is the **Google Kick Ball**. The quantity sold is #364080 in the United States.
2. For cities, the top selling product is the **Google Kick Ball**. The quantity sold is #30340 in the cities of Chicago, New York and San Francisco, all in the United States.



**Question 5: Can we summarize the impact of revenue generated from each city/country?**

SQL Queries:

--5A (For Countries)
```
SELECT country, ROUND(SUM(totaltransactionrevenue), 2) AS Total_Sum1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Total_Sum1 DESC;
```
```
SELECT country, ROUND(MAX(totaltransactionrevenue), 2) AS Total_Max1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Total_Max1 DESC;
```
```
SELECT country, ROUND(MIN(totaltransactionrevenue), 2) AS Total_Min1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Total_Min1 DESC;
```
```
SELECT country, ROUND(AVG(totaltransactionrevenue), 2) AS Avg_Total1
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Avg_Total1 DESC;
```

--5B (For Cities)
```
SELECT city, country, ROUND(SUM(totaltransactionrevenue), 2) AS Total_Sum2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Total_Sum2 DESC;
```
```
SELECT city, country, ROUND(MAX(totaltransactionrevenue), 2) AS Total_Max2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Total_Max2 DESC;
```
```
SELECT city, country, ROUND(MIN(totaltransactionrevenue), 2) AS Total_Min2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Total_Min2 DESC;
```
```
SELECT city, country, ROUND(AVG(totaltransactionrevenue), 2) AS Avg_Total2
FROM all_sessions
WHERE city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY city, country
ORDER BY Avg_Total2 DESC;
```

Answer:

For countries:
1. The top 5 countries in terms of total revenue generated are; United States, Israel, Australia, Canada, Switzerland.
2. The top 5 countries in terms of average revenue generated are; Israel, Australia, United States, Canada, Switzerland.
3. Even if the United States had the highest revenue, Israel actually generated the highest average revenue. This means, considering how many people visited the site from both countries, on average, visitors from Israel spent more money on the site. 

For cities:
1. The top 5 cities in terms of total revenue generated are; San Francisco, Sunnyvale, Atlanta, Palo Alto, Tel Aviv-Yafo.
2. The top 5 cities in terms of average revenue generated are; Tel Aviv-Yafo, Atlanta, Sydney, Seattle, Sunnyvale.
3. Despite the city San Francisco in the United States generating the highest revenue, Tel Aviv-Yafo in Israel actually generated the highest average revenue. This means, considering how many people visited the site from both cities, on average, visitors from Tel Aviv-Yafo spent more money on the site. 
4. Seattle in the United States, and Sydney in Australia, despite not among the top 5 cities in terms of revenue generated, both feature in the top 5 cities based on average revenue generated because on average they had a lesser amount of visitors that generated their total revenue.






