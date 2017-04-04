-- unlogged tables are not WAL-logged (emptied after a crash) thus a lot faster to work with
CREATE UNLOGGED TABLE t_data_staging (LIKE t_demo);
