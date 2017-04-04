CREATE VIEW v_simple AS
SELECT * FROM t_demo;

-- NB! simple views (selecting from one table basically) allow also inserting so "check option" might make sense,
-- it avoids inserting data that a user would not be able to see due to WHERE condition
CREATE VIEW v_data_for_sales_dept AS
SELECT * FROM t_demo
WHERE department = 'sales'
WITH CHECK OPTION;
