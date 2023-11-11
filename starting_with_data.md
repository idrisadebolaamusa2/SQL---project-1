Question 1: 

SQL Queries:

SELECT COUNT(visitid) AS visit_count, MAX(visitid) AS dup_visitid
FROM all_sessions
GROUP BY visitid
HAVING COUNT(visitid) > 1;

Answer: 553


Question 2: 

SQL Queries: 

SELECT COUNT(DISTINCT fullvisitorid) 
FROM all_sessions;

Answer: 14223



Question 3: 

SQL Queries: 

SELECT COUNT(DISTINCT fullvisitorid) 
FROM all_sessions
WHERE channelgrouping = 'Referral';

Answer: 2419



Question 4: 

SQL Queries:

SSELECT DISTINCT productsku, fullvisitorid
FROM temp_tab1
WHERE fullvisitorid IS NOT NULL;

Answer: 1761



Question 5: 

SQL Queries:

SELECT CONCAT(ROUND(((SELECT COUNT(fullvisitorid) * 1.0 FROM all_sessions WHERE totaltransactionrevenue IS NOT NULL) /
      (SELECT COUNT(fullvisitorid) FROM all_sessions) * 100), 2), '%') AS Percentage;

Answer: 0.54%
