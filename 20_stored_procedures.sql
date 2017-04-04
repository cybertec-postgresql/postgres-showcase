CREATE OR REPLACE FUNCTION f1_returns_text() RETURNS text as
$SQL$
BEGIN
	RETURN 'demo';
END;
$SQL$
LANGUAGE plpgsql;
