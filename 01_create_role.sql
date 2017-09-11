-- assuming "psql" as execution environment here
\c pg_features_demo

-- Create a role (a.k.a: user, login, group) that is allowed to log in.
-- NB! By default roles are allowed to connect to all databases of a cluster. This does not mean that they can automatically access tables though.
-- But if this is not wanted, per DB connections can be set up with "REVOKE/GRANT CONNECT ON DATABASE"

CREATE ROLE demorole WITH LOGIN;    -- create a normal(unprivileged) user
                                    -- NB! when seeing ERRORs during re-rollout it's normal here as role are "global" objects

-- Will later be set up to only allow selecting data
CREATE ROLE demorole_ro WITH LOGIN;

-- turning a normal user to superuser
ALTER ROLE demorole SUPERUSER;
ALTER ROLE demorole NOSUPERUSER;

-- one can also specify passwords from command line but that's not recommended, if needed then only in md5 form
-- recommended way is to use the psql "\password" command.

ALTER ROLE demorole_ro PASSWORD 'mypass';
-- md5 format, hash generated with "select md5('mypassdemorole_ro')"
ALTER ROLE demorole_ro PASSWORD 'md50aa307ba3b035a4c77e7417a75bf71af';

ALTER DATABASE pg_features_demo OWNER TO demorole;
