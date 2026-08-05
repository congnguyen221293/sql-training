-- Dữ liệu tham chiếu tĩnh: BusinessUnit, SystemUser, Team, Product.
USE D365LearnSQL;
GO

INSERT INTO dbo.BusinessUnit (name) VALUES
    (N'Sales'), (N'Marketing'), (N'Customer Service'), (N'IT'), (N'Finance');
GO

INSERT INTO dbo.SystemUser (fullname, title, businessunitid, isdisabled) VALUES
    (N'Alex Turner',      N'Sales Manager',           1, 0),
    (N'Priya Sharma',     N'Account Executive',       1, 0),
    (N'James Wilson',     N'Account Executive',       1, 0),
    (N'Nguyen Minh Anh',  N'Account Executive',       1, 0),
    (N'Laura Bennett',    N'Sales Development Rep',   1, 0),
    (N'Carlos Mendes',    N'Sales Development Rep',   1, 0),
    (N'Emma Rossi',       N'Marketing Manager',       2, 0),
    (N'Tran Thi Bich',    N'Marketing Specialist',    2, 0),
    (N'David Kim',        N'Marketing Specialist',    2, 0),
    (N'Sophie Laurent',   N'Customer Service Manager',3, 0),
    (N'Michael Chen',     N'Support Engineer',        3, 0),
    (N'Le Van Duc',       N'Support Engineer',        3, 0),
    (N'Hannah Schmidt',   N'Support Engineer',        3, 0),
    (N'Robert Johnson',   N'IT Administrator',        4, 0),
    (N'Pham Thu Ha',      N'IT Administrator',        4, 0),
    (N'Olivia Martin',    N'Finance Analyst',         5, 0),
    (N'Daniel Novak',     N'Finance Analyst',         5, 0),
    (N'Grace Anderson',   N'Sales Manager',           1, 0),
    (N'Hoang Van Nam',    N'Account Executive',       1, 0),
    (N'Isabella Garcia',  N'Support Engineer',        3, 1);  -- 1 user disabled: dùng để luyện lọc isdisabled
GO

INSERT INTO dbo.Team (name, businessunitid) VALUES
    (N'Enterprise Sales', 1),
    (N'SMB Sales', 1),
    (N'Marketing Campaigns', 2),
    (N'Tier 2 Support', 3),
    (N'Infrastructure', 4);
GO

INSERT INTO dbo.Product (name, category, price) VALUES
    (N'CRM Standard License',       N'Software License', 25.00),
    (N'CRM Enterprise License',     N'Software License', 65.00),
    (N'ERP Finance Module',         N'Software License', 90.00),
    (N'ERP Supply Chain Module',    N'Software License', 85.00),
    (N'Power BI Pro License',       N'Software License', 10.00),
    (N'Power Automate Premium',     N'Software License', 15.00),
    (N'Server Rack Unit',           N'Hardware', 1200.00),
    (N'Network Switch 24-port',     N'Hardware', 450.00),
    (N'Barcode Scanner',            N'Hardware', 180.00),
    (N'Point of Sale Terminal',     N'Hardware', 650.00),
    (N'Implementation Services',    N'Consulting Services', 150.00),
    (N'Data Migration Services',    N'Consulting Services', 175.00),
    (N'Custom Integration Services',N'Consulting Services', 200.00),
    (N'Business Process Review',    N'Consulting Services', 220.00),
    (N'Standard Support Plan',      N'Support Plan', 5000.00),
    (N'Premium Support Plan',       N'Support Plan', 12000.00),
    (N'Onboarding Training',        N'Training', 800.00),
    (N'Admin Certification Course', N'Training', 1200.00),
    (N'Advanced Reporting Course',  N'Training', 950.00),
    (N'Security Audit Package',     N'Consulting Services', 3000.00);
GO
