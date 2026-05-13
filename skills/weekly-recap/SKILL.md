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

## Output Envelope

Envelope name: `weekly-recap.v1`

Required fields:
- `generated_at`: ISO-8601 timestamp for when the recap was produced.
- `week`: ISO week identifier plus `start`, `end`, and `timezone`.
- `sections`: ordered list of `shipped`, `stalled`, `surprises`, and `next_week` sections.
- `items`: recap entries with `theme`, `summary`, `source_refs`, `repos`, and `status`.
- `destination`: vault path or external destination where the recap was appended.

Optional fields:
- `metrics`: counts for sessions, commits, PRs, and reviewed repos.
- `omitted_counts`: counts by source for entries excluded by length or low signal.
- `errors`: non-fatal source fetch or append errors.

Limits:
- Maximum 20 items total.
- Each section should stay below 6 items.
- Each item summary is one or two sentences.
- Rendered recap should fit on one page.

Consumer contract:
- Consumers may rely on the envelope name, section ids, `source_refs`, repo names, and destination path.
- Consumers must not rely on raw Obsidian note bodies, full commit patches, or hidden clustering state.
- Source references should be durable enough to reopen the originating note, commit, PR, or issue.

## Markdown Rendering

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
