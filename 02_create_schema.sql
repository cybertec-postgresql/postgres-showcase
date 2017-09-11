\c pg_features_demo

/*
Schemas in Postgres are basically "namespaces", allowing tables with same names within one DB, if schema names differ.
By default there is always one "public" schema pre-created with every database, but for bigger applications it is usually 
preferable to create more schemas to logically group business functionality: e.g. customer_data, product_data.
 
Hierarchy of objects is thus such:   Cluster -> Database -> Schema -> Table
*/
CREATE SCHEMA IF NOT EXISTS banking AUTHORIZATION demorole;     -- here we create a schema for our demo banking app

/*
When creating schemas, one also usually should define according access privileges.
"USAGE" privilege for schemas is a privilege allowing looking at structures within schemas.
NB! If you grant something to "public" role (an internal synonym for "all users"),  then every user has this grant.
*/
GRANT USAGE ON SCHEMA banking TO demorole_ro;   -- keeping things tight here
                                                -- now only demorole (owner) and demorole_ro have access

/*
Postgres has the feature of DEFAULT PRIVILEGES that can be used to easily maintain very granular privilege systems.
Here for example we declare that for all tables we create in our banking schema, system will automatically grant
read rights for the "demorole_ro" role.
*/
SET ROLE TO demorole;

ALTER DEFAULT PRIVILEGES
    FOR ROLE demorole
    IN SCHEMA banking
	GRANT SELECT ON TABLES TO demorole_ro;
ALTER DEFAULT PRIVILEGES
    IN SCHEMA public
	GRANT SELECT ON TABLES TO demorole_ro;
