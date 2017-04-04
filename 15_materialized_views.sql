-- NB! simple views (selecting from one table basically) allow also inserting so "check option" might make sense,
-- it avoids inserting data that a user would not be able to see due to WHERE condition
create materialized view mv_last_month_data as
select * from t_demo
where created_on > current_date - '1month'::interval;

-- refresh concurrently needs at least one unique index to "merge" changes effectively
create unique index on mv_last_month_data (id);
refresh materialized view concurrently mv_last_month_data;
