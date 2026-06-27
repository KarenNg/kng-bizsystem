# PRD — kng-bizsystem

## Problem
The team tracks recurring operational work (tasks, statuses, owners, notes) across disconnected spreadsheets and chat threads. There is no shared, authoritative view — things fall through the cracks.

## Target User
Internal team members in the same department; 3–10 people running repeating workflows daily.

## Core Objects
- **Work Record** — the unit of work (title, type, status, assignee, due date, notes, priority)
- **Person** — team member or contact linked to records
- **Activity** — every status change or note added to a record
- **Audit Log** — system-level log of all meaningful actions

## MVP Must-Haves
- [ ] Create a work record (title, type, status, assignee, due date, notes)
- [ ] View all records in a shared dashboard (filterable by status)
- [ ] Change a record's status inline
- [ ] View a record's full detail and activity history
- [ ] App loads with demo data — no login required to evaluate

## Non-Goals (v1)
- No authentication or per-user isolation (added in lock-down sprint)
- No email/notification delivery
- No AI suggestions
- No recurring workflow templates
- No external integrations

## Success Criteria
A team member opens the app, logs a new work record ("Supplier Invoice Check — July", status New, assigned to Sam), saves it, and everyone else on the team immediately sees it on the dashboard with the correct status and assignee — no spreadsheet involved.
