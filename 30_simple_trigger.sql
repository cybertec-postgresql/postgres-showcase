-- trigger functions are almost like normal PL/pgSQL function but they can only return "trigger" and have access to some special variables
-- like for example TG_NAME and NEW that allows to modify the to-be-inserted datarow
CREATE OR REPLACE FUNCTION trigger_func_set_last_modified() RETURNS trigger AS
$$
BEGIN
	RAISE WARNING 'executing trigger function: %', TG_NAME;
	NEW.last_modified_on := now();
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER t_demo_history BEFORE INSERT OR UPDATE ON t_demo
FOR EACH ROW
WHEN (NEW.last_modified_on IS NULL)
EXECUTE PROCEDURE trigger_func_set_last_modified();
