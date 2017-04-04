CREATE TABLE t_demo_log (LIKE t_demo EXCLUDING INDEXES);

-- could also do:
-- create table t_demo_log select * from t_demo where false;

-- just best practice
CREATE INDEX ON t_demo_log (id);
CREATE INDEX ON t_demo_log (last_modified_on);
