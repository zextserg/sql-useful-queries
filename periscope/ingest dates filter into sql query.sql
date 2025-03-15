-- If you create custom sql query for PeriscopeData BI tool 
-- and you have PeriscopeData DatesRange filter in your Chart or Dashboard pointing to your date column 'created_at'
-- You can pass selected filter values into your SQL to the right place using PeriscopeData templates:

SELECT * FROM table1 
WHERE 1=1
-- Here it ingest selected dates range in PeriscopeData Filters. It can be done with timezone or not:
AND ["created_at"=daterange]
AND ["created_at:eat"=daterange]