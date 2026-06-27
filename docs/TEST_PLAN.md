# Test Plan — kng-bizsystem

## Success Scenario (manual walkthrough)
1. Open app at `/` — dashboard loads with seed records, no login required
2. Verify 5 seed records visible with correct status badges and assignee names
3. Click **New Record** → form opens
4. Submit with title blank → validation error shown inline, no DB write
5. Fill: title="Supplier Invoice Check — July", type=Finance, status=New, assignee=Sam Rivera, due_date=next Friday
6. Click **Save** → loading state shows → success toast appears → redirected to dashboard
7. New record appears at top of dashboard with status badge "New" and assignee "Sam Rivera"
8. Open a second browser tab — new record is visible there too (shared state)
9. Click status dropdown on new record → select "In Progress" → badge updates immediately
10. Click record title → detail page opens → activity feed shows: "record_created" then "status_change New → In Progress"

## Empty State
- Delete all records via Supabase table editor → reload `/` → empty state message with **Create First Record** CTA visible

## Error Cases
- Disconnect Supabase (invalid URL) → dashboard shows error banner with retry button, no crash
- Submit new record form with DB offline → inline error message; form data preserved
- Navigate to `/records/nonexistent-id` → 404 message shown, link back to dashboard

## Status Workflow
- Cycle a record through all statuses: New → In Progress → Blocked → Done
- Verify each change persists on page refresh
- Verify each change creates an activity row visible in detail view

## People
- Create a new person via `/people/new` → appears in assignee dropdown on record form
- Assign new person to existing record → dashboard row shows updated assignee name
