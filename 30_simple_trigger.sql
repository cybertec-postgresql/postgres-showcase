\c pg_features_demo
SET ROLE TO demorole;

/*
Triggers function similar to other RDBMSs - first you declare a "trigger function" and then the trigger itself on a specific table. Thus 
one fuction can be used for X tables. Trigger functions are almost like normal PL/pgSQL function but they can only return "trigger" 
and have access to some special variables like for example TG_NAME and NEW that allows to modify the to-be-inserted rows before storage.
*/

CREATE OR REPLACE FUNCTION trg_last_changed() RETURNS trigger AS
$$
BEGIN
	RAISE WARNING 'executing trigger function: %', TG_NAME;
    NEW.last_modified_on := now();
	NEW.last_modified_by := session_user;
	RETURN NEW;    -- retruning NULL would mean that the row won't be inserted!
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER audit_fields_update BEFORE INSERT OR UPDATE ON main_datatypes
FOR EACH ROW
WHEN (NEW.last_modified_on IS NULL OR NEW.last_modified_by IS NULL) -- usage of WHEN can speed up things
EXECUTE PROCEDURE trg_last_changed();
