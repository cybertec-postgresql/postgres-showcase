-- Materialized view is a "point in time" copy of the select statement and needs explicit refreshing
-- In other aspects the mat.view acts like a normal table - one can create indexes on it 

CREATE MATERIALIZED VIEW mv_last_month_data AS
SELECT * FROM t_demo
WHERE created_on > current_date - '1month'::interval;

-- refresh concurrently needs at least one unique index to "merge" changes effectively
CREATE UNIQUE INDEX ON mv_last_month_data (id);

-- "concurrent" refresh allows other sessions to read the view during the update but is slower
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_last_month_data;
