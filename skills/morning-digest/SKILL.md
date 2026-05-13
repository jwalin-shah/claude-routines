---
name: morning-digest
description: Daily 8am digest of overnight inbox + GitHub activity
schedule: "0 8 * * *"
---

# Morning Digest

Fetch overnight signal, return one-page markdown.

## Steps

1. `mcp__gmail__list_unread` — last 12 hours, skip lists/promos
2. `mcp__github__notifications` — mentions + review requests
3. Rank by sender importance + keyword match (urgent, blocking, review)
4. Output markdown: `## Must Act` / `## FYI` / `## Noise`
5. Post via PushNotification

## Routine Interface

### Routine Inputs
- `time_window_hours`: `12` (overnight window ending at execution time)
- `max_items`: `15` digest entries total

### Required MCP Tools
- `mcp__gmail__list_unread`
- `mcp__github__notifications`

### Output Sink
- PushNotification message titled `Digest YYYY-MM-DD`

### Retry Policy
- `max_attempts`: `3`
- `retry_on`: transient MCP failures (HTTP 5xx, 429, timeout, DNS/network errors)
- `backoff_seconds`: `30, 120, 300`

### Idempotency
- Idempotency key: `morning-digest::{YYYY-MM-DD}`.
- If a digest for the same date exists in output history, skip reposting unchanged content and emit only a no-op note.

### Auth Assumptions
- Gmail MCP access with read access to unread messages.
- GitHub MCP access with notification read scope.
- PushNotification credentials available at runtime.

### Failure Behavior
- Transient MCP/auth-token errors: retry per policy before surfacing.
- Permanent auth/scope/tooling errors: fail fast, report a short failure summary, and do not retry.

## Output format

```
# Digest 2026-04-17

## Must Act (3)
- [Gmail] Sarah — staging deploy broken (2h ago)
- [GH] PR #412 review requested by @alex

## FYI (5)
...
```

Cap at 15 items total.
