\c pg_features_demo
SET ROLE TO demorole;

/*

As of v9.6 Postgres has constantly been building up the parallel query execution - meaning if you have a powerful
multi-core server and are running queries over huge multi-gigabyte datasets then the server can be configured so that
the query is transparently parallelized when Postgres sees that it would make sense. But the server defauls of course
could be non-optimal so for very large data amounts, given you know the server is not overloaded, one can increase the
amount of "worker processes" and thereby make good use of resource. NB! Performance gains are not linear so it makes
rarely sense to go over 8 "workers".

*/

ShOW max_parallel_workers_per_gather;   -- check default "max_parallel_workers_per_gather" setting
SET max_parallel_workers_per_gather TO 4;

-- NB! The maximum effective worker count is limited with "max_worker_processes" and "max_parallel_workers" so it
-- doesn't make sense to set "max_parallel_workers_per_gather" higher that that.
-- Also note that going parallel can potentially increase query memory use in the same magnitude!
