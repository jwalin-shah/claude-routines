# Claude Routines

Anthropic-hosted Claude Code routines. Each routine is represented by one
`SKILL.md` file under `skills/`.

## Routines

- `skills/morning-digest/` runs daily at 8am and summarizes overnight inbox plus
  GitHub notification signal.
- `skills/weekly-recap/` runs Sunday at 6pm and synthesizes the week's Claude
  sessions plus GitHub activity.

## Repository Layout

- `CLAUDE.md` documents the runtime model and hosted routine constraints.
- `AGENTS.md` gives repo-local instructions for agents editing this repository.
- `skills/*/SKILL.md` contains routine frontmatter, steps, and output contracts.
- `scripts/check.sh` is the authoritative local validation gate.
- `docs/architecture/` contains portfolio audit artifacts and issue candidates.

## Validation

Run the authoritative local validation gate before opening a PR:

```bash
./scripts/check.sh
```

The gate verifies required repository docs, expected routine files, and the
executable routine validator. The validator parses every `skills/*/SKILL.md`
contract, checks required frontmatter, cron schedule shape, required sections,
fenced output examples, and an explicit hosted output destination. It also runs
a negative fixture so the command exits nonzero when that contract is broken.
The gate also runs `git diff --check HEAD --` to catch whitespace errors in
staged and unstaged changes before handoff.
