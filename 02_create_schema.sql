/*
Schemas in Postgres are basically "namespaces", allowing tables with same names within one DB, if schema names differ.
By default there is always one "public" schema pre-created with every database, but for bigger applications it is usually 
preferable to create more schemas to logically group business functionality: e.g. customer_data, product_data.
 
Hierarchy of objects is thus such:   Cluster -> Database -> Schema -> Table
*/
CREATE SCHEMA IF NOT EXISTS banking_demo AUTHORIZATION demorole;

/*
When creating schemas, one also usually should define according access privileges.
"USAGE" privilege for schemas is a privilege allowing looking at structures within schemas.
Here we also introduce the "public" role, meaning an internal synonym for "all users" - this if you grant some rights to 
"public", every user has it.
*/
GRANT USAGE ON SCHEMA banking_demo TO public;


/*
Postgres has the feature of DEFAULT PRIVILEGES that can be used to easily maintain very granular privilege systems.
Here for example we declare that for all tables we create in our banking_demo schema, system will automatically grant 
read rights for the "demorole_ro" role.
*/
ALTER DEFAULT PRIVILEGES IN SCHEMA banking_demo
	GRANT SELECT ON TABLES TO demorole_ro;
