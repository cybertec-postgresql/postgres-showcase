\c pg_features_demo
SET ROLE TO demorole;

/*
Other ways of creating tables are:
    1) using LIKE to use existing tables as a templates and selecting (or leaving out) some constraints/checks/indexes
    2) create table as select ...

Other types of tables are:
    1) temporary tables - auto-removed when session ends and visible only in that session that created them
    2) "unlogged" tables - such tables are not WAL-logged thus a lot faster to work with. Downside is that they're emptied after a crash.
*/

-- create a temporary copy of banking.teller
-- NB! Note that you cannot specify a schema for temp tables
CREATE TEMP TABLE teller_temp(LIKE banking.teller EXCLUDING INDEXES);

-- could also "auto create" a table from select (no indexes, FKs, checks, etc are transferred)
CREATE TEMP TABLE teller_temp_2 AS SELECT * FROM banking.teller WHERE false;

-- unlogged tables are a good option for staging tables that get a lot of updates and can be re-initialized quickly from input data
CREATE UNLOGGED TABLE banking.staging_data AS SELECT * FROM banking.account;
