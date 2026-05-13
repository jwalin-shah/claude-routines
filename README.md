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
- `scripts/check.sh` validates the minimal docs and skill contract.
- `docs/architecture/` contains portfolio audit artifacts and issue candidates.

## Validation

Run the lightweight validation contract before opening a PR:

```bash
./scripts/check.sh
git diff --check
```

The check script verifies required repository docs, expected routine files,
routine frontmatter fields, and a basic output-format section for each routine.
