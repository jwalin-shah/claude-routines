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

## WP-091 Duplicate Logic Consolidation - 2026-05-14

### Scope

- Consolidated required-file discovery for the contract test through
  `scripts/check.sh`.
- No routine skill behavior, schedule, MCP tool, or output format changes.

### Change

- Added `./scripts/check.sh --print-required-files` as the canonical required
  repository file list.
- Updated `tests/check-contract.sh` to build its temporary validation repo from
  that canonical list instead of maintaining a parallel copy list.

### Validation Evidence

- `./scripts/check.sh`: passed.
- `git diff --check`: passed.

## WP-119 CLI Smoke Contract - 2026-05-14

### Scope

- Added a no-secret smoke mode to `scripts/check.sh`.
- Updated `tests/check-contract.sh` to prove smoke success and bad-option
  failure reporting.

### Validation Contract

Run:

```bash
./scripts/check.sh
git diff --check
```
