-- assuming "psql" as execution environment here
\c pg_features_demo

-- Create a role (a.k.a: user, login, group) that is allowed to log in.
-- NB! By default roles are allowed to connect to all databases of a cluster. This does not mean that they can automatically access tables though.
-- But if this is not wanted, per DB connections can be set up with "REVOKE/GRANT CONNECT ON DATABASE"

CREATE ROLE demorole WITH LOGIN;    -- create a normal(unprivileged) user
                                    -- NB! when seeing ERRORs during re-rollout it's normal here as role are "global" objects

-- Will later be set up to only allow selecting data. NB! Note that it recommend to use underscores in role names and no
-- funny characters or spaces. If they're needed (e.g. for full names) then names need to be surrounded by double quotes.
CREATE ROLE demorole_ro WITH LOGIN;

-- turning a normal user to superuser
ALTER ROLE demorole SUPERUSER;
ALTER ROLE demorole NOSUPERUSER;

-- Using USER instead of ROLE means LOGIN grant is implicitly applied and it should typically be used for real (human) users.
-- NB! For human roles (not hierarchical roles) it's also recommended to limit the amount of connections to saveguard the
-- sever from badly written UI tools or runaway scripts.
CREATE USER some_human VALID UNTIL '2020-01-01' CONNECTION LIMIT 5;

-- give "some_human" access to everything "demorole_ro" has. Roles have by default transitive effect - if "demorole_ro"
-- has some rights granted via some other role in a higher hierarchy, you would get it also. To turn off the transitive
-- behaviour one should declare users with the NOINHERIT attribute.
GRANT demorole_ro TO some_human;


-- one can also specify passwords from command line but that's not recommended, if needed then only in md5 form
-- recommended way is to use the psql "\password" command.

ALTER ROLE demorole_ro PASSWORD 'mypass';
-- md5 format, hash generated with "select md5('mypassdemorole_ro')"
ALTER ROLE demorole_ro PASSWORD 'md50aa307ba3b035a4c77e7417a75bf71af';

-- NB! As of PG v10 md5 passwords are not anymore recommended - there's something more secure called "scram-sha-256".
-- But as not all drivers support it yet, it's not the default. But to use it from within "psql" for example:
/*
SET password_encryption to "scram-sha-256";
\password
 */

ALTER DATABASE pg_features_demo OWNER TO demorole;
