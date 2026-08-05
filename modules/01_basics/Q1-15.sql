
-- Q1
select name, industrycode, revenue
from Account
-- Q2
select name as [Ten Cong ty], industrycode as [Ma nganh], revenue as [Doanh thu]
from Account
-- Q3: Lay cac Account co revenue lon hon 10,000,000.
select *
from account
where revenue > 10000000
--Q4: Lay cac Account o     VA co revenue lon hon 5,000,000.
select *
from account
where country = 'Vietnam' and revenue > 5000000

--Q5: Lay cac Account o mot trong 3 quoc gia: Vietnam, Singapore, Japan.
select *
from account
where country in ('Vietnam', 'Singapore', 'Japan')

--Q6: Lay cac Account co so nhan vien (numberofemployees) trong khoang tu 100 den 300 (bao gom 2 dau).
select *
from account
where numberofemployees between 100 and 300

--Q7: Lay cac Account co ten bat dau bang chu "Contoso".
select *
from account
where name like 'Contoso%'

--Q8: Lay cac Opportunity chua dong (actualvalue con NULL).
select *
from Opportunity
where actualvalue is null

--Q9: Lay cac Opportunity DA dong (actualvalue khac NULL), hien thi name va actualvalue.
select name, actualvalue
from Opportunity
where actualvalue is not null

-- Q10: Liet ke danh sach quoc gia (country) khong trung lap dang co Account.
select distinct country
from Account

-- Q11: Lay 10 Account co doanh thu (revenue) cao nhat, sap xep giam dan theo revenue.
select top 10
    *
from Account
order by revenue desc

--Q12: Lay danh sach Contact co jobtitle la 'CEO' hoac 'CFO', sap xep theo lastname tang dan,
--      neu trung lastname thi sap xep tiep theo firstname tang dan.
select *
from contact
where jobtitle in ('CEO', 'CFO')
order by lastname asc, firstname asc

--Q13: Voi bang Contact, tao 1 cot moi ten "display_name" ghep firstname + " " + lastname
--      (khong dung cot fullname co san), chi lay 5 dong dau.
select top 5
    firstname + ' ' + lastname as display_name
from contact

-- Q14: Lay cac Lead co estimatedvalue > 50000 VA statuscode khac 'Disqualified'.
select *
from lead
where estimatedvalue > 50000 and statuscode <> 'Disqualified'

-- Q15: Dung CASE WHEN de phan loai Account thanh nhom quy mo theo numberofemployees:
--      < 50 -> 'Small', 50-200 -> 'Medium', >
select name, numberofemployees,
    case
    when numberofemployees < 50 then 'Small'
    when numberofemployees between 50 and 200 then 'Medium'
    else 'Large'
end as size_segment
from account