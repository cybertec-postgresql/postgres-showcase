\c pg_features_demo
SET ROLE TO demorole;

/*
PL/pgSQL is a specialized programming language that allows to query data and provides common features like variables, comparisons, 
branching (if/else), error handling, calling other functions.

Stored procedures in PL/pgSQL are beneficial as they provide layering for the "data logic" (one can do modifications 
without applications knowing about it) and usually also improve performance for multi-step data processing scenarios.

In PL/pgSQL there's no distinction between a function (restricted to returning a single scalar value in Oracle PL/SQL) and a procedure, 
all stored procedural code are 'functions' that can return anything (scalars, multiple values, rows of multiple values or table types) 
or nothing.

NB! In addition to PL/pgSQL there are dozens of other PL-languages available for installation for more complex data processing needs - 
plpython, plperl, pljava to name a few.
*/

-- a simple sproc returning a scalar
CREATE OR REPLACE FUNCTION say_hello() RETURNS text as
$SQL$
BEGIN
	RETURN 'Hello! Can you hear me?';
END;
$SQL$
LANGUAGE plpgsql;


-- note that above functions we could (and should) write in pure SQL as this has some performance benefits
CREATE OR REPLACE FUNCTION say_hello_2() RETURNS text as
$SQL$
    SELECT 'Hello! Can you hear me?'::text;
$SQL$
LANGUAGE sql;


-- a stored procedure to performa a "bank transfer" for our banking schema
CREATE OR REPLACE FUNCTION perform_transaction(
    account_from        account.account_id%TYPE,
    account_to          account.account_id%TYPE,
    amount_to_transfer  account.balance%TYPE)
RETURNS VOID AS
$SQL$
DECLARE
  acccount_balance account.balance%TYPE;
BEGIN
  
  SELECT balance INTO acccount_balance FROM account WHERE account_id = account_from;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account % not found', account_from;
  END IF;
  
  IF acccount_balance < amount_to_transfer THEN
    RAISE EXCEPTION 'Not enough funds';
  END IF;

  UPDATE account SET balance = balance + amount_to_transfer WHERE account_id = account_to;      -- NB! Very simplistic approch, lot of problems possible here
  UPDATE account SET balance = balance - amount_to_transfer WHERE account_id = account_from;

END;
$SQL$
LANGUAGE plpgsql;


-- TODO error handling and subtransactions via BEGIN/EXCEPTION/END block
