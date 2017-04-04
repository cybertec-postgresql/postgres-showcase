-- "usage" for schemas allows looking at structures within schemas
-- avoid usage of "public" schema or better revoke "public" access for sensitive environments
REVOKE USAGE ON SCHEMA public FROM public;

-- whitelist needed users
GRANT USAGE ON SCHEMA public TO demorole;
