What are your risk areas? Identify and describe them.

1. There is a big risk with working with a joined table. For example, I found out that joining the all_sessions table with the analytics table was not useful when answer some questions. 
2. Wrongly imported data.


QA Process:
Describe your QA process and include the SQL queries used to execute it.

1. Validated the dates and ensured they were in a correct format.
2. Checked and ensured all the columns had the appropriate data types.
3. Removed duplicates.
4. Identified outliers and modified them.
5. Identified and worked on missing values and nulls.

Queries used

UPDATE all_sessions
SET city = null
WHERE city = '(not set)' OR city = 'not available in demo dataset'

UPDATE analytics
SET unit_price = unit_price/1000000

UPDATE analytics
SET unit_price = ROUND(unit_price, 2) 


Learnings form the data:

1. The database is extremely messy and inconsistent. In some cases, the city and country do not match.
2. The most reliable key was fullvisitorID, (visitID) even if it also had about 5 duplicated values.
3. The top countries with respect to revenue are USA, Israel, Australia, Canada and Switzerland.
4. The top 5 cities with respect to revenue are San Francisco, Sunnyvale, Atlanta, Palo Alto, and Tel Aviv-Yafo.
5. The top 2 product categories are Home/Apparel/Men's/Men's-T-Shirts and Home/Shop by Brand/YouTube.
6. Average time spent on the website was approximately 3hrs.
7. The month with the highest sales is August 2016.


