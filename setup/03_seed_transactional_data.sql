-- Sinh dữ liệu giao dịch với khối lượng đủ lớn để luyện JOIN/GROUP BY/window functions.
-- Dùng công thức (không phải NEWID/RAND) để dữ liệu giống hệt nhau mỗi lần chạy lại setup,
-- nhờ vậy đáp án của các bài exercise luôn ổn định.
USE D365LearnSQL;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- ================= ACCOUNT (200 rows) =================
;WITH Base AS (
    SELECT * FROM (VALUES
        (1,N'Northwind'),(2,N'Contoso'),(3,N'Fabrikam'),(4,N'Adventure'),(5,N'Blue Yonder'),
        (6,N'Trey Research'),(7,N'Wingtip'),(8,N'Tailspin'),(9,N'Proseware'),(10,N'Lucerne'),
        (11,N'Litware'),(12,N'Coho'),(13,N'Alpine'),(14,N'Woodgrove'),(15,N'Nod'),
        (16,N'Graphic Design'),(17,N'Humongous'),(18,N'City Power'),(19,N'Fourth Coffee'),(20,N'Consolidated')
    ) AS t(id,name)
),
Suffix AS (
    SELECT * FROM (VALUES
        (1,N'Industries'),(2,N'Solutions'),(3,N'Group'),(4,N'Holdings'),(5,N'Corp'),
        (6,N'Partners'),(7,N'Technologies'),(8,N'Logistics'),(9,N'Enterprises'),(10,N'Systems')
    ) AS t(id,name)
),
Industry AS (
    SELECT * FROM (VALUES
        (1,N'Manufacturing'),(2,N'Retail'),(3,N'Financial Services'),(4,N'Healthcare'),
        (5,N'Technology'),(6,N'Education'),(7,N'Government'),(8,N'Transportation'),
        (9,N'Energy'),(10,N'Hospitality'),(11,N'Construction'),(12,N'Agriculture')
    ) AS t(id,name)
),
Geo AS (
    SELECT * FROM (VALUES
        (1,N'Ho Chi Minh City',N'Vietnam'),(2,N'Hanoi',N'Vietnam'),(3,N'Da Nang',N'Vietnam'),
        (4,N'Singapore',N'Singapore'),(5,N'Bangkok',N'Thailand'),(6,N'Kuala Lumpur',N'Malaysia'),
        (7,N'Jakarta',N'Indonesia'),(8,N'Manila',N'Philippines'),(9,N'Tokyo',N'Japan'),
        (10,N'Seoul',N'South Korea'),(11,N'Sydney',N'Australia'),(12,N'London',N'United Kingdom'),
        (13,N'New York',N'United States'),(14,N'San Francisco',N'United States'),(15,N'Toronto',N'Canada')
    ) AS t(id,city,country)
),
Combo AS (
    SELECT ROW_NUMBER() OVER (ORDER BY b.id, s.id) AS n, b.name AS base, s.name AS suffix
    FROM Base b CROSS JOIN Suffix s
)
INSERT INTO dbo.Account (name, industrycode, revenue, numberofemployees, city, country, ownerid, statecode, createdon, modifiedon)
SELECT
    c.base + N' ' + c.suffix,
    i.name,
    CAST(500000 + ((c.n * 37) % 80) * 250000 AS MONEY),
    10 + ((c.n * 13) % 50) * 20,
    g.city, g.country,
    1 + ((c.n * 7) % 19),
    CASE WHEN c.n % 23 = 0 THEN 1 ELSE 0 END,
    d.createdon,
    d.createdon
FROM Combo c
CROSS APPLY (SELECT name FROM Industry WHERE id = 1 + ((c.n * 5) % 12)) i
CROSS APPLY (SELECT city, country FROM Geo WHERE id = 1 + ((c.n * 3) % 15)) g
CROSS APPLY (SELECT DATEADD(DAY, -((c.n * 11) % 900), CAST(SYSDATETIME() AS DATE)) AS createdon) d;
GO

