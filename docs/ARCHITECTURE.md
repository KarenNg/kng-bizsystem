# Architecture — kng-bizsystem

## Stack
- **Frontend**: Next.js (App Router) on Vercel
- **Database + API**: Supabase (Postgres, RLS, Realtime)
- **Auth** *(lock-down sprint)*: Supabase Auth

## Build Sequence
**Now**: Tables → record creation form → dashboard list → status updates → activity log 
**Next**: Auth, roles, filters/search, notifications 
**Later**: AI tagging, scoring, automation

## Key Action Flow — "Log a Work Record"
1. Team member fills the New Record form (title, type, status, assignee, due date, notes)
2. Client validates required fields; shows inline errors if missing
3. `INSERT` into `work_records`; `INSERT` into `activities` (action: record_created)
4. `INSERT` into `audit_logs` (risk: low)
5. Dashboard query re-fetches (or Supabase Realtime pushes update)
6. All team members see the new row immediately with correct status badge

## Layer Plan
1. **Data layer** — schema, seed, RLS policies
2. **App logic** — CRUD forms, status machine, activity writes (runs fully without AI)
3. **Smart features** — rule-based priority scorer, then AI draft suggestions (later)

## Why Core Runs Without AI
All create/update/status-change operations are pure database writes with deterministic business rules. AI features add scored/drafted fields on top; removing them leaves the workflow intact.
