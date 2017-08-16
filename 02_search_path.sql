/* 

Important concept tied to schemas is "search_path". Basically it's a priority list of schemas, 
used to look for objects when the schema name is not specified by user. Can be set by all users in their session,
but when using multiple schemas it usually makes sense to set it DB-wide to decrease amount of typing.
Schemas can also be used to do sort of "API versioning" when using views or stored procedures.

*/

-- default search path
SELECT current_setting('search_path') AS default_search_path;

-- currently we need to type for example something like that:
-- SELECT count(*) from banking.tableX

-- will become active on next login or after server settings reload
ALTER DATABASE pg_features_demo SET search_path TO public, banking;
-- for this session also
SET search_path TO public, banking;

-- after that we can for example query tables from the "banking" schema without specifying the schema explicitly:
-- SELECT count(*) from tableX
