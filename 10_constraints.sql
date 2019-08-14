\c pg_features_demo
SET ROLE TO demorole;

/*

Constraints, guarding certain values / conditions, can be set on single column values and between tables.
Following constraint types are available:

 - PRIMARY KEY constraint. The column must be unique for each row
 - UNIQUE constraint. All column (or multicolumn) values must be unique, functionally the same as PRIMARY KEY
 - NOT NULL constraint. Column value must always be specified
 - simple column or multi-column boolean checks
 - simple column or multi-column function call check
 - FOREIGN KEY constraint between 2 tables, requiring the same value to exists in a "parent" table
 - Deferrable FOREIGN KEY-s to deal with "chicken - egg" type of problems
 - Exclusion constraints. The rarest of the bunch, they're used mostly to avoid overlapping date/time or numeric ranges

NB! Technically triggers can also serve as constraints, but there's a separate chapter on them.

*/

CREATE TABLE public.constraints (
    id          bigserial PRIMARY KEY, -- PRIMARY KEY implicitly includes NOT NULL, the most basic constraint
    name        text NOT NULL CHECK (name=upper(name)), -- allow only upper case names
    age         smallint CHECK (age BETWEEN 0 and 150),
    event_date  daterange

);

-- Constraints can also be added later separately. This allows more better naming
ALTER TABLE public.constraints ADD CONSTRAINT age_check CHECK (age BETWEEN 0 and 150);


-- Define a FK, e.g. for every inserted "constraints_id" value there must be a matching "id" value in "constraints"
-- NB! NULL values are still OK if the FK column is "nullable".
CREATE TABLE public.constraints_fk (
    id          bigserial PRIMARY KEY,
    constraints_id bigint REFERENCES public.constraints (id)
);

CREATE INDEX ON public.constraints_fk (constraints_id); -- it's a "best practice" to index all FK-s, especially
                                                        -- if some "cascading" is used

-- the same FK as a separate command and with extra options
ALTER TABLE public.constraints_fk
    ADD constraints_id2 bigint,
    ADD CONSTRAINT fk_constraints_id FOREIGN KEY (constraints_id2) REFERENCES  public.constraints (id)
        ON DELETE CASCADE   -- if some "constraints" entry is deleted, delete also referencing "constraints_fk" rows
        DEFERRABLE INITIALLY DEFERRED;  -- check references only at "COMMIT time"


-- Exclusion constraints

ALTER TABLE public.constraints ADD CONSTRAINT no_overlappings EXCLUDE USING gist (event_date WITH &&);
