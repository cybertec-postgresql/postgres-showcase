CREATE TYPE processing_state AS ENUM ('WAITING', 'IN_PROCESSING', 'FAILED', 'FINISHED');

CREATE TABLE event_queue (
    created_on timestamptz not null,
    object_id int not null,
    status processing_state
);

INSERT INTO event_queue
SELECT now(), 1, 'WAITING';
