/*
Row Level Security (RLS) is quite a new feature (9.5+) and allows having tables where it is guaranteed that all unprivileged users 
will see only rows that they're allowed to see based on some filter condition. Needs enabling per table.
*/

CREATE TABLE public.virtual_private_table (
	username text NOT NULL DEFAULT current_user,
	data text not null
);

CREATE POLICY username_policy ON virtual_private_table
FOR ALL
TO PUBLIC
USING (username = current_user);
-- DROP POLICY username_policy ON virtual_private_table ;

ALTER TABLE virtual_private_table ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE virtual_private_table DISABLE ROW LEVEL SECURITY;
