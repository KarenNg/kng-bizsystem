# Data Model — kng-bizsystem

## people
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | gen_random_uuid() |
| user_id | uuid | nullable; owner-scoping at lock-down |
| full_name | text | required |
| role | text | e.g. Team Lead, Analyst |
| email | text | |
| department | text | |
| notes | text | |
| created_at | timestamptz | default now() |

## work_records
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| title | text | required |
| record_type | text | General, Finance, HR, Procurement, etc. |
| status | text | New, In Progress, Done, Blocked |
| priority | text | Low, Normal, High |
| assignee_id | uuid FK → people | |
| due_date | date | |
| notes | text | |
| tags | text[] | |
| **priority_score** | numeric | AI field |
| priority_score_source | text | model/rule name |
| priority_score_confidence | numeric | 0–1 |
| priority_score_review_status | text | default 'unreviewed' |
| **suggested_next_action** | text | AI field |
| suggested_next_action_source | text | |
| suggested_next_action_confidence | numeric | |
| suggested_next_action_review_status | text | default 'unreviewed' |
| created_at | timestamptz | |

## activities
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| record_id | uuid FK → work_records | cascade delete |
| actor_name | text | display name of actor |
| action | text | record_created, status_change, note_added |
| field_changed | text | nullable |
| old_value | text | nullable |
| new_value | text | nullable |
| note | text | optional free text |
| created_at | timestamptz | |

## audit_logs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid | nullable |
| actor_name | text | |
| action | text | |
| target_table | text | |
| target_id | uuid | |
| payload | jsonb | full before/after snapshot |
| risk_level | text | low / medium / high / critical |
| created_at | timestamptz | |

## RLS
All tables: permissive v1 policies (select/all open). Lock-down sprint replaces with `auth.uid() = user_id`.
