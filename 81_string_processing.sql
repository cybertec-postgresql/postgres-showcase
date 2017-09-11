\c pg_features_demo
SET ROLE TO demorole;

/*
Postgres has excellent text/string processing capabilities, including support for regular expressions.
Below some of the most useful functions and text handling techniques.

Things to note:
    * As quotes can be used single quotes or dollar-dollar delimited freelu chosen labels (e.g. $SQL$ or just $$)
    * Postgres string can be given in normal and "escape string" syntax, the latter is prefixed with "E" and requires
      that all literally displayed backslashes will be doubled.

Full documentation - https://www.postgresql.org/docs/current/static/functions-string.html
*/

-- string concatenation. when input might contain NULLs then format/concat are preffered
SELECT 'a'||'b'||'c';
SELECT format('%s%s%s', 'a', 'b', null);
SELECT concat('a', 'b', 'c');

-- casing
SELECT lower('ABC') = 'abc';
SELECT upper('abc') = 'ABC';

-- length / trim
SELECT length(trim(' abc ')) = 3;


-- selecting first letters from a string
SELECT substring('abc', 1, 1);
SELECT 'abc'::varchar(1);
SELECT left('abc', 1);

-- finding/replacing substrings
SELECT strpos('abc', 'bc');
SELECT regexp_split_to_table('hello world', E'\\s+');

-- encodings, quotings
SELECT current_setting('client_encoding') AS client_encoding, current_setting('server_encoding') AS server_encoding;
SELECT convert_from('text_in_utf8', 'UTF8');
SELECT convert_to('some text', 'UTF8');
SELECT quote_ident('Foo bar'); -- add quotes to correctly handle column/table names if necessary
SELECT quote_literal(E'O\'Reilly'); -- properly quote single quotes and backslashes

-- regular expressions
SELECT regexp_matches('foobarbequebaz', '(bar)(beque)');    -- check for matches. returns all captured substrings for additional processing if needed
SELECT regexp_replace('abcdef', '^.b.', 'xyz');
SELECT regexp_split_to_table('hello world', E'\\s+');    -- separate to words
