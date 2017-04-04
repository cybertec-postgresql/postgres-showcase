CREATE TABLE t_private (
	id SERIAL PRIMARY KEY,
	username text NOT NULL DEFAULT current_user,
	data text not null
);

RESET ROLE;

CREATE POLICY username_policy ON t_private
FOR ALL
TO PUBLIC
USING (username = current_user);

-- DROP POLICY username_policy ON t_private ;

ALTER TABLE t_private ENABLE ROW LEVEL SECURITY;

-- ALTER TABLE t_private DISABLE ROW LEVEL SECURITY;

SET ROLE TO demorole;
