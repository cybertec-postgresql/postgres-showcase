## psql

*psql* is the default client CLI (comes with server installation) for executing queries on Postgres servers. It's very
light weight and as fast as it get, with pretty good auto-completion support for most common features (SQL syntax,
table/column names) and dozens of configuration options. Below an overview of the most useful usage scenarios and
configuration settings.

NB! When connecting to Postgres one always needs to specify a database name (contrary to MySQL for example). On most
servers there exists a "postgres" database which is created automatically on instance initialization, but which can also
freely be dopped if it's not used as it has no special importance to the system.

##### Connecting to a specified DB and entering the client

```psql --host localhost --port 5432 -U user1 -d db1```

##### Connecting to a specified DB with a JDBC-style connect string

```psql "postgresql://user1@localhost:5432/db1```

##### Command line usage to execute only a single query 

```psql -c "select 1""```

##### Command line usage to execute a single query, returning only the data. Good for scripting usage

```VALUE=$(psql -qXAtc "select 1")```

##### Executing contents of a file from command line  

```psql -f file.sql```

##### Executing input from a pipe (same result as with above command)  

```cat file.sql | psql```

##### Executing contents of a file from command line, wrapping them into a transaction  

```psql -1 -f file.sql```

##### Executing contents of a file, stopping on first error  

```psql -f file.sql --set ON_ERROR_STOP=1```

##### Executing a query and displaying the results without a pager (so that output persists on the console)   

```psql -c "select generate_series(1,10)" --pset pager```

##### Setting default connection parameters

Adding these lines to .bashrc can make life a lot easier if one needs to connect to a certain DB often 

```
export PGHOST=myserver
export PGPORT=5432
export PGDATABASE=myapp
export PGUSER=user1
export PGPASSWORD=secret
```

NB! Not to type in passwords every time when connecting a ".pgpass" file in the user's home directory can be used. This
should be done in a safe environment only though. More [here](https://www.postgresql.org/docs/current/libpq-pgpass.html)