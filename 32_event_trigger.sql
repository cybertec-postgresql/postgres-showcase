CREATE OR REPLACE FUNCTION rewrite_date_check() RETURNS event_trigger AS
$$
BEGIN
	IF extract('hour' from current_time) BETWEEN 8 AND 17 THEN
		RAISE EXCEPTION 'full table rewrites not allowed during business hours!';
	END IF;
END;
$$
LANGUAGE plpgsql;

RESET ROLE;

CREATE EVENT TRIGGER rewrite_date_check
ON table_rewrite
EXECUTE PROCEDURE rewrite_date_check();

SET ROLE TO demorole;
