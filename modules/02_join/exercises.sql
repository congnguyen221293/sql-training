-- Module 2 - JOIN
-- Tu viet SQL cho tung cau ben duoi phan comment, roi doi chieu voi solutions.sql
USE D365LearnSQL;
GO

-- Q1: INNER JOIN Contact voi Account. Hien thi fullname (cua Contact), emailaddress1, va ten
--     Account (a.name). Chi lay Contact thuoc Account co country = 'Vietnam'. Sap xep theo ten Account.


-- Q2: INNER JOIN 3 bang Opportunity - Account - SystemUser. Hien thi ten Opportunity, ten Account,
--     fullname cua nguoi so huu (owner). Chi lay Opportunity co statecode = 1 (Won).
--     Sap xep actualvalue giam dan, lay 10 dong dau.


-- Q3: LEFT JOIN Account voi Incident. Hien thi ten Account va title cua Incident (NULL neu chua
--     co case nao). Chi lay Account co accountid tu 1 den 10. Sap xep theo accountid.


-- Q4: Tim SystemUser CHUA so huu Account nao (dung LEFT JOIN + WHERE ... IS NULL).
--     Hien thi fullname va title.


-- Q5: LEFT JOIN Account voi Incident, NHUNG chi ghep voi Incident co statuscode = 'Resolved'
--     (dieu kien nay phai nam trong ON, khong phai WHERE, de khong mat Account chua co Incident).
--     Hien thi ten Account va title Incident. Chi lay Account co accountid tu 1 den 10.


-- Q6: JOIN 3 bang Opportunity - OpportunityProduct - Product. Hien thi ten Opportunity, ten
--     Product, quantity, extendedamount. Chi lay opportunityid = 1.


-- Q7: Self JOIN Account voi chinh no de tim cac CAP Account cung thanh pho (city), khac
--     accountid, khong bi trung cap / dao nguoc. Hien thi ten 2 Account va thanh pho.
--     Chi lay 10 dong dau.


-- Q8: FULL OUTER JOIN BusinessUnit voi Team. Hien thi ten BusinessUnit va ten Team (NULL neu
--     BusinessUnit chua co Team nao). Sap xep theo ten BusinessUnit.


-- Q9: LEFT JOIN Opportunity voi OpportunityProduct. Hien thi opportunityid, productid, quantity
--     cho opportunityid = 5 (chi de xem opportunity nay co nhung dong san pham nao).


-- Q10: JOIN Activity voi Account (qua regarding_accountid) VA JOIN rieng voi SystemUser (owner).
--      Hien thi subject, ten Account (NULL neu Activity khong gan voi Account nao), fullname owner.
--      Chi lay statuscode = 'Open', 10 dong dau.
