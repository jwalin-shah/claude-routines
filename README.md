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

## Fixtures and Runtime Output

Tracked docs and architecture files are deterministic fixtures/evidence. Local
validation runs, generated logs, caches, and scratch outputs should use the
ignored `.codex-runtime/` directory instead of writing beside tracked fixtures.

## Validation

Run the lightweight validation contract before opening a PR:

```bash
./scripts/check.sh
git diff --check
```

The check script verifies required repository docs, expected routine files,
routine frontmatter fields, a basic output-format section, and an explicit
hosted output destination for each routine. It also verifies that the default
local runtime output directory is ignored by Git.

For a no-secret entrypoint smoke check that skips nested contract tests, run:

```bash
./scripts/check.sh --smoke
```