-- ================= CONTACT (500 rows) =================
;WITH Tally AS (
    SELECT TOP (500) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
FirstNames AS (
    SELECT * FROM (VALUES
        (1,N'James'),(2,N'Mary'),(3,N'Robert'),(4,N'Linda'),(5,N'Michael'),(6,N'Patricia'),
        (7,N'David'),(8,N'Jennifer'),(9,N'Minh'),(10,N'Lan'),(11,N'Duc'),(12,N'Huong'),
        (13,N'Carlos'),(14,N'Maria'),(15,N'Wei'),(16,N'Fang'),(17,N'Hiroshi'),(18,N'Yuki'),
        (19,N'Somchai'),(20,N'Anong'),(21,N'Andrew'),(22,N'Sarah'),(23,N'Thomas'),(24,N'Karen'),(25,N'Kevin')
    ) AS t(id,name)
),
LastNames AS (
    SELECT * FROM (VALUES
        (1,N'Smith'),(2,N'Johnson'),(3,N'Williams'),(4,N'Brown'),(5,N'Nguyen'),(6,N'Tran'),
        (7,N'Le'),(8,N'Pham'),(9,N'Garcia'),(10,N'Martinez'),(11,N'Kim'),(12,N'Park'),
        (13,N'Tanaka'),(14,N'Suzuki'),(15,N'Wong'),(16,N'Chen'),(17,N'Anderson'),(18,N'Taylor'),
        (19,N'Thomas'),(20,N'Moore'),(21,N'Jackson'),(22,N'White'),(23,N'Harris'),(24,N'Clark'),(25,N'Lewis')
    ) AS t(id,name)
),
JobTitles AS (
    SELECT * FROM (VALUES
        (1,N'CEO'),(2,N'CFO'),(3,N'COO'),(4,N'IT Director'),(5,N'Procurement Manager'),
        (6,N'Operations Manager'),(7,N'Finance Manager'),(8,N'HR Manager'),
        (9,N'Marketing Director'),(10,N'Sales Director')
    ) AS t(id,name)
)
INSERT INTO dbo.Contact (firstname, lastname, emailaddress1, jobtitle, parentcustomerid, ownerid, statecode, createdon)
SELECT
    f.name, l.name,
    LOWER(f.name) + N'.' + LOWER(l.name) + CAST(t.n AS NVARCHAR(10)) + N'@example.com',
    j.name,
    1 + ((t.n - 1) % 200),
    1 + ((t.n * 9) % 19),
    CASE WHEN t.n % 31 = 0 THEN 1 ELSE 0 END,
    DATEADD(DAY, -((t.n * 7) % 850), CAST(SYSDATETIME() AS DATE))
FROM Tally t
CROSS APPLY (SELECT name FROM FirstNames WHERE id = 1 + ((t.n * 3) % 25)) f
CROSS APPLY (SELECT name FROM LastNames WHERE id = 1 + ((t.n * 11) % 25)) l
CROSS APPLY (SELECT name FROM JobTitles WHERE id = 1 + ((t.n * 5) % 10)) j;
GO

-- ================= LEAD (300 rows) =================
;WITH Tally AS (
    SELECT TOP (300) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
FirstNames AS (
    SELECT * FROM (VALUES
        (1,N'Alan'),(2,N'Nancy'),(3,N'Peter'),(4,N'Susan'),(5,N'Brian'),(6,N'Linh'),
        (7,N'Tuan'),(8,N'Mai'),(9,N'Diego'),(10,N'Elena'),(11,N'Ravi'),(12,N'Anita'),
        (13,N'Erik'),(14,N'Ingrid'),(15,N'Chris'),(16,N'Julia'),(17,N'Marco'),(18,N'Sofia'),
        (19,N'Ken'),(20,N'Aiko')
    ) AS t(id,name)
),
LastNames AS (
    SELECT * FROM (VALUES
        (1,N'Baker'),(2,N'Foster'),(3,N'Hoang'),(4,N'Vu'),(5,N'Dang'),(6,N'Bui'),
        (7,N'Rossi'),(8,N'Silva'),(9,N'Kumar'),(10,N'Singh'),(11,N'Nilsson'),(12,N'Olsen'),
        (13,N'Fischer'),(14,N'Weber'),(15,N'Watanabe'),(16,N'Sato'),(17,N'Costa'),(18,N'Ferreira'),
        (19,N'Reed'),(20,N'Cooper')
    ) AS t(id,name)
),
CompanyBase AS (
    SELECT * FROM (VALUES
        (1,N'Pinnacle'),(2,N'Vertex'),(3,N'Summit'),(4,N'Horizon'),(5,N'Catalyst'),
        (6,N'Meridian'),(7,N'Beacon'),(8,N'Anchor'),(9,N'Crestline'),(10,N'Silverline'),
        (11,N'Redwood'),(12,N'Ironclad'),(13,N'Skyline'),(14,N'Bluewave'),(15,N'Cornerstone')
    ) AS t(id,name)
),
CompanySuffix AS (
    SELECT * FROM (VALUES (1,N'Inc.'),(2,N'Ltd.'),(3,N'Co.'),(4,N'LLC'),(5,N'Group') ) AS t(id,name)
),
LeadSource AS (
    SELECT * FROM (VALUES (1,N'Web'),(2,N'Referral'),(3,N'Trade Show'),(4,N'Cold Call'),(5,N'Advertisement') ) AS t(id,name)
)
INSERT INTO dbo.Lead (fullname, companyname, emailaddress1, leadsourcecode, statuscode, estimatedvalue, ownerid, createdon, qualifiedon)
SELECT
    f.name + N' ' + l.name,
    cb.name + N' ' + cs.name,
    LOWER(f.name) + N'.' + LOWER(l.name) + CAST(t.n AS NVARCHAR(10)) + N'@lead-example.com',
    ls.name,
    CASE WHEN t.n % 5 = 0 THEN N'Disqualified'
         WHEN t.n % 3 = 0 THEN N'Qualified'
         ELSE N'Open' END,
    CAST(5000 + ((t.n * 41) % 60) * 1500 AS MONEY),
    1 + ((t.n * 5) % 6), -- SDRs (id 5,6) và AE cùng làm việc với lead: dùng dải nhỏ
    DATEADD(DAY, -((t.n * 13) % 600), CAST(SYSDATETIME() AS DATE)),
    CASE WHEN t.n % 3 = 0 THEN DATEADD(DAY, -((t.n * 13) % 600) + 5, CAST(SYSDATETIME() AS DATE)) ELSE NULL END
FROM Tally t
CROSS APPLY (SELECT name FROM FirstNames WHERE id = 1 + ((t.n * 3) % 20)) f
CROSS APPLY (SELECT name FROM LastNames WHERE id = 1 + ((t.n * 7) % 20)) l
CROSS APPLY (SELECT name FROM CompanyBase WHERE id = 1 + ((t.n * 9) % 15)) cb
CROSS APPLY (SELECT name FROM CompanySuffix WHERE id = 1 + ((t.n * 2) % 5)) cs
CROSS APPLY (SELECT name FROM LeadSource WHERE id = 1 + ((t.n * 4) % 5)) ls;
GO

-- ================= OPPORTUNITY (400 rows, 2 per Account) =================
;WITH Tally AS (
    SELECT TOP (400) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
Stage AS (
    -- statecode: 0 Open, 1 Won, 2 Lost - phân bố ~33% Open, 50% Won, 17% Lost
    SELECT * FROM (VALUES
        (1,0,N'In Progress'),(2,0,N'Identify'),(3,1,N'Won'),(4,1,N'Won'),(5,1,N'Won'),(6,2,N'Lost')
    ) AS t(id,statecode,statuscode)
),
Src AS (
    SELECT t.n,
           a.accountid, a.ownerid AS acct_owner,
           s.statecode, s.statuscode
    FROM Tally t
    JOIN dbo.Account a ON a.accountid = 1 + ((t.n - 1) % 200)
    CROSS APPLY (SELECT statecode, statuscode FROM Stage WHERE id = (t.n % 6) + 1) s
)
INSERT INTO dbo.Opportunity (name, customerid, estimatedvalue, actualvalue, estimatedclosedate, actualclosedate, statecode, statuscode, ownerid, createdon)
SELECT
    a.name + N' - Deal #' + CAST(s.n AS NVARCHAR(10)),
    s.accountid,
    CAST(8000 + ((s.n * 53) % 120) * 2500 AS MONEY) AS est_value,
    CASE WHEN s.statecode = 1 THEN CAST(8000 + ((s.n * 53) % 120) * 2500 AS MONEY) * (0.85 + ((s.n % 4) * 0.05))
         WHEN s.statecode = 2 THEN NULL
         ELSE NULL END,
    DATEADD(DAY, ((s.n * 17) % 400) - 180, CAST(SYSDATETIME() AS DATE)),
    CASE WHEN s.statecode IN (1,2) THEN DATEADD(DAY, ((s.n * 17) % 400) - 180 - ((s.n % 20)), CAST(SYSDATETIME() AS DATE)) ELSE NULL END,
    s.statecode,
    s.statuscode,
    s.acct_owner,
    DATEADD(DAY, -((s.n * 19) % 700), CAST(SYSDATETIME() AS DATE))
FROM Src s
JOIN dbo.Account a ON a.accountid = s.accountid;
GO

-- ================= OPPORTUNITY PRODUCT (~800 rows, 2 per Opportunity) =================
;WITH Lines AS (
    SELECT o.opportunityid, ln.slot
    FROM dbo.Opportunity o
    CROSS JOIN (VALUES (1),(2)) AS ln(slot)
)
INSERT INTO dbo.OpportunityProduct (opportunityid, productid, quantity, priceperunit)
SELECT
    l.opportunityid,
    p.productid,
    1 + ((l.opportunityid * l.slot * 3) % 8),
    p.price
FROM Lines l
CROSS APPLY (SELECT productid, price FROM dbo.Product WHERE productid = 1 + ((l.opportunityid * 7 + l.slot * 3) % 20)) p;
GO

-- ================= INCIDENT (250 rows) =================
;WITH Tally AS (
    SELECT TOP (250) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
IssueType AS (
    SELECT * FROM (VALUES
        (1,N'Login failure after latest update'),(2,N'Data sync delay with integration'),
        (3,N'Report export failing'),(4,N'Performance degradation on dashboard'),
        (5,N'Permission error accessing module'),(6,N'Unable to reconcile invoice totals'),
        (7,N'Mobile app crash on submit'),(8,N'Email notifications not sending'),
        (9,N'Duplicate records after import'),(10,N'License activation issue')
    ) AS t(id,name)
),
Support AS (
    SELECT * FROM (VALUES (1,11),(2,12),(3,13),(4,20)) AS t(id,systemuserid) -- support engineers
)
INSERT INTO dbo.Incident (title, customerid, ownerid, prioritycode, statuscode, createdon, resolvedon)
SELECT
    it.name,
    1 + ((t.n * 3) % 200),
    su.systemuserid,
    CASE WHEN t.n % 7 = 0 THEN N'High' WHEN t.n % 3 = 0 THEN N'Low' ELSE N'Normal' END,
    CASE WHEN t.n % 4 = 0 THEN N'Resolved'
         WHEN t.n % 11 = 0 THEN N'Cancelled'
         WHEN t.n % 5 = 0 THEN N'On Hold'
         ELSE N'In Progress' END,
    DATEADD(DAY, -((t.n * 9) % 400), CAST(SYSDATETIME() AS DATE)),
    CASE WHEN t.n % 4 = 0 THEN DATEADD(DAY, -((t.n * 9) % 400) + 1 + (t.n % 10), CAST(SYSDATETIME() AS DATE)) ELSE NULL END
FROM Tally t
CROSS APPLY (SELECT name FROM IssueType WHERE id = 1 + ((t.n * 7) % 10)) it
CROSS APPLY (SELECT systemuserid FROM Support WHERE id = 1 + (t.n % 4)) su;
GO

-- ================= ACTIVITY (1000 rows) =================
;WITH Tally AS (
    SELECT TOP (1000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
ActType AS (
    SELECT * FROM (VALUES (1,N'Email'),(2,N'Phone Call'),(3,N'Task'),(4,N'Appointment') ) AS t(id,name)
),
SubjectText AS (
    SELECT * FROM (VALUES
        (1,N'Follow up on proposal'),(2,N'Discuss renewal terms'),(3,N'Send updated quote'),
        (4,N'Product demo'),(5,N'Check in on satisfaction'),(6,N'Schedule kickoff call'),
        (7,N'Review contract terms'),(8,N'Confirm delivery timeline'),(9,N'Answer pricing question'),
        (10,N'Onboarding check-in')
    ) AS t(id,name)
)
INSERT INTO dbo.Activity (activitytypecode, subject, regarding_accountid, regarding_opportunityid, ownerid, scheduledstart, actualend, statuscode)
SELECT
    at.name,
    st.name,
    CASE WHEN t.n % 2 = 0 THEN 1 + ((t.n * 3) % 200) ELSE NULL END,
    CASE WHEN t.n % 2 = 1 THEN 1 + ((t.n * 5) % 400) ELSE NULL END,
    1 + ((t.n * 3) % 19),
    DATEADD(DAY, -((t.n * 5) % 400), CAST(SYSDATETIME() AS DATETIME2)),
    CASE WHEN t.n % 5 <> 0 THEN DATEADD(DAY, -((t.n * 5) % 400) , CAST(SYSDATETIME() AS DATETIME2)) ELSE NULL END,
    CASE WHEN t.n % 5 = 0 THEN N'Open' WHEN t.n % 13 = 0 THEN N'Canceled' ELSE N'Completed' END
FROM Tally t
CROSS APPLY (SELECT name FROM ActType WHERE id = 1 + ((t.n * 3) % 4)) at
CROSS APPLY (SELECT name FROM SubjectText WHERE id = 1 + ((t.n * 7) % 10)) st;
GO
