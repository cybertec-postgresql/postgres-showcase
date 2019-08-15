\c pg_features_demo
SET ROLE TO demorole;

/*
PL/pgSQL is a specialized programming language that allows to query data and
provides common features like variables, comparisons, branching (if/else),
error handling, calling other functions. It is a procedural language and should
be chosen when SQL (being an imperative language) cannot solve the problem at
hand - in particular since executing queries with SQL functions can be
optimized moreso by the planner than queries with PL/pgSQL functions.

Stored procedures in PL/pgSQL are beneficial as they provide layering for the
"data logic" (one can do modifications without applications knowing about it)
and usually also improve performance for multi-step data processing scenarios.

In PL/pgSQL there's no distinction between a function (restricted to returning
a single scalar value in Oracle PL/SQL) and a procedure, all stored procedural
code are 'functions' that can return anything (scalars, multiple values, rows
of multiple values or table types) or nothing.

NB! In addition to PL/pgSQL there are dozens of other PL-languages available
for installation for more complex data processing needs - plpython, plperl,
pljava to name a few.
*/

-- a simple sproc returning a scalar
CREATE OR REPLACE FUNCTION say_hello() RETURNS text as
$SQL$
BEGIN
	RETURN 'Hello! Can you hear me?';
END;
$SQL$
LANGUAGE plpgsql;


/*
Note that the above simple function we could (and should) write as a "pure"-SQL
function as this has possible performance benefits due to not needing a context
switch by the execution engine.
*/
CREATE OR REPLACE FUNCTION say_hello_2() RETURNS text as
$SQL$
    SELECT 'Hello! Can you hear me?'::text;
$SQL$
LANGUAGE sql;


-- a stored procedure to performa a "bank transfer" for our banking schema
CREATE OR REPLACE FUNCTION perform_transaction(
    account_from        account.account_id%TYPE,
    account_to          account.account_id%TYPE,
    amount              account.balance%TYPE)
RETURNS VOID AS
$SQL$
DECLARE
  acccount_balance account.balance%TYPE;
BEGIN
  
  SELECT
    balance INTO acccount_balance
  FROM
    account
  WHERE
    account_id = account_from;
  
  IF NOT FOUND THEN
    RAISE EXCEPTION 'Account % not found', account_from;
  END IF;
  
  IF acccount_balance < amount THEN
    RAISE EXCEPTION 'Not enough funds';
  END IF;

  -- NB! Very simplistic approch, lot of problems possible here
  UPDATE account SET balance = balance + amount WHERE account_id = account_to;
  UPDATE account SET balance = balance - amount WHERE account_id = account_from;

END;
$SQL$
LANGUAGE plpgsql;


-- TODO error handling and subtransactions via BEGIN/EXCEPTION/END block
