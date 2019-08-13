-- NB! Dropping databases will fail if there are sessions connected to it. In such cases connected users can be for exmple "killed" with:
SELECT count(*) AS sessions_killed FROM (SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'pg_features_demo' AND pid != pg_backend_pid()) a;

DROP DATABASE IF EXISTS pg_features_demo;


CREATE DATABASE pg_features_demo;

/* Background info:

One Postgres cluster (called also a host or an instance, distinguished by a unique network IP+port pair) can have X amount of databases 
that only share user accounts (roles) and some other global objects like tablespaces (if any in use) and system statistics views.

In case of multiple environments (enterprize scenario) it is highly recommended to include the environment name into the DB name, to 
minimize chances of executing things on the wrong DB - e.g. dev_app1_db, prod_app1_db.

*/
