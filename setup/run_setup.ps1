<#
.SYNOPSIS
    Tạo (hoặc build lại từ đầu) database D365LearnSQL trên SQL Server LocalDB.

.EXAMPLE
    ./run_setup.ps1            # tạo mới nếu chưa có, giữ nguyên nếu đã có
    ./run_setup.ps1 -Reset     # xoá và tạo lại từ đầu (mất hết dữ liệu bạn đã tự thêm/sửa)
#>
param(
    [switch]$Reset
)

$ErrorActionPreference = "Stop"
$Instance = "(localdb)\MSSQLLocalDB"
$ScriptDir = $PSScriptRoot

function Find-SqlCmd {
    $cmd = Get-Command sqlcmd -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $candidates = @(
        "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE",
        "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\180\Tools\Binn\SQLCMD.EXE"
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    throw "Khong tim thay sqlcmd.exe. Cai SQL Server Command Line Utilities hoac sua duong dan trong script nay."
}

$SqlCmd = Find-SqlCmd
Write-Host "Dung sqlcmd: $SqlCmd"
Write-Host "Instance   : $Instance"

if ($Reset) {
    Write-Host "`n[Reset] Dang xoa database D365LearnSQL neu ton tai..."
    & $SqlCmd -S $Instance -Q "DROP DATABASE IF EXISTS D365LearnSQL" -b
}

$scripts = @(
    "00_create_database.sql",
    "01_create_schema.sql",
    "02_seed_reference_data.sql",
    "03_seed_transactional_data.sql"
)

foreach ($s in $scripts) {
    $path = Join-Path $ScriptDir $s
    Write-Host "`n[Run] $s"
    & $SqlCmd -S $Instance -i $path -b
    if ($LASTEXITCODE -ne 0) {
        throw "Script $s that bai (exit code $LASTEXITCODE)"
    }
}

Write-Host "`n=== Kiem tra so dong du lieu ==="
& $SqlCmd -S $Instance -d D365LearnSQL -Q "
SELECT 'Account' t, COUNT(*) c FROM dbo.Account
UNION ALL SELECT 'Contact', COUNT(*) FROM dbo.Contact
UNION ALL SELECT 'Lead', COUNT(*) FROM dbo.Lead
UNION ALL SELECT 'Opportunity', COUNT(*) FROM dbo.Opportunity
UNION ALL SELECT 'OpportunityProduct', COUNT(*) FROM dbo.OpportunityProduct
UNION ALL SELECT 'Incident', COUNT(*) FROM dbo.Incident
UNION ALL SELECT 'Activity', COUNT(*) FROM dbo.Activity;
" -W

Write-Host "`nXong. Ket noi bang: sqlcmd -S ""$Instance"" -d D365LearnSQL"
Write-Host "Hoac dung Azure Data Studio / SSMS voi server name: $Instance"
