# Claude Routines

Anthropic-hosted cron jobs for Claude Code. Each skill = one recurring task.

## Structure

- `skills/morning-digest/` — daily 8am: summarize overnight inbox + GitHub notifications
- `skills/weekly-recap/` — Sunday 6pm: week review from Obsidian Claude Sessions notes

## Setup

1. Push this repo to GitHub
2. In Claude Code: `/routines create` → point at repo + skill folder
3. Anthropic runs on schedule (min 1hr, 5-15/day cap)

## Constraints

- No local filesystem access at runtime
- Must use MCP servers for state (GitHub, Obsidian via HTTPS, etc)
- Output posts back via PushNotification or GitHub issue
