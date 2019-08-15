\c pg_features_demo
SET ROLE TO demorole;

/*

Sometimes it is necessary to "shoot down" some own runaway queries from other users. To do that nicely from within SQL (
technically possible also via the OS actually) there are 2 options:

 * pg_cancel_backend - the nice way. Only the query gets canceled. Available for all users for their own queries.
 * pg_terminate_backend - the hard way. User session is "kicked" from the server and needs to authenticate again. Needs
   superuser rights or starting from v10 also possible with the "pg_signal_backend" GRANT.

*/

-- cancel all of your own queries from other sessions / tools
SELECT pg_cancel_backend(pid)
FROM pg_stat_activity
WHERE usename = CURRENT_USER
AND pid != pg_backend_pid();    -- always leave out our newly executing query-- cancel all of your own queries from other sessions / tools

-- cancel own active queries that are running for more than 5min
SELECT pg_cancel_backend(pid)
FROM pg_stat_activity
WHERE usename = CURRENT_USER
AND state != 'idle'
AND now() - query_start > '5min'::interval;

/*
Note though that the best way to guard against your own "runaway" queries is to set appropriate timeouts:
*/
SET statement_timeout TO '30s'; -- effective immediately
ALTER ROLE demorole IN DATABASE pg_features_demo SET statement_timeout  TO '1min';  -- effective on next session

-- NB! When using SET ROLE then it might be a good idea to check who you currently "are" with:
SELECT CURRENT_USER, SESSION_USER;  -- SET ROLE alters CURRENT_USER !


-- terminate all users that are "idling" inside of a transaction
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = current_database()  -- only users from "our" DB
  AND state = 'idle in transaction'
  AND pid != pg_backend_pid();    -- always leave out our newly executing query
