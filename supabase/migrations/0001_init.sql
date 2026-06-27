create table if not exists people (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  full_name text not null,
  role text,
  email text,
  department text,
  notes text
);

alter table people enable row level security;
drop policy if exists "people_v1_read" on people;
create policy "people_v1_read" on people for select using (true);
drop policy if exists "people_v1_write" on people;
create policy "people_v1_write" on people for all using (true) with check (true);

create table if not exists work_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  title text not null,
  record_type text not null default 'General',
  status text not null default 'New',
  priority text not null default 'Normal',
  assignee_id uuid references people(id),
  due_date date,
  notes text,
  tags text[],
  priority_score numeric,
  priority_score_source text,
  priority_score_confidence numeric,
  priority_score_review_status text default 'unreviewed',
  suggested_next_action text,
  suggested_next_action_source text,
  suggested_next_action_confidence numeric,
  suggested_next_action_review_status text default 'unreviewed'
);

alter table work_records enable row level security;
drop policy if exists "work_records_v1_read" on work_records;
create policy "work_records_v1_read" on work_records for select using (true);
drop policy if exists "work_records_v1_write" on work_records;
create policy "work_records_v1_write" on work_records for all using (true) with check (true);

create table if not exists activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  record_id uuid references work_records(id) on delete cascade,
  actor_name text not null,
  action text not null,
  field_changed text,
  old_value text,
  new_value text,
  note text
);

alter table activities enable row level security;
drop policy if exists "activities_v1_read" on activities;
create policy "activities_v1_read" on activities for select using (true);
drop policy if exists "activities_v1_write" on activities;
create policy "activities_v1_write" on activities for all using (true) with check (true);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  created_at timestamptz not null default now(),
  actor_name text not null,
  action text not null,
  target_table text not null,
  target_id uuid,
  payload jsonb,
  risk_level text default 'low'
);

alter table audit_logs enable row level security;
drop policy if exists "audit_logs_v1_read" on audit_logs;
create policy "audit_logs_v1_read" on audit_logs for select using (true);
drop policy if exists "audit_logs_v1_write" on audit_logs;
create policy "audit_logs_v1_write" on audit_logs for all using (true) with check (true);

insert into people (id, full_name, role, email, department) values
  ('a1000000-0000-0000-0000-000000000001', 'Jordan Lee', 'Team Lead', 'jordan@kng.internal', 'Operations'),
  ('a1000000-0000-0000-0000-000000000002', 'Sam Rivera', 'Analyst', 'sam@kng.internal', 'Operations'),
  ('a1000000-0000-0000-0000-000000000003', 'Morgan Chen', 'Coordinator', 'morgan@kng.internal', 'Operations')
on conflict (id) do nothing;

insert into work_records (id, title, record_type, status, priority, assignee_id, due_date, notes) values
  ('b1000000-0000-0000-0000-000000000001', 'Monthly Vendor Invoice Reconciliation', 'Finance', 'In Progress', 'High', 'a1000000-0000-0000-0000-000000000001', current_date + 3, 'Cross-check Q2 invoices against PO log. Three vendors outstanding.'),
  ('b1000000-0000-0000-0000-000000000002', 'Onboarding Checklist — New Hire (Alex)', 'HR', 'New', 'Normal', 'a1000000-0000-0000-0000-000000000002', current_date + 7, 'Equipment ordered. Access requests pending IT.'),
  ('b1000000-0000-0000-0000-000000000003', 'Weekly Ops Report to Management', 'Reporting', 'Done', 'Normal', 'a1000000-0000-0000-0000-000000000001', current_date - 1, 'Submitted Friday. Filed in shared drive.'),
  ('b1000000-0000-0000-0000-000000000004', 'Supplier Contract Renewal — Delta Co', 'Procurement', 'Blocked', 'High', 'a1000000-0000-0000-0000-000000000003', current_date + 14, 'Waiting on legal sign-off. Escalate if no response by EOD Friday.'),
  ('b1000000-0000-0000-0000-000000000005', 'Q3 Capacity Planning Sheet', 'Planning', 'In Progress', 'Normal', 'a1000000-0000-0000-0000-000000000002', current_date + 10, 'Draft shared with leads. Awaiting headcount numbers from HR.')
on conflict (id) do nothing;

insert into activities (record_id, actor_name, action, field_changed, old_value, new_value) values
  ('b1000000-0000-0000-0000-000000000001', 'Jordan Lee', 'status_change', 'status', 'New', 'In Progress'),
  ('b1000000-0000-0000-0000-000000000003', 'Jordan Lee', 'status_change', 'status', 'In Progress', 'Done'),
  ('b1000000-0000-0000-0000-000000000004', 'Morgan Chen', 'status_change', 'status', 'In Progress', 'Blocked'),
  ('b1000000-0000-0000-0000-000000000002', 'Sam Rivera', 'record_created', null, null, null),
  ('b1000000-0000-0000-0000-000000000005', 'Sam Rivera', 'note_added', 'notes', null, 'Draft shared with leads. Awaiting headcount numbers from HR.')
on conflict do nothing;