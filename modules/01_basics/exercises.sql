-- Module 1 - Nen tang: SELECT / WHERE / ORDER BY
-- Tu viet SQL cho tung cau ben duoi phan comment, roi doi chieu voi solutions.sql
USE D365LearnSQL;
GO

-- Q1: Lay ten (name), nganh (industrycode) va doanh thu (revenue) cua tat ca Account.


-- Q2: Nhu Q1 nhung doi ten cot hien thi: name -> "Ten cong ty", revenue -> "Doanh thu".


-- Q3: Lay cac Account co revenue lon hon 10,000,000.


-- Q4: Lay cac Account o Vietnam VA co revenue lon hon 5,000,000.


-- Q5: Lay cac Account o mot trong 3 quoc gia: Vietnam, Singapore, Japan.


-- Q6: Lay cac Account co so nhan vien (numberofemployees) trong khoang tu 100 den 300 (bao gom 2 dau).


-- Q7: Lay cac Account co ten bat dau bang chu "Contoso".


-- Q8: Lay cac Opportunity chua dong (actualvalue con NULL).


-- Q9: Lay cac Opportunity DA dong (actualvalue khac NULL), hien thi name va actualvalue.


-- Q10: Liet ke danh sach quoc gia (country) khong trung lap dang co Account.


-- Q11: Lay 10 Account co doanh thu (revenue) cao nhat, sap xep giam dan theo revenue.


-- Q12: Lay danh sach Contact co jobtitle la 'CEO' hoac 'CFO', sap xep theo lastname tang dan,
--      neu trung lastname thi sap xep tiep theo firstname tang dan.


-- Q13: Voi bang Contact, tao 1 cot moi ten "display_name" ghep firstname + " " + lastname
--      (khong dung cot fullname co san), chi lay 5 dong dau.


-- Q14: Lay cac Lead co estimatedvalue > 50000 VA statuscode khac 'Disqualified'.


-- Q15: Dung CASE WHEN de phan loai Account thanh nhom quy mo theo numberofemployees:
--      < 50 -> 'Small', 50-200 -> 'Medium', > 200 -> 'Large'.
--      Hien thi name, numberofemployees va cot nhom moi ten "size_segment".
