




CREATE TABLE t_demo (
	id serial PRIMARY KEY,
	data jsonb,
	department text NOT NULL,
	created_by text NOT NULL DEFAULT current_user,
	created_on timestamptz NOT NULL DEFAULT now(),
	last_modified_on timestamptz
);

COMMENT ON TABLE t_demo IS 'a simple table';
COMMENT ON COLUMN t_demo.data IS 'JSONB is designed for NoSQL';

INSERT INTO t_demo (data, department)
  VALUES ('{"user_id": 1, "order_items": [{"item_id":3, "code": "EAS123"}]}', 'sales');

-- index top level keys for a simple NoSQL use case.
CREATE INDEX CONCURRENTLY ON t_demo USING gin (data);

-- index everything
CREATE INDEX ON t_demo USING gin (data jsonb_path_ops);

-- Prepare for frequent changes, increase FILLFACTOR
ALTER TABLE t_demo SET (fillfactor=80);
