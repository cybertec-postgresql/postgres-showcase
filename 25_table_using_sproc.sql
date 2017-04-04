-- setting a function as a default value
-- dropping the function with "cascade" will also remove the "default" declaration. code updates with "replace" are non-blocking
CREATE TABLE t_func_as_def_param(
	id serial PRIMARY KEY,
	data text NOT NULL DEFAULT f1_returns_text()
);

INSERT INTO t_func_as_def_param (data) VALUES (default);
