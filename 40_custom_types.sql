\c pg_features_demo
SET ROLE TO demorole;

/*
Postgres is a the most extensible general purpose RDBMS out there and one of the most used extensibility feature is creating custom 
types that can be thought of as "classes" in the object-oriented programming world. Created types can then be used as built-in 
datatypes.
*/

CREATE TYPE person_type AS (
	name text,
	age int
);

-- custom types are mostly used in conjunction with arrays to add make things more performant in comparision to traditional 1-N relations
CREATE TABLE event (
	id serial primary key,
	event_date date not null,
	participants person_type[]
);

INSERT INTO event(event_date, participants)
	VALUES (current_date, array[ROW('bob', 34), ROW('alice', 29)]::person_type[]);

-- usage from SQL is a bit clumsy though
-- mainly meant to be used from PL/PgSQL or with frameworks like https://github.com/zalando-incubator/java-sproc-wrapper
SELECT (unnest(participants)).name FROM event;
