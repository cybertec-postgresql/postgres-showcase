\c pg_features_demo
SET ROLE TO demorole;

/*

When it can be already foreseen that a table will grow huge (100+ GB) or there is for example a "hot data" / "cold data"
scenario, then it makes sense to think about splitting up the table to so called partitions. And the good thing is that
starting from v10 there is native support for that - so that users can continue to work with the "main" or "top level"
table and not care or know about the sub-partitions where data rows are actually living in.

Different partitioning models available:

1) Range based - typically used for having yearly / monthly / weekly partitions.
2) List based - to explicitly "tell" that rows with specific column(s) values need to go to a specific table
3) Hash based - for cases where you need X sub-tables evenly filled, but Postgres can choose the exact distribution


NB! As of Postgres v12 support for partitioning is almost complete - only automatic creation of sub-partitions and some
primary key limitations remain, but previous versions had some more limitations so it's recommended to read through the
documentation before taking them into use on pre v12.

*/

-- the "main" or "parent" table that users will be interacting with
CREATE TABLE orders (
    order_nr        int8 NOT NULL ,
    order_date      timestamptz NOT NULL DEFAULT now()
    -- data columns ...
) PARTITION BY RANGE (order_date);

-- partition to hold data for year 2019
CREATE TABLE orders_y2019 PARTITION OF orders FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');

-- we keep working with the "main" table ...
INSERT INTO orders
    SELECT 1;

SELECT * FROM orders; -- 1 row

-- if you want to disable implicit scanning of sub-tables one can use the ONLY keyword
SELECT * FROM ONLY orders; -- 0 rows

/*

NB! Partition hierarchies can be built many levels deep if needed and mixing different partitioning models - to see the
whole "tree" one can use the pg_partition_tree() function or for direct descendants of a table use the "psql" \d+ helper

*/
