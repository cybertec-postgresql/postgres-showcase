#!/bin/sh

# Will create a new database "pg_features_demo". NB! Superuser rights are assumed.
#
# If not running a local Postgres server use libpq standard environment variables to specify connection string - e.g.:
# export PGHOST=some.ip.com
# export PGPORT=5433
# export PGUSER=myuser
# export PGDATABASE=postgres
ls *.sql | sort -n | xargs -n 1 psql -f
