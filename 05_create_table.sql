-- assume "application" role
-- it's a good practice to own all objects by one "application" role, so that changes could be done using the same role, 
-- not requiring the samewhat dangerous "superuser".
SET ROLE TO demorole;


-- CREATE TABLEs for our super-simplified banking schema. For those more familiar with Postgres you may notice the schema is 
-- very similar to the one used by default Postgres benchmarking tool "pgbench"

CREATE TABLE banking_demo.branch(
    branch_id       int NOT NULL PRIMARY KEY,   -- using just "id" for name here is not recommended, the more explicit the better for important stuff
    balance         numeric NOT NULL DEFAULT 0
);

CREATE TABLE banking_demo.teller(
    teller_id       int NOT NULL PRIMARY KEY,
    branch_id       int NOT NULL,
    balance         numeric NOT NULL DEFAULT 0
);

CREATE TABLE banking_demo.account(
    account_id      int NOT NULL PRIMARY KEY,
    branch_id       int NOT NULL,
    teller_id       int NOT NULL,
    balance         numeric NOT NULL DEFAULT 0
);

CREATE TABLE banking_demo.transaction_history(
    teller_id       int NOT NULL,
    branch_id       int NOT NULL,
    account_id      int NOT NULL,
    delta           numeric NOT NULL,
    created_on      timestamp with time zone NOT NULL DEFAULT now()
);

-- Generally it's also a good practice to at least minimally comment the tables and columns for complex applications
COMMENT ON TABLE banking_demo.transaction_history IS 'A simple banking table';
COMMENT ON COLUMN banking_demo.transaction_history.delta IS 'Change in account balance for one transaction';

-- generate 1 branch, 10 tellers for branch, 10K accounts for each teller with random balances

INSERT INTO banking_demo.branch (branch_id)
    VALUES (1);

INSERT INTO banking_demo.teller (teller_id, branch_id)
    SELECT generate_series(1, 10), 1;

INSERT INTO banking_demo.account (account_id, teller_id, branch_id)
    SELECT i, i % 10 + 1, 1 FROM generate_series(1, 1e5) i;


-- Adding foreign keys and indexes
-- (more correct would be to add them before inserting data but also inserts would be slower then)

CREATE INDEX ON banking_demo.account (teller_id);
CREATE INDEX ON banking_demo.account (branch_id);
CREATE INDEX ON banking_demo.transaction_history (account_id);
CREATE INDEX ON banking_demo.transaction_history (teller_id);
CREATE INDEX ON banking_demo.transaction_history (created_on);

ALTER TABLE banking_demo.teller ADD FOREIGN KEY (branch_id) REFERENCES banking_demo.branch;
ALTER TABLE banking_demo.account ADD FOREIGN KEY (branch_id) REFERENCES banking_demo.branch;
ALTER TABLE banking_demo.account ADD FOREIGN KEY (teller_id) REFERENCES banking_demo.teller;
ALTER TABLE banking_demo.transaction_history ADD FOREIGN KEY (branch_id) REFERENCES banking_demo.branch;
ALTER TABLE banking_demo.transaction_history ADD FOREIGN KEY (teller_id) REFERENCES banking_demo.teller;
ALTER TABLE banking_demo.transaction_history ADD FOREIGN KEY (account_id) REFERENCES banking_demo.account;


-- Also when adding/changing a lot of row that will be used immediately it is benefical to explicitly force gathering 
-- of column statistics with ANALYZE
ANALYZE banking_demo.teller;
ANALYZE banking_demo.account;
