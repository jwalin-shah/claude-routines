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

## Output Envelope

Envelope name: `morning-digest.v1`

Required fields:
- `generated_at`: ISO-8601 timestamp for when the digest was produced.
- `window`: source window with `start`, `end`, and `timezone`.
- `sections`: ordered list of `must_act`, `fyi`, and `noise` sections.
- `items`: digest entries with `source`, `title`, `summary`, `source_ref`, `age`, and `priority_reason`.
- `delivery`: target channel and delivery status.

Optional fields:
- `omitted_counts`: counts by source for items skipped by cap or filtering.
- `errors`: non-fatal source fetch or delivery errors.

Limits:
- Maximum 15 items total.
- `must_act` appears first and should stay below 5 items unless more are explicitly blocking.
- Each item summary is one sentence.

Consumer contract:
- Consumers may rely on the envelope name, section ids, item fields, and `source_ref`.
- Consumers must not rely on raw email bodies, full notification payloads, or hidden ranking state.
- Source references should be durable enough to reopen the originating Gmail or GitHub item through its connector.

## Markdown Rendering

```
# Digest 2026-04-17

## Must Act (3)
- [Gmail] Sarah — staging deploy broken (2h ago)
- [GH] PR #412 review requested by @alex

## FYI (5)
...
```

Cap at 15 items total.
