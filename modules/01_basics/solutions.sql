-- Module 1 - Dap an + giai thich. Chi mo sau khi da tu lam exercises.sql.
USE D365LearnSQL;
GO

-- Q1
SELECT name, industrycode, revenue
FROM dbo.Account;
GO

-- Q2: AS de dat alias hien thi. Alias co khoang trang phai bo trong [] hoac "" (T-SQL dung []).
SELECT name AS [Ten cong ty], revenue AS [Doanh thu]
FROM dbo.Account;
GO

-- Q3
SELECT name, revenue
FROM dbo.Account
WHERE revenue > 10000000;
GO

-- Q4
SELECT name, country, revenue
FROM dbo.Account
WHERE country = N'Vietnam' AND revenue > 5000000;
GO

-- Q5: IN gon hon viet nhieu OR (country = 'x' OR country = 'y' OR ...)
SELECT name, country
FROM dbo.Account
WHERE country IN (N'Vietnam', N'Singapore', N'Japan');
GO

-- Q6: BETWEEN bao gom ca 2 dau (100 va 300 deu duoc lay)
SELECT name, numberofemployees
FROM dbo.Account
WHERE numberofemployees BETWEEN 100 AND 300;
GO

-- Q7: % dai dien cho "0 hoac nhieu ky tu bat ky" phia sau
SELECT name
FROM dbo.Account
WHERE name LIKE N'Contoso%';
GO

-- Q8: Phai dung IS NULL, khong duoc dung "= NULL" (se khong tra ve dong nao)
SELECT name, actualvalue
FROM dbo.Opportunity
WHERE actualvalue IS NULL;
GO

-- Q9
SELECT name, actualvalue
FROM dbo.Opportunity
WHERE actualvalue IS NOT NULL;
GO

-- Q10: DISTINCT loai bo cac dong trung lap sau khi da chon cot
SELECT DISTINCT country
FROM dbo.Account;
GO

-- Q11: TOP luon di kem ORDER BY de dam bao "cao nhat" co y nghia (khong co ORDER BY,
-- SQL Server khong dam bao thu tu tra ve)
SELECT TOP (10) name, revenue
FROM dbo.Account
ORDER BY revenue DESC;
GO

-- Q12: ORDER BY nhieu cot - uu tien cot dau, cot sau chi dung khi cot truoc bang nhau
SELECT firstname, lastname, jobtitle
FROM dbo.Contact
WHERE jobtitle IN (N'CEO', N'CFO')
ORDER BY lastname ASC, firstname ASC;
GO

-- Q13: Alias cho bieu thuc tinh toan/noi chuoi. Nho dung TOP + khong co ORDER BY o day chi
-- de minh hoa - trong thuc te nen luon ORDER BY khi dung TOP.
SELECT TOP (5) firstname + N' ' + lastname AS display_name
FROM dbo.Contact;
GO

-- Q14: Ket hop AND voi <>  (khac). Co the dung != tuong duong <> trong T-SQL.
SELECT fullname, companyname, estimatedvalue, statuscode
FROM dbo.Lead
WHERE estimatedvalue > 50000 AND statuscode <> N'Disqualified';
GO

-- Q15: CASE WHEN danh gia tuan tu tu tren xuong, dung dieu kien nao khop truoc thi dung ket qua do.
SELECT
    name,
    numberofemployees,
    CASE
        WHEN numberofemployees < 50 THEN N'Small'
        WHEN numberofemployees <= 200 THEN N'Medium'
        ELSE N'Large'
    END AS size_segment
FROM dbo.Account;
GO
