\c pg_features_demo
SET ROLE TO demorole;

-- setting a function as default value
-- dropping the function with "cascade" will also remove the "default" declaration
CREATE TABLE func_as_def_param(
	id serial PRIMARY KEY,
	data text NOT NULL DEFAULT say_hello()
);

INSERT INTO func_as_def_param (data) VALUES (default);
