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
