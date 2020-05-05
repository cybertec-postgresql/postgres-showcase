\c pg_features_demo
SET ROLE TO demorole;

/*

HASH partitioning, available from v11, differentiates quite a lot from LIST and RANGE methods and in short takes care of
even distribution of data for us - we just say how many sub-partitions we need (need to pre-create these as with other
partitioning types) and which column will be used for calculating the hash which then will be used to choose the partition
where some row will land.

Hash partitioning is especially suited for "key-value" or "NoSQL" use cases and it helps to increase query throughput a
lot as user CRUD will be more parallel / contention free and also many background Autovacuum processes can work on the
table simultaneously. Also you can use Postgres safeguarded real primary keys with hashing without problems which is problematic
with other partitioning types.

*/

-- the "main" or "parent" table that users will be interacting with
CREATE TABLE web_sessions (
    session_id        uuid NOT NULL PRIMARY KEY,
    -- data columns ...
    created_on        timestamptz NOT NULL DEFAULT now(),
    last_modified_on  timestamptz,
    session_data      jsonb

) PARTITION BY HASH (session_id);

-- partition to hold data for year 2019
CREATE TABLE web_sessions_0 PARTITION OF web_sessions FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE web_sessions_1 PARTITION OF web_sessions FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE web_sessions_2 PARTITION OF web_sessions FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE web_sessions_3 PARTITION OF web_sessions FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- we keep working with the "main" table ...
INSERT INTO web_sessions(session_id, session_data)
    SELECT 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', '{"auth_token": "eeshu8tiiChe4AeP4junaiyie7thewu5"}';

SELECT * FROM web_sessions; -- 1 row

-- if you want to disable implicit scanning of sub-tables one can use the ONLY keyword
SELECT * FROM ONLY web_sessions; -- 0 rows
