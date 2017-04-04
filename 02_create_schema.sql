CREATE SCHEMA IF NOT EXISTS demo AUTHORIZATION demorole;

-- "usage" for schemas allows looking at structures within schemas
-- "public" means all users
GRANT USAGE ON SCHEMA demo TO public;

ALTER DEFAULT PRIVILEGES IN SCHEMA demo
	GRANT SELECT ON TABLES TO demorole_ro;
