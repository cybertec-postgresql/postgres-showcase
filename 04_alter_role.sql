-- effective with next login
ALTER ROLE demorole IN DATABASE pg_features_demo SET search_path TO demo, public;
ALTER ROLE demorole_ro IN DATABASE pg_features_demo SET search_path TO demo, public;
ALTER ROLE demorole_ro IN DATABASE pg_features_demo SET statement_timeout TO '5s';
