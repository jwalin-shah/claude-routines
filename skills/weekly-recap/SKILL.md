---
name: weekly-recap
description: Sunday evening review of the week's Claude sessions + GitHub activity
schedule: "0 18 * * 0"
---

# Weekly Recap

Synthesize the week's work into a retrospective.

## Steps

1. Fetch Obsidian notes from `Claude Sessions/` for last 7 days (via obsidian MCP or git)
2. `mcp__github__list_commits` — across active repos, last 7 days
3. Cluster by theme (project, bug-hunt, feature, refactor)
4. Extract: what shipped, what stalled, what surprised
5. Append to vault `Weekly Recaps/YYYY-WW.md`

## Routine Interface

### Routine Inputs
- `time_window_days`: `7` (rolling weekly window ending at execution time)
- `max_items`: `1` recap artifact per week

### Required MCP Tools
- `mcp__obsidian__list` (or git-backed equivalent)
- `mcp__github__list_commits`

### Output Sink
- Obsidian vault write to `Weekly Recaps/YYYY-WW.md` (upsert/append).

### Retry Policy
- `max_attempts`: `3`
- `retry_on`: transient MCP failures (HTTP 5xx, 429, timeout, DNS/network errors)
- `backoff_seconds`: `30, 120, 300`

### Idempotency
- Idempotency key: `weekly-recap::{YYYY}-W{WW}`.
- If `Weekly Recaps/YYYY-WW.md` already contains a completed recap for the week, do not create a second copy.

### Auth Assumptions
- Obsidian MCP access to read and write under `Claude Sessions/` and `Weekly Recaps/`.
- GitHub MCP access to read commits from configured repositories.

### Failure Behavior
- Transient MCP/auth-token errors: retry per policy before surfacing.
- Persistent failure to fetch either source or write output: emit a concise failure summary and keep no partial writes.

## Output format

```
# Week 16 — Apr 14-20

## Shipped
- Inbox MCP deployment (commits a1b2c3..)
- Pipeline verify phase

## Stalled
- OfficeQA SQL solver — 3 sessions, no arena gain

## Surprises
- Caveman plugin actually sticky across sessions
```

Cap at one page.
