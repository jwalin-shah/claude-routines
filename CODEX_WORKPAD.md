# MAX-275 Workpad

Issue: https://linear.app/symphony-test-jwalin/issue/MAX-275/claude-routines-define-durable-digest-and-recap-output-envelopes

Branch: `codex/MAX-275-claude-routines-output-envelopes`

Base: `origin/main` at `8059a61`

## Scope

Owned files:
- `skills/morning-digest/SKILL.md`
- `skills/weekly-recap/SKILL.md`
- `scripts/validate_output_envelopes.py`

## Changes

- Added `morning-digest.v1` output envelope with required fields, optional fields, limits, and consumer contract.
- Added `weekly-recap.v1` output envelope with required fields, optional fields, limits, and consumer contract.
- Added a small validation script that checks both skill files for envelope names, required fields, section ids, item caps, and source-reference contracts.

## Validation

- `python3 scripts/validate_output_envelopes.py` - pass
- `git diff --check origin/main...HEAD` - pass
