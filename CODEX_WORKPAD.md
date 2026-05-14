# CODEX Workpad

## Portfolio Readiness Pass - 2026-05-12

### Scope

- No routine behavior changes.
- Added a docs-only validation command for the skill bundle.

### Validation Contract

Run:

```bash
./scripts/check.sh
```

### Validation Evidence

- `./scripts/check.sh`: passed.
- `git diff --check`: passed.

## WP-007 - Local Validation Gate

### Scope

- Replace grep-only routine checks with an executable routine contract validator.
- Keep hosted routine behavior unchanged.

### Validation Contract

Run:

```bash
./scripts/check.sh
```

### Acceptance Notes

- `./scripts/check.sh` is the single local validation gate for repo and routine
  contract checks.
- `scripts/validate_routines.py --self-test skills` parses routine specs and
  proves a known-bad routine exits nonzero.
- `git diff --check HEAD --` is included in the gate for staged and unstaged
  whitespace validation.

### Validation Evidence

- `./scripts/check.sh`: passed.
- `git diff --check`: passed.
