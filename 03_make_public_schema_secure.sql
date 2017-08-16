/*

For sensitive environments it is recommended to avoid creating object in the "public" schema or even better to secure
the "public" schema like below so that people could not create tables in there and look at other peoples structures.
When still working with the public schema you would also want to set up DEFAULT PRIVILEGES that your "trusted users"
would still get automatic access to new object in the "public" schema.
*/

-- USAGE for schemas allows looking at structures within schemas, a prerequisite for looking at data
-- additionally unprivileged users can create tables, causing IO load and danger of running out of disk space
REVOKE USAGE ON SCHEMA public FROM public;

-- Whitelist needed users later
GRANT USAGE ON SCHEMA public TO demorole;
GRANT USAGE ON SCHEMA public TO demorole_ro;

ALTER DEFAULT PRIVILEGES
    IN SCHEMA public
	GRANT SELECT ON TABLES TO demorole_ro;

