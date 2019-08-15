\c pg_features_demo
SET ROLE TO demorole;

/*

Before v11 of Postgres it was relatively unimportant if stored routines where called functions or procedures (there was
no inherent difference opposite to Oracle for example), but as of v11 "real stored procedures" were added, with own
syntax and special capabilities that shortly could be described as allowing COMMIT-s from within a loop (just like
possible in Oracle). New "CALL" syntax must be used for executing such "procedures", for ole "functions" SELECT can
still be used.

*/

CREATE UNLOGGED TABLE IF NOT EXISTS data_migration AS
    SELECT i AS id, NULL::float AS value
    FROM generate_series(1, 1000) i;  -- 1000 test rows



CREATE OR REPLACE PROCEDURE process_lots_of_data(p_batch_size int)
AS $$
DECLARE
    affected_rows int;
BEGIN
    WHILE true
    LOOP
        UPDATE data_migration
        SET value = random()
        WHERE id IN (SELECT id FROM data_migration WHERE value IS NULL LIMIT p_batch_size);

        GET DIAGNOSTICS affected_rows = ROW_COUNT;

        IF affected_rows = 0 THEN
            EXIT;
        END IF;

        RAISE NOTICE 'Commiting after % rows', p_batch_size;
        COMMIT;
    END LOOP;

END;
$$
LANGUAGE plpgsql;

CALL process_lots_of_data(100);
