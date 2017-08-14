/*
"USAGE" for schemas allows looking at structures within schemas.
Thus for sensitive environments it is recommended to avoid creating object in the "public" schema (namespace) or to 
revoke "public" (all users) access like below.
*/
REVOKE USAGE ON SCHEMA public FROM public;

-- Whitelist needed users later
GRANT USAGE ON SCHEMA public TO demorole;
