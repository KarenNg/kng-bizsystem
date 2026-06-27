# Agentic Layer — kng-bizsystem

## Risk Levels & Actions

### Low — Auto-execute (log only)
- Tag a record's type from note text
- Compute and store `priority_score`
- Draft `suggested_next_action` text (stored as unreviewed)
- Mark record as stale (flag in UI)

### Medium — Light approval required
- Update a record's status based on AI suggestion
- Reassign a record to a different person
- Add a system-generated note to the activity feed

### High — Always requires human approval
- Send an external notification (email/Slack) on behalf of the team
- Create multiple records in bulk from a template

### Critical — Human-only, no agent
- Delete a work record
- Remove a person from the system
- Export audit logs

## Named Tools (approved list)
- `create_work_record(fields)` — medium
- `update_record_status(record_id, new_status)` — medium
- `score_record_priority(record_id)` — low
- `draft_next_action(record_id)` — low
- `send_notification(channel, message)` — high

## Approval Flow
Draft → shown in UI with confidence → team member approves/dismisses → action executes → audit_log written

## Audit Log Fields
`actor_name`, `action`, `target_table`, `target_id`, `payload (before/after)`, `risk_level`, `created_at`

## v1
No agentic execution in v1. Rule-based scorer runs on record save. All other levels arrive in Sprint 5.
