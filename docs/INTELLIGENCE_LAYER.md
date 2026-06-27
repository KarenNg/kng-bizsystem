# Intelligence Layer — kng-bizsystem

## Messy Inputs
- Free-text notes in various formats
- Inconsistent record types entered by different people
- No priority set on many records
- Due dates sometimes missing

## Auto-Structure Schema (example)
```json
{
  "record_id": "uuid",
  "inferred_type": "Procurement",
  "inferred_priority_score": 0.82,
  "suggested_tags": ["vendor", "contract", "urgent"],
  "suggested_next_action": "Follow up with legal by Friday",
  "confidence": 0.76,
  "source": "gpt-4o-mini",
  "review_status": "unreviewed"
}
```

## Events to Track
- Record created (type, priority, assignee set or blank)
- Status changed (from → to, time elapsed)
- Record age without status change (staleness)
- Notes added frequency

## Scoring Rules (v1 — rule-based)
- `priority_score` = 1.0 if due_date ≤ today+2, 0.7 if ≤ today+7, 0.4 otherwise
- Boost +0.2 if status = Blocked
- Boost +0.1 if notes contain keywords: urgent, escalate, overdue

## What Gets Ranked
- Work records sorted by `priority_score` descending on dashboard

## v1 vs Later
- **v1**: rule-based scorer only; scores stored with `review_status = 'unreviewed'`
- **Later**: replace scorer with LLM call; surface `suggested_next_action` in UI with approve/dismiss
