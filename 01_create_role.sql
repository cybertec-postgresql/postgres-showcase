-- Create a role (a.k.a: user, login, group) that is allowed to log in.
-- NB! By default roles are allowed to connect to all databases of a cluster. This does not mean that they can automatically access tables though.
-- But if this is not wanted, per DB connections can be set up with "REVOKE/GRANT CONNECT ON DATABASE"
CREATE ROLE demorole WITH LOGIN;

-- Will later be set up to only allow selecting data
CREATE ROLE demorole_ro WITH LOGIN;

-- TODO Super, password, mention other auth methods
