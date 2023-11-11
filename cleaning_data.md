What issues will you address by cleaning the data?

1. Would be able to clean the database, normalize it and make better decisions from it.
2. I would be able to transform and analyze the ecommerce database using pg_admin. 
3. To answer questions by running codes and querying the database.
4. To help with insight into the ecommerce database.
5. To help us make key decisions based on customer spending patterns on the websites.




Queries:
Below, provide the SQL queries you used to clean your data.

UPDATE all_sessions
SET city = null
WHERE city = '(not set)' OR city = 'not available in demo dataset'

UPDATE analytics
SET unit_price = unit_price/1000000

UPDATE analytics
SET unit_price = ROUND(unit_price, 2) 