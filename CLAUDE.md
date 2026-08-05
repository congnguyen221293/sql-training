# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a personal SQL-learning project for a senior Dynamics 365 CE / Power Platform developer
who wants to strengthen T-SQL skills. Content and conversation with the user should default to
**Vietnamese**, matching the existing docs. The dataset intentionally mirrors common Dataverse
entities (Account, Contact, Lead, Opportunity, Incident, Activity) with Dataverse-style logical
column names (`ownerid`, `statecode`, `statuscode`, `createdon`) so lessons transfer directly to
the user's real work: querying Dataverse via the TDS endpoint, Azure Synapse Link export tables,
and Power BI DirectQuery — all of which are T-SQL. It is part of the larger git repo rooted at
`D:\Claude projects` (remote: `congnguyen221293/claude`), alongside sibling projects
(`mcp-apim-tools`, `mcp-dataverse-tools`, `mcp-devops`, `mcp-msauth`, `D365CE`, `TMRW`, `CUHK`,
`LEVYPRECASE`), but is self-contained.

## Environment

- Database engine: **SQL Server LocalDB**, instance `(localdb)\MSSQLLocalDB`.
- Client: `sqlcmd.exe` at `C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE`
  (also try plain `sqlcmd` if on PATH).
- Database name: `D365LearnSQL`.

## Common commands

```powershell
# (Re)build the whole database from scratch
./setup/run_setup.ps1 -Reset

# Build only if it doesn't exist yet
./setup/run_setup.ps1

# Run any .sql file against the learning DB
sqlcmd -S "(localdb)\MSSQLLocalDB" -d D365LearnSQL -i path\to\file.sql
```

Setup scripts run in strict order: `00_create_database.sql` → `01_create_schema.sql` →
`02_seed_reference_data.sql` → `03_seed_transactional_data.sql`. All computed-column tables
(`Contact.fullname`, `OpportunityProduct.extendedamount`) require `SET QUOTED_IDENTIFIER ON`
before any `CREATE TABLE`/`INSERT` touching them — every setup script sets this explicitly at
the top; keep doing so in any new script that touches those tables.

**Seed data is deterministic** (generated via modulo-arithmetic formulas over lookup tables, not
`RAND()`/`NEWID()`), so row counts and values are identical every time `-Reset` runs. This is
required — the `solutions.sql` files depend on stable data.

## Architecture

- `setup/` — DB creation, schema DDL, and seed-data SQL scripts, plus `run_setup.ps1`.
- `modules/0X_topic/` — one folder per learning module, each with:
  - `README.md` — short theory notes (T-SQL specific)
  - `exercises.sql` — questions as comments, blank space for the user's answers
  - `solutions.sql` — worked answers with explanatory comments
- `scratch/` — free space for the user's own practice queries; not curriculum content.
- `README.md` (root) — the learning roadmap/index; keep its module status table in sync when
  adding or completing modules.

## Schema (dbo, in `D365LearnSQL`)

CRM-style entities with FK relationships:

```
BusinessUnit ──< SystemUser ──< Team
                     │(ownerid)
                     ├──< Account ──< Contact
                     │        │  └──< Incident
                     │        └──< Opportunity ──< OpportunityProduct >── Product
                     ├──< Lead
                     └──< Activity  >── (regarding_accountid or regarding_opportunityid)
```

Row counts: 200 Account, 500 Contact, 300 Lead, 400 Opportunity, ~800 OpportunityProduct, 250
Incident, 1000 Activity, 20 SystemUser, 20 Product, 5 BusinessUnit, 5 Team.

## Conventions when extending this project

- New modules go under `modules/0N_name/` following the existing three-file pattern
  (`README.md`, `exercises.sql`, `solutions.sql`).
- Always execute new/changed `solutions.sql` against the LocalDB instance before considering a
  module done — verify zero errors, not just plausible syntax.
- Update the roadmap table in root `README.md` (module status ✅/⏳) whenever a module is added
  or completed.
- Keep exercises scoped to concepts covered so far or in the current module — don't require
  syntax from a later module to solve an earlier one.
- Schema changes (new tables/columns) belong in `setup/01_create_schema.sql`; corresponding seed
  logic goes in `setup/03_seed_transactional_data.sql`. Re-run `run_setup.ps1 -Reset` and confirm
  row counts after any schema/seed change.
