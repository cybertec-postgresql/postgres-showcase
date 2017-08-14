/*
Other ways of creating tables are:
    1) using LIKE to use an existing table as a templates and selecting (or leaving out) some constraints/checks/indexes
    2) create table as select ...
*/

-- create a copy of 
CREATE TABLE temp  (LIKE t_demo EXCLUDING INDEXES);

-- could also do:
-- create table t_demo_log as select * from t_demo where false;


/*
Other types of tables are:
    1) temporary tables
    2) "unlogged" tables
*/

-- temporary tables are not persistent and visible only in that session that created them
CREATE TEMP TABLE t (LIKE t_demo);

-- unlogged tables are not WAL-logged (emptied after a crash) thus a lot faster to work with
CREATE UNLOGGED TABLE t_data_staging (LIKE t_demo);

