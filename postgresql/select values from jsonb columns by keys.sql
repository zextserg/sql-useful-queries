-- If you have a JSONB column type for column 'metadata':
select metadata ->> 'date' as dt,cmetadata ->> 'sender_id' as sender_id from table1