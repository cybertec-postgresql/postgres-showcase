/*
Other ways of creating tables are:
    1) using LIKE to use existing tables as a templates and selecting (or leaving out) some constraints/checks/indexes
    2) create table as select ...

Other types of tables are:
    1) temporary tables - auto-removed when session ends and visible only in that session that created them
    2) "unlogged" tables - such tables are not WAL-logged thus a lot faster to work with. Downside is that they're emptied after a crash.
*/

-- create a temporary copy of banking_demo.teller
-- NB! Note that you cannot specify a schema for temp tables
CREATE TEMP TABLE teller_temp(LIKE banking_demo.teller EXCLUDING INDEXES);

-- could also "auto create" a table from select (no indexes, FKs, checks, etc are transferred)
CREATE TEMP TABLE teller_temp_2 AS SELECT * FROM banking_demo.teller WHERE false;

-- unlogged tables are a good option for staging tables that get a lot of updates and can be re-initialized quickly from input data
CREATE UNLOGGED TABLE banking_demo.staging_data AS SELECT * FROM banking_demo.account;
