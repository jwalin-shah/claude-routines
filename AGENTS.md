# Agent Instructions

This repository stores Claude routine skill definitions. Keep changes small and
reviewable because routine behavior is defined directly in `skills/*/SKILL.md`.

## Scope

- Do not change routine schedules, MCP tool names, output destinations, or output
  formats unless the task explicitly asks for behavior changes.
- Keep each routine self-contained in its skill directory.
- Prefer concise Markdown over generated docs.
- Do not add local-only runtime assumptions; hosted routines cannot rely on the
  local filesystem at execution time.

## Validation

Run this authoritative local validation gate before committing:

```bash
./scripts/check.sh
```

`scripts/check.sh` verifies required files and runs the executable routine
contract validator, including a negative fixture that proves invalid routine
specs fail the gate. It also runs `git diff --check HEAD --` to catch
whitespace errors in staged and unstaged changes. Update the gate when new
routine files or required documentation files are added.
