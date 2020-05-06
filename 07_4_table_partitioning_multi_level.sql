\c pg_features_demo

/*

As already mentioned, one can also mix different partitioning methods or even use the same method given different columns,
but mostly only 2 different methods are combined with LIST + RANGE or HASH + RANGE being usually the most useful ones -
for example "client" + time, meaning for each client or customer we keep action history of some months and then drop the
old sub-partitions. Below a sample from monitoring domain, borrowed from our pgwatch2 monitoring tool, with the differenece
that there actually the sub-partitions are managed automatically by the metric collector daemon and not created per hand.

FYI - with older Postgres versions it was not really recommended to "overdo" witch such more complex multi-level approaches,
but as of v12 one can have many levels together with thousands of sub-partitions given SQL access specifies also all these
conditions.

*/

-- LIST + RANGE sample

-- when lots of sub-partitions can be forseen then it's a good idea to move them into a separate schema
CREATE SCHEMA subpartitions AUTHORIZATION demorole;

CREATE EXTENSION IF NOT EXISTS btree_gin;

SET ROLE TO demorole;

-- used to "instantiate" separate metric definitions
CREATE TABLE metrics_template (
    time timestamptz NOT NULL DEFAULT now(),
    dbname text NOT NULL,
    data jsonb NOT NULL,
    tag_data jsonb,  -- indexed "columns"
    CHECK (false)
);

CREATE INDEX ON metrics_template USING brin (time);
CREATE INDEX ON metrics_template USING gin (tag_data, time) WHERE tag_data NOTNULL;

/*
Something like below will be done by the pgwatch2 gatherer automatically when user activates some metric 'mymetric' for
a monitored database named 'mydbname'
*/

CREATE TABLE "mymetric"
  (LIKE metrics_template)
  PARTITION BY LIST (dbname);

CREATE TABLE subpartitions."mymetric_mydbname"
  PARTITION OF "mymetric"
  FOR VALUES IN ('mydbname') PARTITION BY RANGE (time);

CREATE TABLE subpartitions."mymetric_mydbname_y2020w01"
  PARTITION OF subpartitions."mymetric_mydbname"
  FOR VALUES FROM ('2020-01-01') TO ('2020-01-07');

INSERT INTO mymetric
    SELECT '2020-01-01', 'mydbname', '{"numbackends": 10}';

SELECT * FROM mymetric;
