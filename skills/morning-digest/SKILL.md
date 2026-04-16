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
