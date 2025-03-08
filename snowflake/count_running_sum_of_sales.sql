-- Sales between re-stocks 
-- The ‘Store Stock Data’ provided below gives the stock levels of several stores by day over a given time period. 
-- The stock level field provided is the stock level at store opening time. 

-- Tasks:  
-- For each store use SQL to find and display in a table: 
-- a. The maximum quantity of sales between consecutive deliveries of extra stock to the store.
-- b. The date period over which this period of maximum sales occurred.

-- To simplify the problem, you may assume that: 
-- 1. Deliveries are made in the morning before a store opens, but not every day - it can be after several days. 
-- 2. Deliveries are always of size 100. 
-- 3. There are never more than 99 sales in one day. 

-- Store Stock Data:  
-- can be found in initial_data.csv

-- Results should be:
-- STORE	MAX_SALES	DATES_PERIOD
-- A	422	from 2025-09-03 to 2025-11-20
-- B	375	from 2025-10-01 to 2025-12-11
-- C	369	from 2025-10-04 to 2025-12-11
-- D	262	from 2023-10-24 to 2023-12-23
-- E	420	from 2025-07-25 to 2025-10-11
-- F	321	from 2025-09-29 to 2025-11-28
-- G	414	from 2025-05-14 to 2025-07-31

-- I use Windows Functions with SnowFlake special functions - LEAD, LAG, CONDITIONAL_TRUE_EVENT to get running sum of sales:
SELECT store, max_sales, 'from ' || MIN(dt) || ' to ' || MAX(dt) as dates_period
FROM 
(
    SELECT store, dt, today_sales_cnt, day_type, sum_part, sums, 
           MAX(sums) OVER (PARTITION BY store, sum_part) as max_sales_of_part, 
           MAX(sums) OVER (PARTITION BY store) as max_sales
    FROM 
    (
        SELECT store, dt, today_sales_cnt, day_type, sum_part, 
               SUM(today_sales_cnt) OVER (PARTITION BY store, sum_part  ORDER BY store, dt) as sums
        FROM 
        (
            SELECT store, dt, today_sales_cnt, day_type, 
                   CONDITIONAL_TRUE_EVENT(day_type) OVER (PARTITION BY store  ORDER BY store, dt) as sum_part
            FROM 
            (
                SELECT store, dt, opening_stock,
                       CASE WHEN opening_stock - LEAD(opening_stock, 1) OVER (PARTITION BY store ORDER BY dt) < 0 
                              THEN (opening_stock - LEAD(opening_stock, 1) OVER (PARTITION BY store ORDER BY dt)) + 100
                              ELSE (opening_stock - LEAD(opening_stock, 1) OVER (PARTITION BY store ORDER BY dt))
                       END as today_sales_cnt,
                       CASE WHEN opening_stock - (LAG(opening_stock, 1) OVER (PARTITION BY store ORDER BY dt)) > 0  
                              THEN 1 
                       ELSE 0 END as day_type
                FROM 
                (
                    SELECT store, dt, opening_stock 
                      FROM initial_data.csv
                  ORDER BY store
                ) as init
                ORDER BY store, dt
            ) as scnt
            ORDER BY store, dt
        ) as sumscnt
        ORDER BY store, dt
    ) as maxsumscnt
) as agg_all
WHERE max_sales_of_part = max_sales
GROUP BY store, max_sales
ORDER BY store