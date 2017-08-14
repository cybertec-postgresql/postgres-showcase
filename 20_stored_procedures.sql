-- in PL/pgSQL there's no distinction between a function (restricted to returning a single scalar value in Oracle PL/SQL) and a procedure - 
-- all stored procedural code are 'functions' that can return anything (scalars, multiple values, rows of multiple values or table types) or nothing.

CREATE OR REPLACE FUNCTION f1_returns_text() RETURNS text as
$SQL$
BEGIN
	RETURN 'demo';
END;
$SQL$
LANGUAGE plpgsql;


-- stored procedures support error handling and subtransactions via BEGIN/EXCEPTION/END block

CREATE OR REPLACE FUNCTION merge_db(key INT, data TEXT) RETURNS VOID AS
$$
BEGIN
    LOOP
        -- first try to update the key
        UPDATE db SET b = data WHERE a = key;
        IF found THEN
            RETURN;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
            INSERT INTO db(a,b) VALUES (key, data);
            RETURN;
        EXCEPTION WHEN unique_violation THEN
            -- Do nothing, and loop to try the UPDATE again.
        END;
    END LOOP;
END;
$$
LANGUAGE plpgsql;