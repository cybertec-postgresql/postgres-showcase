-- Materialized view is a "point in time" copy of the select statement and needs explicit refreshing
-- In other aspects the mat.view acts like a normal table - one can create indexes on it 

CREATE MATERIALIZED VIEW mv_last_months_transactions AS
SELECT * FROM transaction_history
WHERE created_on > current_date - '1month'::interval;

-- refresh the data (blocks selects)
REFRESH MATERIALIZED VIEW mv_last_months_transactions;

-- refresh concurrently needs at least one unique index to "merge" changes effectively
CREATE UNIQUE INDEX ON mv_last_months_transactions (id);
-- "concurrent" refresh allows other sessions to read the view during the update but is slower
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_last_months_transactions;
