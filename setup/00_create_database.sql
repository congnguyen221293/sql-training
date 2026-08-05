-- Tạo database học SQL, mô phỏng theo mô hình dữ liệu Dataverse/D365 CRM.
-- Chạy trên (localdb)\MSSQLLocalDB

IF DB_ID('D365LearnSQL') IS NULL
BEGIN
    CREATE DATABASE D365LearnSQL;
END
GO
