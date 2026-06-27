# Tasks — kng-bizsystem

## Gantt Overview
```
Sprint 1  [DB + Record Engine]      Week 1 days 1-2
Sprint 2  [Dashboard — v1 ✅]       Week 1 days 3-5
Sprint 3  [People & Assignment]     Week 2 days 1-2
Sprint 4  [Lock It Down — Auth]     Week 2 days 3-4
Sprint 5  [Intelligence]            Week 2 day 5 +
```

---

## Sprint 1 — Database & Core Record Engine
**Goal**: Schema live; team member can create a work record and it persists.

- [ ] Apply migration SQL (all tables + seed data) to Supabase
- [ ] Verify seed rows visible in Supabase table editor
- [ ] Build `/records/new` form: title, record_type, status, assignee, due_date, notes
- [ ] Wire form submit → `supabase.from('work_records').insert()`
- [ ] On success: write activity row (record_created) + audit_log row
- [ ] Show success toast; redirect to dashboard
- [ ] Handle validation errors (required fields) and DB errors inline
- [ ] Loading state on submit button

**DoD**: Submit form → row appears in `work_records` table → activity row written → no console errors.

---

## Sprint 2 — Operational Dashboard ✅ v1 functional
**Goal**: Shared live view of all records; status can be changed; detail view with history.

- [ ] Build `/` dashboard: table of all `work_records` joined with `people` (assignee name)
- [ ] Status badge component (colour-coded: New=grey, In Progress=blue, Done=green, Blocked=red)
- [ ] Inline status change dropdown → `supabase.from('work_records').update()` → writes activity row
- [ ] Filter bar: by status, by assignee
- [ ] Build `/records/[id]` detail page: all fields + activity feed (chronological)
- [ ] Empty state (no records yet) with call-to-action to create first record
- [ ] Loading skeleton on dashboard table
- [ ] Error boundary with retry

**DoD**: Dashboard loads seed data without login; status change persists and reflects immediately; detail page shows activity history; success scenario walkable end-to-end.

---

## Sprint 3 — People & Assignment
**Goal**: Team members can be listed, viewed, and assigned to records.

- [ ] Build `/people` list page: name, role, department, record count
- [ ] Build `/people/new` form: full_name, role, email, department, notes
- [ ] Quick-add person modal accessible from record form assignee field
- [ ] Assignee dropdown on record form populated from `people` table
- [ ] Reassign from record detail panel → writes activity row
- [ ] Show assignee avatar initials + name on dashboard row

**DoD**: People CRUD works; assigning a person to a record persists and shows on dashboard.

---

## Sprint 4 — Lock It Down (Auth & Permissions)
**Goal**: Only authenticated team members can write data; roles enforced.

- [ ] Enable Supabase Auth (email/password)
- [ ] Add `/login` and `/signup` pages
- [ ] Middleware: redirect unauthenticated users to `/login` for write actions
- [ ] Replace permissive RLS policies with `auth.uid() = user_id` owner policies
- [ ] Seed membership roles (Admin, Member) in `people.role`
- [ ] Hide delete/admin actions from Member role in UI
- [ ] Admin-only: delete record (critical — confirm dialog + audit log)

**DoD**: Unauthenticated user can view dashboard (demo mode); cannot submit forms; authenticated member can create/update; admin can delete.

---

## Sprint 5 — Intelligence & Automation
**Goal**: Records are auto-scored and AI drafts next-action suggestions.

- [ ] Rule-based priority scorer runs on record save; stores `priority_score` + source + confidence
- [ ] Dashboard sorts by `priority_score` descending by default
- [ ] Stale-record flag: highlight records with no activity in > 5 days
- [ ] AI draft: call LLM on record save → store `suggested_next_action` as unreviewed
- [ ] Show suggestion in detail view with Approve / Dismiss buttons
- [ ] Approval writes action to activity log; dismiss sets review_status = 'dismissed'
- [ ] All agent calls logged to `audit_logs` with risk_level

**DoD**: Priority score visible on dashboard; AI suggestion appears on detail page; approve/dismiss persists and is audited.
