\c pg_features_demo
SET ROLE TO demorole;

/*
Views allow application layering and can be also used for securing data. They behave the same as tables for GRANT privileges and
don't normally incur any performance hit when selecting.
*/

-- the simplest view possible
CREATE VIEW v_account_balance AS
SELECT account_id, balance FROM account;

GRANT SELECT ON v_account_balance TO public;


-- NB! simple views (selecting from one table basically) allow also inserting, so "check option" might make sense,
-- it avoids inserting data that a user would not be able to see due to WHERE condition
CREATE VIEW v_tellers_for_branch_one AS
SELECT * FROM teller
WHERE branch_id = 1
WITH CHECK OPTION;
