/*
Special subtype of custom types are ENUMs. Concept is the same as in other programming languages, enabling to assing a nice label
to some internally stored code value, helping with clarity and also performance for bigger data amounts.
*/

CREATE TYPE processing_state AS ENUM ('WAITING', 'IN_PROCESSING', 'FAILED', 'FINISHED');

CREATE TABLE event_queue (
    created_on timestamptz not null,
    object_id int not null,
    status processing_state
);

INSERT INTO event_queue
  SELECT now(), 1, 'WAITING';
SELECT * FROM event_queue;
