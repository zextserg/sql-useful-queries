-- If you create custom sql query for PeriscopeData BI tool 
-- and you have PeriscopeData Filter for some Product with multiple values in your Chart or Dashboard
-- You can pass selected filter values into your SQL to the right place using jinja2 templates:

SELECT * FROM table1
WHERE 1=1
-- Here it looks if something of product_filter was selected in PeriscopeData Filters. It can be done with 2 ways:
AND product = '{{product_filter}}'
AND ["product"=product_filter]