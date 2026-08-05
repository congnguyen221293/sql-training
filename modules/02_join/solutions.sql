-- Module 2 - Dap an + giai thich. Chi mo sau khi da tu lam exercises.sql.
USE D365LearnSQL;
GO

-- Q1: INNER JOIN - chi lay Contact co Account khop dieu kien va co accountid ton tai.
SELECT c.fullname, c.emailaddress1, a.name AS account_name
FROM dbo.Contact c
INNER JOIN dbo.Account a ON a.accountid = c.parentcustomerid
WHERE a.country = N'Vietnam'
ORDER BY a.name;
GO

-- Q2: JOIN 3 bang lien tiep, moi JOIN co ON rieng.
SELECT TOP (10)
    o.name AS opportunity_name,
    a.name AS account_name,
    su.fullname AS owner_name,
    o.actualvalue
FROM dbo.Opportunity o
INNER JOIN dbo.Account a ON a.accountid = o.customerid
INNER JOIN dbo.SystemUser su ON su.systemuserid = o.ownerid
WHERE o.statecode = 1
ORDER BY o.actualvalue DESC;
GO

-- Q3: LEFT JOIN - giu tat ca Account ke ca khong co Incident nao (title se la NULL).
SELECT a.name AS account_name, i.title
FROM dbo.Account a
LEFT JOIN dbo.Incident i ON i.customerid = a.accountid
WHERE a.accountid BETWEEN 1 AND 10
ORDER BY a.accountid;
GO

-- Q4: Anti-join: LEFT JOIN roi loc ban ghi ben phai la NULL = "khong co dong nao khop".
SELECT su.fullname, su.title
FROM dbo.SystemUser su
LEFT JOIN dbo.Account a ON a.ownerid = su.systemuserid
WHERE a.accountid IS NULL;
GO

-- Q5: Dieu kien loc ben phai PHAI nam trong ON, khong phai WHERE - neu de trong WHERE se
-- vo tinh loai mat cac Account chua co Incident nao (LEFT JOIN bien thanh INNER JOIN).
SELECT a.name AS account_name, i.title
FROM dbo.Account a
LEFT JOIN dbo.Incident i ON i.customerid = a.accountid AND i.statuscode = N'Resolved'
WHERE a.accountid BETWEEN 1 AND 10
ORDER BY a.accountid;
GO

-- Q6: JOIN 3 bang, loc theo opportunityid cu the.
SELECT o.name AS opportunity_name, p.name AS product_name, op.quantity, op.extendedamount
FROM dbo.Opportunity o
INNER JOIN dbo.OpportunityProduct op ON op.opportunityid = o.opportunityid
INNER JOIN dbo.Product p ON p.productid = op.productid
WHERE o.opportunityid = 1;
GO

-- Q7: Self join - alias a1/a2 khac nhau, dung < (khong phai <>) de tranh dao cap va tu ghep.
SELECT TOP (10) a1.name AS account_1, a2.name AS account_2, a1.city
FROM dbo.Account a1
JOIN dbo.Account a2 ON a1.city = a2.city AND a1.accountid < a2.accountid
ORDER BY a1.city;
GO

-- Q8: FULL OUTER JOIN. Trong tap du lieu nay khong co Team nao "mo coi" (moi Team deu co
-- businessunitid hop le nho FK), nen ket qua giong het LEFT JOIN - nhung neu co du lieu ben
-- phai khong khop thi FULL OUTER JOIN moi giu duoc, LEFT JOIN se lam mat no.
SELECT bu.name AS business_unit, t.name AS team_name
FROM dbo.BusinessUnit bu
FULL OUTER JOIN dbo.Team t ON t.businessunitid = bu.businessunitid
ORDER BY bu.name;
GO

-- Q9
SELECT o.opportunityid, op.productid, op.quantity
FROM dbo.Opportunity o
LEFT JOIN dbo.OpportunityProduct op ON op.opportunityid = o.opportunityid
WHERE o.opportunityid = 5;
GO

-- Q10: regarding_accountid co the NULL (Activity co the gan voi Opportunity thay vi Account)
-- nen phai LEFT JOIN; con ownerid luon co gia tri nen INNER JOIN binh thuong la du.
SELECT TOP (10)
    act.subject,
    a.name AS account_name,
    su.fullname AS owner_name
FROM dbo.Activity act
LEFT JOIN dbo.Account a ON a.accountid = act.regarding_accountid
INNER JOIN dbo.SystemUser su ON su.systemuserid = act.ownerid
WHERE act.statuscode = N'Open';
GO
