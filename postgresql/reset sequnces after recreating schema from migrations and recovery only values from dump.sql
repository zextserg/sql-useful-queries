-- If you have for example Django with migrations and you're moving from one server to another 
-- you may want to make a dump with only values with bash command:
-- pg_dump --table=table1 --data-only --column-inserts db1 > export_only_data.sql
-- it will create only INSERT statements with data like: INSERT INTO table1 (id, app_label, model) VALUES (1, 'admin', 'logentry');
-- And then you may want to re-create DB schema using Django migrations and recover data using this dump with only values.
-- So then you may end up with collisions in Sequences and you will not be able to insert any new data after recovered from dump - because of duplicated unique ID errors.
-- To fix this issue you should run this SQL code in your DB after re-creating schema:

DO
$do$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT 
            attrelid::regclass AS table_name, 
            attname AS column_name, 
            pg_get_serial_sequence(attrelid::regclass::text, attname) AS sequence_name
        FROM 
            pg_attribute
        WHERE 
            attrelid IN (SELECT oid FROM pg_class WHERE relkind='r' AND relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname NOT IN ('pg_catalog', 'information_schema')))
            AND attnum > 0
            AND NOT attisdropped
            AND attidentity != ''
    LOOP
        EXECUTE format('SELECT setval(%L, COALESCE(MAX(%I), 1), false) FROM %s', r.sequence_name, r.column_name, r.table_name);
    END LOOP;
END;
$do$;
commit;