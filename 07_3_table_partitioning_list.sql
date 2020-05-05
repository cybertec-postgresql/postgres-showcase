\c pg_features_demo
SET ROLE TO demorole;

/*

LIST partitioning is probably the least used partitioning method but it gives you very explicit control over where data
for some particular data sets should be stored. This can be for example used to implement some fine controlled "multi-tenant"
behaviour, where some big / active customers for example have their own "table" or maybe also to implement some "hot-cold data"
scenarios where orders, once processed are shifted to a separate partition for faster summary analytics. Note though that
automatic moving of rows between partitions on partitioning key updates are available only from v11.

*/

-- the "main" or "parent" table that users will be interacting with
CREATE TABLE orders_segmented (
    client_id       int8 NOT NULL,
    order_nr        int8 NOT NULL,
    order_date      timestamptz NOT NULL DEFAULT now(),
    -- data columns ...
    UNIQUE (client_id, order_nr)
) PARTITION BY LIST (client_id);

-- data for major customer 1
CREATE TABLE orders_client_1 PARTITION OF orders_segmented FOR VALUES IN (1);
-- data for major customer 2
CREATE TABLE orders_client_2 PARTITION OF orders_segmented FOR VALUES IN (2);
-- 1 shared partition for all the smaller "fish"
CREATE TABLE orders_client_def PARTITION OF orders_segmented DEFAULT;
