CREATE TABLE main_datatypes (
    /* serials aka sequences */
    id          bigserial PRIMARY KEY,   -- serial/bigserial corresponds to int4/int8 and will just auto-attach a DEFAULT sequence
    
    /* numbers */
    smallish_integers      int,            -- int4 or integer,
    large_integers     int8,           -- for big-data i.e. > 2 billion rows
    floating_point     double precision,    -- for non-exact calculations. synonymous with "float8"
    exact_calculations  numeric,    -- for scientific/financial calculations. synonymous with "decimal"

    /* character data */
    text_data1  text,           -- for text data it's generally recommended to just use the "text" type
    text_data2  varchar(200),   -- when limiting input needs to be enforced use varchar(X)
    text_fixed  char(3),        -- for fixed size data like currency codes
    json_data   jsonb,          -- efficiently stored and indexable JSON texts, meant for NoSQL use cases

    /* temporals */
    event_ts    timestamptz,    -- timestamptz = "timestamp with time zone" and should always be used instead of simple "timestamp"
    event_date  date,           -- '2017-08-15'
    event_time  time,           -- '17:35'
    event_duration interval,    -- '1day', '2years 1month', '3h 0m 10s'
    
    is_active   boolean,        -- boolean input can be specified as true/false (case insensitive), t/f, on/off
    
    /* typical auditing fields to track changes of important data*/
    created_by text NOT NULL DEFAULT current_user,
    created_on timestamptz NOT NULL DEFAULT now(),
    last_modified_by text           -- would need a trigger to ensure it's always updated when changing data
    last_modified_on timestamptz,   -- would need a trigger to ensure it's always updated when changing data
);



/* Numerals */

INSERT INTO main_datatypes(large_integers)
  SELECT 1e11;   --100 billion

INSERT INTO main_datatypes(floating_point)
  SELECT 3.14;

/* character data */

INSERT INTO main_datatypes(text_data1)  -- take only first 10 chars of 300
  SELECT repeat('a', 300)::char(10);

--INSERT INTO main_datatypes(text_data2)  -- this will fail as text_data2 allows max 200 chars
--  SELECT repeat('a', 300);

INSERT INTO main_datatypes (json_data)
  VALUES ('{"user_id": 1, "order_items": [{"item_id":3, "code": "EAS123"}], "created_on": "2017-08-15 11:45:28.852685+03"}');



/* 
Temporals - postgres has excellent support for working with times. Here some most used functions.
 */

-- current timestamptz as of beginning of transaction, thus we'll see the same values
BEGIN;
SELECT now();
SELECT now();
END;

-- same
SELECT 'now'::timestamptz;

-- current timestamptz in real time, different values
BEGIN;
SELECT clock_timestamp();
SELECT clock_timestamp();
END;

-- current date
SELECT 'today'::date;
SELECT current_date;
SELECT now()::date;

-- using interval to get exact date of 90 days ago
SELECT current_date - '90d'::interval;

-- current UNIX epoch seconds
SELECT extract(epoch FROM now());

-- generate all dates for the last week
SELECT generate_series(date_trunc('week', now() - '1 week'::interval),
                       date_trunc('week', now()) - '1day'::interval, '1day');

-- same as above but with ORDINALITY
SELECT
  * 
FROM generate_series(date_trunc('week', now() - '1 week'::interval), date_trunc('week', now()) - '1day'::interval, '1day')
    WITH ORDINALITY t(date, day_of_week);
