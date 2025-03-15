-- If you create custom sql query for Apache Superset BI tool 
-- and you have Superset Filter for some Product with multiple values in your Chart or Dashboard
-- You can pass selected filter values into your SQL to the right place using jinja2 templates:

SELECT * FROM table1
WHERE 1=1
-- Here it looks if something of product_filter was selected in Superset Filters
{% if filter_values('product_filter') %}
AND product in ({{ "'" + "','".join(filter_values('product_filter')) + "'" }})
{% endif %}