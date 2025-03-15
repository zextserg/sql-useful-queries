-- If you create custom sql query for Metabase BI tool 
-- and you have Metabase Dates filter in your Chart or Dashboard pointing to your date column 'created_at'
-- (it can be both selected date_from and date_to, OR just one date_from with Rule: BEFORE, EQUAL)
-- You can pass selected filter values into your SQL to the right place using Metabase templates:

WITH dates AS (
    SELECT SAFE_CAST(REGEXP_EXTRACT_ALL('[[{{created_at}}]]', r"[12][0-9]{3}-[0-9]{2}-[0-9]{2}")[SAFE_ORDINAL(1)] AS DATE) as date_from,
    SAFE_CAST(REGEXP_EXTRACT_ALL('[[{{created_at}}]]', r"[12][0-9]{3}-[0-9]{2}-[0-9]{2}")[SAFE_ORDINAL(2)] AS DATE) as date_to,
    REGEXP_EXTRACT('[[{{created_at}}]]', r"[><=]{1}") as date_rule
)
SELECT * FROM table1 
WHERE 1=1
-- Here it looks if both date_from and date_to were selected in Metabase Filters
-- In case when Filter was NOT selected - it will be equal value: '1 = 1'
AND
case
    when '[[{{created_at}}]]' = '1 = 1' then 1=1
    else
        CASE
            WHEN (SELECT date_rule FROM dates) is NULL THEN
                Date(created_at, 'Europe/Moscow') >= (SELECT date_from FROM dates)
                AND Date(created_at, 'Europe/Moscow') <= (SELECT date_to FROM dates)
            WHEN (SELECT date_rule FROM dates) = '=' THEN
                Date(created_at, 'Europe/Moscow') = (SELECT date_from FROM dates)
            WHEN (SELECT date_rule FROM dates) = '>' THEN
                Date(created_at, 'Europe/Moscow') >= (SELECT date_from FROM dates)
            WHEN (SELECT date_rule FROM dates) = '<' THEN
                Date(created_at, 'Europe/Moscow') <= (SELECT date_from FROM dates)
            ELSE 1=1
        END
end