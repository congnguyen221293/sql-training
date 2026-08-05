# Module 2 — JOIN

Mục tiêu: kết hợp dữ liệu từ nhiều bảng — kỹ năng dùng nhiều nhất trong thực tế, vì dữ liệu
CRM/Dataverse luôn chia nhỏ thành nhiều entity liên kết bằng khoá ngoại (giống `parentcustomerid`,
`ownerid`, `customerid` bạn thấy trong schema).

## Lý thuyết ngắn (T-SQL)

**Cú pháp chuẩn (ANSI join) — luôn dùng cách này, không dùng cú pháp cũ `FROM A, B WHERE A.id=B.id`**
(cú pháp cũ dễ biến thành CROSS JOIN — nhân chéo mọi dòng — nếu quên điều kiện):

```sql
SELECT ...
FROM dbo.Contact c
INNER JOIN dbo.Account a ON a.accountid = c.parentcustomerid
```

Luôn đặt alias ngắn cho bảng (`c`, `a`...) để câu lệnh gọn và rõ cột thuộc bảng nào.

### Các loại JOIN

| Loại | Lấy gì |
|---|---|
| `INNER JOIN` | Chỉ lấy dòng **khớp ở cả 2 bảng**. Không khớp → bị loại hoàn toàn. |
| `LEFT JOIN` | Lấy **hết** dòng bên trái (bảng viết trước); bên phải không khớp thì các cột của nó ra `NULL`. |
| `RIGHT JOIN` | Ngược lại LEFT JOIN. Hiếm dùng — thường đổi thứ tự 2 bảng rồi dùng LEFT JOIN cho dễ đọc. |
| `FULL OUTER JOIN` | Lấy hết cả 2 bên, chỗ nào không khớp thì NULL. Hiếm dùng, chủ yếu để đối chiếu 2 tập dữ liệu. |

### Bẫy hay gặp: điều kiện lọc đặt trong `ON` hay `WHERE`?

Với `LEFT JOIN`, đặt điều kiện lọc bảng phải (bên phải) ở `WHERE` sẽ **vô tình biến LEFT JOIN
thành INNER JOIN** — vì dòng có bên phải NULL sẽ bị `WHERE` loại luôn.

```sql
-- SAI Ý ĐỊNH: muốn "tất cả Account, kèm Incident đã Resolved nếu có"
-- nhưng WHERE loại mất account không có incident nao ca (a.accountid NULL bi loai)
SELECT a.name, i.title
FROM dbo.Account a
LEFT JOIN dbo.Incident i ON i.customerid = a.accountid
WHERE i.statuscode = N'Resolved';   -- BUG: đã thành INNER JOIN

-- ĐÚNG: điều kiện lọc bên phải phải nằm trong ON
SELECT a.name, i.title
FROM dbo.Account a
LEFT JOIN dbo.Incident i ON i.customerid = a.accountid AND i.statuscode = N'Resolved';
```

Quy tắc nhớ: **điều kiện lọc bảng bên phải của LEFT JOIN → để trong `ON`. Điều kiện lọc bảng bên
trái → để trong `WHERE` như bình thường.**

### Tìm "không có bản ghi liên quan" (anti-join)

Kiểu hỏi rất hay gặp: "user nào chưa sở hữu account nào?" — LEFT JOIN rồi lọc `WHERE <cột bên
phải> IS NULL`:

```sql
SELECT su.fullname
FROM dbo.SystemUser su
LEFT JOIN dbo.Account a ON a.ownerid = su.systemuserid
WHERE a.accountid IS NULL;   -- chỉ còn lại user KHÔNG khớp dòng Account nào
```

### Self JOIN

Join 1 bảng với chính nó để so sánh các dòng trong cùng bảng — bắt buộc đặt 2 alias khác nhau:

```sql
SELECT a1.name, a2.name, a1.city
FROM dbo.Account a1
JOIN dbo.Account a2 ON a1.city = a2.city AND a1.accountid < a2.accountid
```

`a1.accountid < a2.accountid` (chứ không phải `<>`) để tránh 2 lỗi: (1) một dòng tự ghép với
chính nó, (2) mỗi cặp bị lặp lại 2 lần theo 2 chiều.

### JOIN nhiều bảng

Nối thêm `JOIN` là được, mỗi `JOIN` có `ON` riêng:

```sql
SELECT o.name, a.name AS account_name, su.fullname AS owner_name
FROM dbo.Opportunity o
JOIN dbo.Account a ON a.accountid = o.customerid
JOIN dbo.SystemUser su ON su.systemuserid = o.ownerid
```

## Cách làm bài

Giống Module 1: đọc `exercises.sql`, tự viết, đối chiếu `solutions.sql`.
