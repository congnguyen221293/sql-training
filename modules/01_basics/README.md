# Module 1 — Nền tảng: SELECT, WHERE, ORDER BY

Mục tiêu: đọc hiểu và tự viết được các câu SELECT lọc/sắp xếp dữ liệu cơ bản — nền cho mọi
thứ phức tạp hơn sau này (JOIN, aggregation, window functions).

## Lý thuyết ngắn (T-SQL)

**Thứ tự viết câu lệnh** (SELECT ... FROM ... WHERE ... ORDER BY) **khác với thứ tự SQL Server
thực thi**: `FROM` → `WHERE` → `SELECT` → `ORDER BY`. Vì vậy alias đặt trong `SELECT` **không**
dùng được trong `WHERE` (WHERE chạy trước khi alias tồn tại), nhưng dùng được trong `ORDER BY`.

```sql
SELECT column1, column2 AS alias_name
FROM dbo.TableName
WHERE <điều kiện lọc dòng>
ORDER BY column1 [ASC|DESC], column2 [ASC|DESC];
```

**Toán tử lọc thường dùng trong WHERE:**

| Toán tử | Ý nghĩa | Ví dụ |
|---|---|---|
| `=`, `<>`, `>`, `<`, `>=`, `<=` | So sánh | `revenue > 1000000` |
| `AND`, `OR`, `NOT` | Kết hợp điều kiện | `country = 'Vietnam' AND revenue > 5000000` |
| `IN (...)` | Thuộc tập giá trị | `country IN ('Vietnam','Singapore')` |
| `BETWEEN a AND b` | Trong khoảng (bao gồm 2 đầu) | `revenue BETWEEN 1000000 AND 5000000` |
| `LIKE` | So khớp chuỗi (`%` = nhiều ký tự, `_` = 1 ký tự) | `name LIKE N'North%'` |
| `IS NULL` / `IS NOT NULL` | Kiểm tra NULL — **không** dùng `= NULL` | `actualvalue IS NULL` |

**Lưu ý về NULL** (rất hay gặp trong Dataverse vì nhiều field optional): NULL nghĩa là "không có
giá trị", không phải 0 hay chuỗi rỗng. Bất kỳ phép so sánh nào với NULL (`= NULL`, `<> NULL`) đều
trả về `UNKNOWN`, không phải `TRUE`/`FALSE` — dòng đó sẽ **không** xuất hiện trong kết quả. Phải
dùng `IS NULL` / `IS NOT NULL`.

**TOP / DISTINCT:**

```sql
SELECT DISTINCT country FROM dbo.Account;          -- loại trùng
SELECT TOP (5) name, revenue FROM dbo.Account
ORDER BY revenue DESC;                              -- 5 dòng đầu sau khi sort
```

**Alias:** dùng `AS` để đổi tên cột hiển thị hoặc đặt tên cho biểu thức tính toán:

```sql
SELECT name, revenue / 1000000.0 AS revenue_millions
FROM dbo.Account;
```

**Chuỗi trong T-SQL dùng nháy đơn** (`'text'`), thêm tiền tố `N` khi có ký tự Unicode/tiếng Việt:
`N'Hồ Chí Minh'`. Nối chuỗi bằng `+`.

## Bảng dùng trong module này

`dbo.Account`, `dbo.Contact`, `dbo.Lead`, `dbo.Opportunity` — xem cột trong
`setup/01_create_schema.sql`.

## Cách làm bài

1. Mở `exercises.sql`, đọc từng câu hỏi (dạng comment `-- Q1: ...`), tự viết SQL ngay bên dưới.
2. Chạy thử bằng `sqlcmd -S "(localdb)\MSSQLLocalDB" -d D365LearnSQL -i exercises.sql` hoặc qua
   Azure Data Studio / VS Code mssql extension.
3. Đối chiếu với `solutions.sql` — không chỉ xem đáp án đúng/sai mà đọc phần giải thích nếu cách
   bạn làm khác.
