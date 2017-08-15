testmain
testunpriv
testunpriv2
hstore_tbl
hstore_tbl_fail


-- index top level keys for a simple NoSQL use case.
CREATE INDEX CONCURRENTLY ON t_demo USING gin (data);

-- index everything
CREATE INDEX ON t_demo USING gin (data jsonb_path_ops);
