/*
ALTER TABLE is mostly commonly used to:
    1) add/drop/rename columns
    2) add/drop constraints (FKs, checks, not null)
    3) set column defaults
    4) change column data types
    5) add/drop triggers
    6) declare inheritance (used typically for partitioning which will be built-in from Postgres 10)
    7) changing physical storage parameters
    8) a lot more, see docus...
*/

-- adding a new column
-- note that here we also demonstrate that changing the structure can be performed transactionally!! (unlike in Oracle for example)
BEGIN;
ALTER TABLE staging_data ADD COLUMN extra_info TEXT;
ALTER TABLE staging_data ALTER COLUMN extra_info SET DEFAULT 'hello';
COMMIT;
-- also note that for big tables on busy DBs the above 2-step form is much preferred over below form as it won't re-write the whole table:
-- ALTER TABLE account_unlogged ADD COLUMN extra_info TEXT DEFAULT 'hello';

-- adding a simple check constraint
ALTER TABLE staging_data ADD CONSTRAINT my_check CHECK (account_id > 0);

-- change column data type. NB! mostly it means a full table re-write so be wary.
ALTER TABLE staging_data ALTER COLUMN extra_info TYPE varchar(500);


/*
A significant performance tweaking option for tables is the FILLFACTOR parameter.
It tells Postgres to fill up tables only to specified percentage, so that future row updates would
have a chance to be performed "in line" (called HOT-updates). Some "terms and conditions" apply but for certain usecases (a lot of 
updates on un-indexed columns) huge boosts are possible. Fillfactor can be also specified similarily when creating the table.
*/
ALTER TABLE staging_data SET (FILLFACTOR=80);
