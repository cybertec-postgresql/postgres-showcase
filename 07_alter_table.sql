/*
Another significant performance tweaking option for tables is the FILLFACTOR parameter.
It tells Postgres to fill up tables only to specified percentage, so that future row updates would
have a chance to be performed "in line". Some "terms and conditions" apply but for certain usecases huge boosts are possible.
*/
ALTER TABLE 