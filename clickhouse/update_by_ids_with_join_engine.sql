-- Now we have 'table1' with columns (id, name, value)
-- And we nneed to update 'name', 'value' using data from 'other_table' by corresponding ids:

-- First we create join table from select from 'other_table' with new needed values:
CREATE TABLE temp_join_table 
ENGINE = Join(ANY, LEFT, id) AS
SELECT id, new_name, new_value
  FROM other_table

-- now - UPDATE values in 'table1' according to new created Join table:
ALTER TABLE table1
     UPDATE name = joinGet('temp_join_table', 'new_name', id),
            value = joinGet('temp_join_table', 'new_value', id)
     WHERE true

-- Check how goes updating
SELECT
    command,
    is_done
FROM system.mutations
WHERE table = 'table1'

-- all done if it shows 'is_done= 1':
--    ┌─command───────────────────────────────────────────────────────────────────────────────────────────────────────────────────┬─is_done─┐
-- 1. │ UPDATE name = joinGet('temp_join_table', 'new_name', id), value = joinGet('temp_join_table', 'new_value', id) WHERE true  │       1 │
--    └───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┴─────────┘

-- After updating don't forget to drop temp table for joining purpose - temp_join_table! 
-- Because it's located in the Memory and may decrease your MEMORY_LIMIT:
DROP TABLE temp_join_table;