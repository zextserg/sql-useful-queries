-- If you create custom sql query for Metabase BI tool 
-- and you have Metabase Filter for some Product with multiple values in your Chart or Dashboard
-- You can pass selected filter values into your SQL to the right place using jinja2 templates:

SELECT * FROM table1
WHERE 1=1
-- Here it looks if something of product_filter was selected in Metabase Filters
AND
    case
        when "[[{{product_filter}}]]" = '' then 1=1
        else product IN ({{product_filter}})
    end