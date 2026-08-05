# Học SQL qua dữ liệu kiểu Dynamics 365 CRM

Project này giúp bạn (senior dev D365 CE / Power Platform) củng cố SQL bằng cách thực hành
trên một database mô phỏng các entity quen thuộc trong Dataverse: **Account, Contact, Lead,
Opportunity, OpportunityProduct, Incident (Case), Activity**, kèm tên cột theo phong cách
logical name của Dataverse (`ownerid`, `statecode`, `statuscode`, `createdon`...) để vừa học
SQL vừa quen dần với cách CRM lưu dữ liệu bên dưới.

## 1. Cài đặt / khởi tạo database

Máy bạn đã có sẵn **SQL Server LocalDB** (`(localdb)\MSSQLLocalDB`) và `sqlcmd`, không cần cài
thêm gì. Chạy:

```powershell
./setup/run_setup.ps1          # tạo database nếu chưa có
./setup/run_setup.ps1 -Reset   # xoá và build lại từ đầu (dùng khi bạn lỡ sửa/xoá dữ liệu lung tung)
```

Database tên là **`D365LearnSQL`**. Kết nối bằng:

- `sqlcmd -S "(localdb)\MSSQLLocalDB" -d D365LearnSQL`
- Azure Data Studio / SSMS: server name = `(localdb)\MSSQLLocalDB`
- VS Code extension "SQL Server (mssql)": cùng server name như trên

Dữ liệu được sinh bằng công thức (không random thật) nên **kết quả luôn giống nhau** mỗi lần
`-Reset` — nhờ vậy đáp án trong các file `solutions.sql` luôn đúng, không lệch theo lần chạy.

## 2. Sơ đồ dữ liệu (rút gọn)

```
BusinessUnit ──< SystemUser ──< Team
                     │(ownerid)
                     ├──< Account ──< Contact
                     │        │  │
                     │        │  └──< Incident (case)
                     │        └──< Opportunity ──< OpportunityProduct >── Product
                     ├──< Lead
                     └──< Activity  >── (regarding Account hoặc Opportunity)
```

Số lượng bản ghi: 200 Account, 500 Contact, 300 Lead, 400 Opportunity, ~800 OpportunityProduct,
250 Incident, 1000 Activity, 20 SystemUser, 20 Product.

Chi tiết cột: xem `setup/01_create_schema.sql` (có comment giải thích từng bảng).

## 3. Cách học

Mỗi module nằm trong `modules/0X_ten_module/`:

- `README.md` — lý thuyết ngắn, tập trung vào cú pháp SQL Server (T-SQL) vì đó là thứ bạn sẽ
  dùng khi query Dataverse qua TDS endpoint / Synapse Link.
- `exercises.sql` — đề bài, tự làm trước.
- `solutions.sql` — đáp án + giải thích, chỉ mở sau khi đã thử.

Làm lần lượt từ module 1. Mỗi module dùng chính database `D365LearnSQL` này nên câu sau có thể
build trên khái niệm câu trước.

## 4. Lộ trình (roadmap)

| # | Module | Nội dung chính | Trạng thái |
|---|--------|-----------------|------------|
| 1 | [Nền tảng](modules/01_basics/README.md) | SELECT, WHERE, ORDER BY, DISTINCT, TOP, LIKE/IN/BETWEEN, xử lý NULL, alias | ✅ Sẵn sàng |
| 2 | [JOIN](modules/02_join/README.md) | INNER/LEFT/RIGHT/FULL JOIN, self join, join nhiều bảng, ANSI join, bẫy ON vs WHERE, anti-join | ✅ Sẵn sàng |
| 3 | Aggregation | GROUP BY, HAVING, COUNT/SUM/AVG/MIN/MAX, ROLLUP | ⏳ Sắp tới |
| 4 | Subquery & CTE | Subquery lồng nhau, correlated subquery, CTE, recursive CTE | ⏳ Sắp tới |
| 5 | Window Functions | ROW_NUMBER, RANK, DENSE_RANK, PARTITION BY, LAG/LEAD, running total | ⏳ Sắp tới |
| 6 | Thao tác dữ liệu & Transaction | INSERT/UPDATE/DELETE/MERGE, transaction, isolation level | ⏳ Sắp tới |
| 7 | Index & hiệu năng | Execution plan, loại index, SARGable predicate | ⏳ Sắp tới |
| 8 | Stored Procedure / View / Function | Đóng gói logic, tham số hoá, reuse | ⏳ Sắp tới |
| 9 | SQL cho Dataverse thực chiến | TDS endpoint, bảng export qua Synapse Link, khác biệt so với FetchXML, Power BI DirectQuery | ⏳ Sắp tới |

Các module 2 trở đi sẽ được viết dần khi bạn hoàn thành module trước — báo lại là mình viết tiếp.

## 5. Vì sao dùng T-SQL / SQL Server thay vì SQL tổng quát

Trong công việc D365 CE / Power Platform, SQL bạn thực sự đụng tới hầu hết là T-SQL, qua các
đường:

- **Dataverse TDS Endpoint** — connect trực tiếp bằng SSMS/`sqlcmd` với cú pháp SELECT (read-only,
  không hỗ trợ 100% T-SQL nhưng cú pháp nền vẫn là T-SQL).
- **Azure Synapse Link for Dataverse** — export dữ liệu Dataverse ra Azure Synapse/Data Lake,
  query bằng T-SQL (serverless SQL pool).
- **Power BI DirectQuery / Dataflows** — khi nguồn là SQL Server/Synapse, câu query sinh ra hoặc
  bạn viết custom đều là T-SQL.

Vì vậy toàn bộ project này dùng SQL Server LocalDB để những gì học được áp dụng thẳng vào công
việc, không phải dịch lại cú pháp giữa các engine.
