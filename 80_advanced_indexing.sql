\c pg_features_demo
SET ROLE TO demorole;

/*

For good performance it's essential that frequent queries take advantage of indexes.
Next to default/regular (B-tree) indexes Postgres has a lot to offer in that area.

Available index types:

    1) B-tree - the default index, functioning best for highly selective data (high number of distinct values). 
       every row value is stored also in the index.
    2) GIN - Generalized Inverted Index. An "inverted" index, meaning every distinct value is only stored once. designed for 
       highly repetitive data. main use case - "full text" index.       
    3) GiST - Generalized Search Tree. A specialized index type mean mainly to answer questions like - is one value close to 
       another (proximity, KNN), is one value enclosed in another (2/3D coordinates). A GiST index is lossy thus matches still need to
       be fetched from the table. For normal indexes "index only scans" are possible, thus matches are returned from index directly.
       Can be well used also for "fuzzy" search.
    4) SP-GiST - a special version of the above, more effective for repetitive data. few data types supported out of the box.
    5) BRIN - Block Range Indexes allow very small indexes as they only store the biggest and smallest value for a range of blocks
       (128 blocks/pages per defaults). Very efficient for naturally ordered big-data.
    6) Bloom - a special lossy index for cases where multiple different column sets are used for filtering. Supports only equality 
       search (=) and only few common data types.
    7) Hash - hash indexes allow fast searching and compact storage for larger strings for example but are not recommended before 
       Postgres 10, as they're not crash-safe. Equality comparisons only.

Additionally indexes can be declared as:
    * Unique - only one distinct column value allowed over the whole table. NB! When some columns are "nullable" (i.e. without 
      a NOT NULL constraint) then uniqueness is not guaranteed.
    * Multi-column - multiple column are stored in the index. When searching then the leftmost columns should aways be specified
      for effective searching.
    * Partial - with a WHERE condition to index only a subset of all values
    * Functional - value returned by the given function will be stored in the index. The same filter needs to present in the query also
      to be able to benefit from the index.


NB! Not all available data types have support for all index types. Users can add index support themselves though.

And when building indexes the maintenance_work_mem parameter can be increased to speed up the process significantly.

*/

SET search_path TO public;

/* B-tree (default) */

-- the simplest index declaration
CREATE INDEX ON main_datatypes(smallish_integers);

-- unique index with manually specified index name.
-- naming makes sense in conjunction with "IF NOT EXISTS", not to build an index twice. having duplicate indexes is a pure waste.
CREATE UNIQUE INDEX my_index ON main_datatypes(smallish_integers);

-- one can also use the "CONCURRENTLY" keyword to build the index so that other queries would be minimally affected.
CREATE INDEX CONCURRENTLY my_concurrently_built_index ON main_datatypes(smallish_integers);

-- building a partial index, leaving out nulls and negatives
CREATE INDEX ON main_datatypes(smallish_integers) WHERE smallish_integers > 0;

-- building a functional index on first 3 letters of text_data1
CREATE INDEX ON main_datatypes(substring(text_data1, 1, 3));



/* GIN */
RESET role;     -- superuser needed for creating extensions and using COPY PROGRAM

CREATE EXTENSION btree_gin; -- needed for indexing some "usual" datatypes like integers
-- when we compare the B-tree and the GIN index we see that the latter is ~10x smaller
CREATE INDEX ON banking.account USING gin (teller_id);

-- JSONB - index top level keys for a simple NoSQL use case.
CREATE INDEX CONCURRENTLY ON main_datatypes USING gin (json_data);
-- Enables for example following indexed queries:
SELECT * FROM main_datatypes WHERE json_data @> '{"x": 1}';

-- JSONB - index also inner objects/paths
CREATE INDEX ON main_datatypes USING gin (json_data jsonb_path_ops);



/* GiST */

-- implementing exclusion constraints - ensure no time overlappings are possible

CREATE EXTENSION btree_gist;

CREATE TABLE public.room_reservation (
    room text,
    during tsrange,
    EXCLUDE USING GIST (room WITH =, during WITH &&)
);
ALTER TABLE public.room_reservation OWNER TO demorole;

-- similarity search (or fuzzy, or simple kNN), 5 alphabetically most similar places to 'kramertneusiedel' in Austria
-- such fuzzy search could also be combined with other functions from the "fuzzystrmatch" extension.

CREATE TABLE fuzzy_search (name text);
ALTER TABLE fuzzy_search OWNER TO demorole;

CREATE EXTENSION pg_trgm;

COPY fuzzy_search FROM PROGRAM 'curl www.cybertec.at/secret/orte.txt';  -- ~2k names

SET ROLE TO demorole;

CREATE INDEX ON fuzzy_search USING gist (name gist_trgm_ops);

SELECT * FROM fuzzy_search ORDER BY name <-> 'kramertneusiedel' LIMIT 5;


-- indexing geographical objects
CREATE TABLE containing_boxes(box_coords box);

INSERT INTO containing_boxes
  SELECT format('((-%s,-%s),(%s,%s))', floor(random()*100), floor(random()*100), floor(random()*100), floor(random()*100) )::box
  FROM generate_series(1, 1e5);

CREATE INDEX ON containing_boxes USING gist (box_coords);

ANALYZE containing_boxes;   -- gather statistics

EXPLAIN SELECT * FROM containing_boxes WHERE box_coords @> '((2,2),(4,4))';
