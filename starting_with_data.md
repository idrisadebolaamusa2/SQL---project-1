--Consider the data you have available to you.  You can use the data to:
--    - find all duplicate records
--    - find the total number of unique visitors (`fullVisitorID`)
--    - find the total number of unique visitors by referring sites
--    - find each unique product viewed by each visitor
--    - compute the percentage of visitors to the site that actually makes a purchase

Question 1:  find all duplicate records

SQL Queries:

```
SELECT COUNT(visitid) AS visit_count, MAX(visitid) AS dup_visitid
FROM all_sessions
GROUP BY visitid
HAVING COUNT(visitid) > 1;

```

Answer: 553


Question 2: find the total number of unique visitors (`fullVisitorID`)

SQL Queries: 

```
SELECT COUNT(DISTINCT fullvisitorid) 
FROM all_sessions;

```

Answer: 14223



Question 3: find the total number of unique visitors by referring sites

SQL Queries: 

```
SELECT COUNT(DISTINCT fullvisitorid) 
FROM all_sessions
WHERE channelgrouping = 'Referral';

```

Answer: 2419



Question 4: find each unique product viewed by each visitor

SQL Queries:

```
SELECT DISTINCT productsku, fullvisitorid
FROM temp_tab1
WHERE fullvisitorid IS NOT NULL;

```

Answer: 1761 unique products



Question 5: compute the percentage of visitors to the site that actually makes a purchase

SQL Queries:

```
SELECT CONCAT(ROUND(((SELECT COUNT(fullvisitorid) * 1.0 FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL) /
      (SELECT COUNT(fullvisitorid) FROM all_sessions) * 100), 2), '%') AS Percentage;

```

Answer: 0.54%


--In the **starting_with_data.md** file, write 3 - 5 new questions that you could answer with this database. For each question, include
The queries you used to answer the question
The answer to the question.


Question 1: How many visitors visited the site from San Francisco?

Queries: 

```
SELECT COUNT(DISTINCT fullvisitorid) AS Tot_Vis_SanF
FROM all_sessions
WHERE city = 'San Francisco';

```

Answer: 432


Question 2: What is the total revenue generated from the United States?

Queries:

```
SELECT country, ROUND(SUM(totaltransactionrevenue), 2) AS Total_Rev_US
FROM all_sessions
WHERE country = 'United States' AND city IS NOT NULL AND totaltransactionrevenue IS NOT NULL
GROUP BY country
ORDER BY Total_Rev_US DESC;

```

Answer: 7061610000.00


Question 3: In which country was the product GGOEGAAX0580 mostly sold?

Queries:

```
SELECT country, SUM(orderedquantity) AS TotalQuantity
FROM temp_tab2
WHERE productsku = 'GGOEGAAX0580'
GROUP BY country
ORDER BY TotalQuantity DESC
LIMIT 1;

```

Answer: 68


Question 4: What percentage amount of total site visitors per country actually placed an order?

Queries:

```
SELECT 
    country, 
    COUNT(DISTINCT fullvisitorid) AS total_visitors,
    COUNT(DISTINCT CASE WHEN totaltransactionrevenue IS NOT NULL THEN fullvisitorid END) AS visitors_with_orders,
    ROUND(
        100 * COUNT(DISTINCT CASE WHEN totaltransactionrevenue IS NOT NULL THEN fullvisitorid END) /
        COUNT(DISTINCT fullvisitorid),
        2
  	     ) AS order_percentage
FROM 
    all_sessions
WHERE 
    country IS NOT NULL
GROUP BY 
    country
ORDER BY
	order_percentage DESC;

```

Answer: "Find solution table in attached pgadmin file, Project AnswersR2.sql"


Question 5: On what date was the maximum revenue generated on the site?

Queries:

```
SELECT date, MAX(totaltransactionrevenue) AS MaxRevenue
FROM temp_tab2
WHERE totaltransactionrevenue IS NOT NULL
GROUP BY date
ORDER BY MaxRevenue DESC
LIMIT 1;

```

Answer: 2016-12-13



