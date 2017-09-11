\c pg_features_demo
SET ROLE TO demorole;

CREATE OR REPLACE FUNCTION rewrite_date_check() RETURNS event_trigger AS
$$
BEGIN
    -- disallow full re-writes of the "account" table during business hours as it could block all operations
    IF pg_event_trigger_table_rewrite_oid() = 'banking_schema.account'::regclass THEN
    	IF extract('hour' from current_time) BETWEEN 8 AND 17 THEN
    		RAISE EXCEPTION 'full table rewrites not allowed during business hours!';
    	END IF;
    END IF;
END;
$$
LANGUAGE plpgsql;

RESET ROLE; -- managing event triggers needs superuser privileges

CREATE EVENT TRIGGER rewrite_date_check
ON table_rewrite
EXECUTE PROCEDURE rewrite_date_check();

SET ROLE TO demorole;
