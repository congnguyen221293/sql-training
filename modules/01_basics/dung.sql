-- Q1
select name, industrycode, revenue
from account
-- Q2
select name as 'ten cong ty', revenue as 'doanh thu'
from account
-- Q3
select *
from account
where revenue > 10000000
-- Q4
select *
from account
where country = 'Vietnam' and revenue > 5000000
-- Q5
select *
from account
where country in ('Vietnam', 'Singapore', 'Japan')
-- Q6
select *
from account
where numberofemployees between 100 and 300
-- Q7
select *
from account
where name like 'contoso%'
-- Q8
select *
from Opportunity
where actualvalue is null
-- Q9
SELECT name, actualvalue
from opportunity
where actualvalue is not null
-- Q10
select distinct country
from account
-- Q11
select top 10
    name, revenue
from account
order by revenue desc
-- Q12
select *
from contact
where jobtitle in ('ceo', 'cfo')
order by lastname asc, firstname asc
-- Q13
select top 5
firstname + ' ' + lastname as 'display_name' from contact
-- Q14
select * from lead where estimatedvalue > 50000 and statuscode <> 'Disqualified'
-- Q15
select name, numberofemployees, case when numberofemplouyees < 50 then "small" when numberofemployees between 50 and 200 then 'medium' else 'large' as 'size_segment' from account