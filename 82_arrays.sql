/*

Arrays can be composed from all data types and are first class citizens in Postgres, being used a lot for internal catalogs.
Suitable for declaring table columns as any other data types. Mostly a de-normalization technique that provides performance benefits.

NB! Arrays can be declared with specific dimensions but internal representation is dimension-agnostic so some carefulness is required 
when inserting data.

Docus:
    https://www.postgresql.org/docs/current/static/arrays.html
    https://www.postgresql.org/docs/current/static/functions-array.html

*/

-- simple array declaration
SELECT array[1,2,3];

-- simple array declaration in native text form
SELECT '{1,2,3}'::int[];

-- creating an array from aggregate
SELECT array_agg(x) FROM (SELECT 1 AS x UNION SELECT 2) y;

-- creating an array from aggregate with ordering
SELECT array_agg(x ORDER BY x DESC) FROM (SELECT 1 AS x UNION SELECT 2) y;

-- multi-dimensional arrays - a 3x3 matrix
CREATE TABLE matrix(value int[][]);
INSERT INTO matrix SELECT '{{1,2,3},{1,2,3},{1,2,3}}';

-- adding an element to array
SELECT array[1,2,3] || 4;
SELECT array_append(ARRAY[1,2], 3);

-- adding elements to array
SELECT array[1,2,3] || array[4, 5];
SELECT array_cat(array[1,2,3], array[4, 5]);

-- accessing a specific item via index (indexes start with 1)
SELECT (array[1,2,3])[1];

-- is a value or sub-array contained in an array?
SELECT array[1,2,3] @> array[1];
SELECT array[1,2,3] @> array[1, 2];

-- determining array length. NB! you must input the dimension
SELECT array_length(array[1,2,3], 1);

-- determining the dimensions of an array
SELECT array_ndims(ARRAY[[4,5,6],[7,8,9]]);

-- unnesting an array for joins etc
SELECT unnest(array[1,2,3]) AS x;

-- turning an array into a string
SELECT array_to_string(ARRAY[1, 2, 3, NULL, 5], ',', '*');

-- "intarray" extension provides also support for indexing integer arrays to enable fast search for large arrays
CREATE TABLE intarray(id serial, value int[]);

RESET ROLE;
CREATE EXTENSION intarray;
SET ROLE TO demorole;

INSERT INTO intarray(value)
  SELECT (SELECT array_agg(x) FROM (SELECT generate_series(1,100) x) y)
  FROM generate_series(1,10);

CREATE INDEX ON intarray USING GIST (value gist__int_ops);

EXPLAIN SELECT count(*) FROM intarray WHERE value @> '{1,2}';
