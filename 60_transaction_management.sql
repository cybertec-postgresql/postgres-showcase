/*
Transaction management is a complex topic but most importantly one should know that Postgres has 3 different isolation levels:
    
    1) READ COMMITED - the default TX model. Means that inside your transaction you'll immediately see (with your next query) data 
    that is commited by other transactions.
    
    2) REPEATABLE READ - in this mode you will get a "snapshot" of data, meaning you will not see changes made by others. This is often 
    needed for correct reporting, involving multiple queries. Note that it is not good to keep such transactions open for longer periods
    as it hinders Postgres cleanup of deleted rows (autovacuum), causing so called "bloat".
    
    3) SERIALIZABLE - this is the most isolated TX mode. It removes the threat of silent data inconsistency for concurrent access but 
    brings also substantial performance penalties.

    NB! Modes 2 and 3 can cause errors to be thrown when doing data modifications (as your row value that you plan to update might have 
    been actually updated by some other transaction) so one should have re-try mechanisms in place for applications.
    
    For developing critical applications it is highly recommended to understand TX models in detail. Docus:
    https://www.postgresql.org/docs/current/static/transaction-iso.html
*/


-- starting a "REPEATABLE READ" transaction
-- NB! note that the snapshot will only be taken after issuing the first query
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT 1;   -- now we have a snapshot - issuing identical selects will give exactly the same results
ROLLBACK;

-- you can check the current TX isolation level with
SHOW transaction_isolation;
