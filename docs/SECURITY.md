# Security — kng-bizsystem

## Secret Handling
- Supabase service-role key **never** in frontend code or `.env.local` committed to repo
- All client calls use the anon key with RLS as the permission gate
- Environment variables: `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY` only

## Permission Model (end state — after lock-down sprint)
- **Anonymous / unauthenticated**: read-only access to demo seed data only
- **Member**: create and update own records; view all team records
- **Admin**: create/update/delete any record; manage people list
- RLS policies enforce `auth.uid() = user_id` for writes post lock-down

## Approved-Tools Rule
- Agent may only call named tools listed in `AGENTIC_LAYER.md`
- No `run_any`, `eval`, or raw SQL execution from agent context
- Agent inherits the session user's RLS permissions — cannot escalate

## Audit Principle
- Every meaningful action (create, status change, delete attempt, agent action) writes a row to `audit_logs`
- `risk_level` field gates review requirements: critical actions require a second human confirmation before execution
- Audit rows are append-only; deletion is a critical/human-only action
