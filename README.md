# postgres-showcase

Sample object creation and query scripts to illustrate different Postgres object types and data quering possibilities.
Targeted for beginners.

### Rollout

For running all the scripts on a local Postgres DB (superuser assumed) use the provided rollout.sh script which consist of:

```
ls *.sql | sort -n | xargs -n 1 psql -f
```

All feedback welcome!
