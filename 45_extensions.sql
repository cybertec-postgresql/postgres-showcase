/*

 Extensions can be mean (and do) pretty much anything in PostgreSQL due to the modular core buildup. But basically it can
 be thought of as some additional (versioned) code, written in plain SQL or C, that can be plugged into the server and can
 then typically perform the following tasks:

 * Creating new datatypes and providing operators to work on them
 * Some new tables or views
 * Add new mathematical functions
 * Send emails or contact some Web Services
 * Listen to some events happening on the server, like - error message generated, some data blocks read, ...
 * Add support for new programming language to write Stored Procedures in
 * Alter the behaviour of the Query Planner, executing some query nodes for example on dedicated GPU hardware
 * Manage external data sources - one can declare "virtual tables" in Postgres and when they're selected then data is
   actually pulled for example from MySQL or Oracle
 * Running some SQL periodically in the background (think "Cron")

 Installing extensions requires superuser privileges and in cloud environments typically only very few "safe" extensions
 are allowed via whitelisting.

 NB! As one "can" do basically anything from extensions one should be careful on using them - bad extensions or those
 not meant for your server version could cause crashes for the whole instance. Good news is that a set of good and tested
 extensions comes also from the Postgres project also - it's called the "Contrib" package, which might still need a separate
 install package depending on the OS being used.

 See here for a list of Contrib extensions: https://www.postgresql.org/docs/current/contrib.html
 Some more community ones here: https://pgxn.org

 The most known / useful extensions are:

 * PostGIS - one of the best solutions for storing map/spatial info and finding routes. Needs domain knowledge though
 * pg_stat_statements - enables detailed runtime tracking of query performance (at minimal cost)
 * auth_delay - a must have to make brute-force password guessing harder
 * pgcrypto - for "in database" data encryption/de-cryption and additional hashing functions
 * "uuid-ossp" - generate globally unique identifiers
 * pg_trgm - enables fast "fuzzy search" on texts
 * postgres_fdw - access other Postres databases in a native way
 * citext - a data type ignoring lower / uppercase in all common operations
 * citus - horizontal scaling of data between multiple Postgres nodes
 * pg_cron - run periodic jobs in PostgreSQL
 * pgaudit - full SQL audit trails
 * pgstattuple - functions to determine Bloat level of tables / indexes
 * pg_squeeze - fully automatic Bloat cleanup

 To list all functions (tables, views, types, operators, ...) an extension provides within "psql" one can use:
   \dx+ $some_extension

*/

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
SELECT uuid_generate_v4(); -- generate a random globally unique number
