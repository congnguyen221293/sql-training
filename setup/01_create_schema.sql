-- Schema mô phỏng các entity phổ biến trong Dynamics 365 Sales / Dataverse.
-- Dùng INT IDENTITY thay vì GUID cho dễ học JOIN/aggregate; tên cột theo phong cách
-- logical name của Dataverse (ownerid, statecode, statuscode, createdon...) để quen tay.

USE D365LearnSQL;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- ============ Reference / org structure ============

CREATE TABLE dbo.BusinessUnit (
    businessunitid  INT IDENTITY(1,1) PRIMARY KEY,
    name            NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE dbo.SystemUser (
    systemuserid    INT IDENTITY(1,1) PRIMARY KEY,
    fullname        NVARCHAR(100) NOT NULL,
    title           NVARCHAR(100) NULL,
    businessunitid  INT NOT NULL REFERENCES dbo.BusinessUnit(businessunitid),
    isdisabled      BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE dbo.Team (
    teamid          INT IDENTITY(1,1) PRIMARY KEY,
    name            NVARCHAR(100) NOT NULL,
    businessunitid  INT NOT NULL REFERENCES dbo.BusinessUnit(businessunitid)
);
GO

-- ============ Core sales entities ============

CREATE TABLE dbo.Account (
    accountid           INT IDENTITY(1,1) PRIMARY KEY,
    name                NVARCHAR(150) NOT NULL,
    industrycode         NVARCHAR(50)  NULL,
    revenue             MONEY         NULL,
    numberofemployees   INT           NULL,
    city                NVARCHAR(100) NULL,
    country             NVARCHAR(100) NULL,
    ownerid             INT NOT NULL REFERENCES dbo.SystemUser(systemuserid),
    statecode            TINYINT NOT NULL DEFAULT 0,   -- 0 = Active, 1 = Inactive
    createdon            DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    modifiedon           DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.Contact (
    contactid           INT IDENTITY(1,1) PRIMARY KEY,
    firstname           NVARCHAR(80)  NOT NULL,
    lastname            NVARCHAR(80)  NOT NULL,
    fullname            AS (firstname + N' ' + lastname) PERSISTED,
    emailaddress1        NVARCHAR(150) NULL,
    jobtitle             NVARCHAR(100) NULL,
    parentcustomerid     INT NULL REFERENCES dbo.Account(accountid),
    ownerid              INT NOT NULL REFERENCES dbo.SystemUser(systemuserid),
    statecode            TINYINT NOT NULL DEFAULT 0,
    createdon            DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.Lead (
    leadid              INT IDENTITY(1,1) PRIMARY KEY,
    fullname            NVARCHAR(150) NOT NULL,
    companyname          NVARCHAR(150) NULL,
    emailaddress1        NVARCHAR(150) NULL,
    leadsourcecode       NVARCHAR(50)  NULL,   -- Web, Referral, Trade Show, Cold Call, Advertisement
    statuscode           NVARCHAR(30)  NOT NULL DEFAULT 'Open', -- Open, Qualified, Disqualified
    estimatedvalue        MONEY NULL,
    ownerid              INT NOT NULL REFERENCES dbo.SystemUser(systemuserid),
    createdon            DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    qualifiedon           DATETIME2 NULL
);
GO

CREATE TABLE dbo.Product (
    productid           INT IDENTITY(1,1) PRIMARY KEY,
    name                NVARCHAR(100) NOT NULL,
    category             NVARCHAR(50) NULL,
    price                MONEY NOT NULL
);
GO

CREATE TABLE dbo.Opportunity (
    opportunityid        INT IDENTITY(1,1) PRIMARY KEY,
    name                NVARCHAR(150) NOT NULL,
    customerid           INT NOT NULL REFERENCES dbo.Account(accountid),
    estimatedvalue        MONEY NULL,
    actualvalue           MONEY NULL,
    estimatedclosedate     DATE NULL,
    actualclosedate        DATE NULL,
    statecode            TINYINT NOT NULL DEFAULT 0,     -- 0 = Open, 1 = Won, 2 = Lost
    statuscode            NVARCHAR(30) NOT NULL DEFAULT 'In Progress',
    ownerid              INT NOT NULL REFERENCES dbo.SystemUser(systemuserid),
    createdon            DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE dbo.OpportunityProduct (
    opportunityproductid  INT IDENTITY(1,1) PRIMARY KEY,
    opportunityid         INT NOT NULL REFERENCES dbo.Opportunity(opportunityid),
    productid             INT NOT NULL REFERENCES dbo.Product(productid),
    quantity              INT NOT NULL DEFAULT 1,
    priceperunit           MONEY NOT NULL,
    extendedamount         AS (quantity * priceperunit) PERSISTED
);
GO

CREATE TABLE dbo.Incident (
    incidentid           INT IDENTITY(1,1) PRIMARY KEY,
    title                NVARCHAR(150) NOT NULL,
    customerid           INT NOT NULL REFERENCES dbo.Account(accountid),
    ownerid              INT NOT NULL REFERENCES dbo.SystemUser(systemuserid),
    prioritycode          NVARCHAR(20) NOT NULL DEFAULT 'Normal', -- High, Normal, Low
    statuscode            NVARCHAR(30) NOT NULL DEFAULT 'In Progress', -- In Progress, On Hold, Resolved, Cancelled
    createdon            DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    resolvedon            DATETIME2 NULL
);
GO

CREATE TABLE dbo.Activity (
    activityid            INT IDENTITY(1,1) PRIMARY KEY,
    activitytypecode       NVARCHAR(20) NOT NULL, -- Email, Phone Call, Task, Appointment
    subject               NVARCHAR(200) NOT NULL,
    regarding_accountid     INT NULL REFERENCES dbo.Account(accountid),
    regarding_opportunityid  INT NULL REFERENCES dbo.Opportunity(opportunityid),
    ownerid               INT NOT NULL REFERENCES dbo.SystemUser(systemuserid),
    scheduledstart          DATETIME2 NOT NULL,
    actualend              DATETIME2 NULL,
    statuscode             NVARCHAR(20) NOT NULL DEFAULT 'Open' -- Open, Completed, Canceled
);
GO

CREATE INDEX IX_Contact_ParentCustomer ON dbo.Contact(parentcustomerid);
CREATE INDEX IX_Opportunity_Customer ON dbo.Opportunity(customerid);
CREATE INDEX IX_OpportunityProduct_Opportunity ON dbo.OpportunityProduct(opportunityid);
CREATE INDEX IX_Incident_Customer ON dbo.Incident(customerid);
CREATE INDEX IX_Activity_Account ON dbo.Activity(regarding_accountid);
CREATE INDEX IX_Activity_Opportunity ON dbo.Activity(regarding_opportunityid);
GO
