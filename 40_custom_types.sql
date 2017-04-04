CREATE TYPE person_type AS (
	name text,
	age int
);

-- custom types are mostly used in conjunction with arrays to add make things more performant in comparision to traditional 1-N relations
CREATE TABLE t_event (
	id serial primary key,
	event_date date not null,
	participants person_type[]
);

INSERT INTO t_event(event_date, participants)
	VALUES (current_date, array[ROW('bob', 34)]::person_type[]);

-- usage from SQL is a bit clumsy
-- mainly meant to be used from PL/PgSQL or with framworks like https://github.com/zalando-incubator/java-sproc-wrapper
SELECT (unnest(participants)).name FROM t_event;
