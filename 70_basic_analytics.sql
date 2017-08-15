/*
Postgres has rich analytics support. Analytics can mean a lot of things but here it means there are functions that in addition to
normal aggregates (AVG, SUM, etc) can also compare individual rows! Thus enabling answering questions like - give me the top 1% percent
of salary earners for a company.
*/

CREATE TABLE salary(
    employee_id     int NOT NULL,
    department      text NOT NULL,
    salary          int NOT NULL
);

-- let's insert 100 employees from 5 departments, with salaries randomly ranging from 40k-120k
INSERT INTO salary(employee_id, department, salary)
  SELECT generate_series(1, 100), 'dep'|| (1 + floor(random()*5))::text, greatest(120000*random(), 40000);

-- avg. salary for all departments. here we don't need analytical functions
SELECT department, AVG(salary)::int FROM salary GROUP BY department ORDER BY 1;

-- for showing the difference to the nearest department in terms of avg salary we already need analytics
SELECT
  department,
  avg_salary,
  ((lag(avg_salary) OVER (ORDER BY avg_salary DESC) - avg_salary) / avg_salary::numeric)*100 AS pct_difference_to_prev
FROM (
    SELECT department, AVG(salary)::int AS avg_salary FROM salary GROUP BY department ORDER BY 1
) a;
