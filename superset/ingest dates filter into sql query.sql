-- If you create custom sql query for Apache Superset BI tool 
-- and you have Superset Dates filter in your Chart or Dashboard
-- You can pass selected filter values into your SQL to the right place using jinja2 templates:

SELECT * FROM table1 
WHERE 1=1
-- Here it looks if both date_from and date_to were selected in Superset Filters
{% if from_dttm and to_dttm %}
AND date_column >= Date('{{"{}".format(from_dttm.isoformat())}}') 
AND date_column <= Date('{{"{}".format(to_dttm.isoformat())}}')
{% endif %}