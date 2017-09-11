\c pg_features_demo

-- It's possible to set global, or per user or per user/db settings. Most used such settings are search_path and statement_timeout.
-- Changes are effective with next login.

ALTER ROLE demorole IN DATABASE pg_features_demo SET search_path TO public, banking;
ALTER ROLE demorole_ro IN DATABASE pg_features_demo SET search_path TO public, banking;
ALTER ROLE demorole_ro IN DATABASE pg_features_demo SET statement_timeout TO '5s';
