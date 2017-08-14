# Using python and psycopg2 driver ('sudo apt install python-psycopg2' or 'sudo pip install psycopg2') to work with Postgres databases

import psycopg2
import psycopg2.extras

conn = psycopg2.connect(host='localhost', dbname='pg_features_demo')
conn.autocommit = True
cur = conn.cursor(psycopg2.extras.RealDictCursor)
cur.execute('select current_date as today')
print cur.fetchone()['today']
