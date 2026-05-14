# CODEX Workpad

## Portfolio Readiness Pass - 2026-05-12

### Scope

- No routine behavior changes.
- Added a docs-only validation command for the skill bundle.

### Validation Contract

Run:

```bash
./scripts/check.sh
git diff --check
```

### Validation Evidence

- `./scripts/check.sh`: passed.
- `git diff --check`: passed.

## WP-063 Shallow Module Deepening - 2026-05-14

### Scope

- Deepened `scripts/check.sh` as the owned module.
- Updated `tests/check-contract.sh` as the direct caller/test.
- No routine skill behavior changes.

### Change

- Moved required-file validation and skill contract validation behind named
  script functions.
- Replaced the contract test's internal environment recursion guard with the
  script interface: `./scripts/check.sh --skip-contract-tests`.

### Validation Evidence

- `./scripts/check.sh`: passed.
- `git diff --check`: passed.
