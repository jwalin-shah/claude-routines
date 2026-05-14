#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/scripts"
cp -R AGENTS.md CLAUDE.md README.md scripts skills tests "$tmpdir/"

CLAUDE_ROUTINES_SKIP_CONTRACT_TESTS=1 "$tmpdir/scripts/check.sh" >/dev/null

perl -0pi -e 's/schedule: "0 8 \* \* \*"/schedule: "daily"/' \
  "$tmpdir/skills/morning-digest/SKILL.md"

if CLAUDE_ROUTINES_SKIP_CONTRACT_TESTS=1 "$tmpdir/scripts/check.sh" >/dev/null 2>&1; then
  echo "expected invalid routine schedule to fail validation" >&2
  exit 1
fi

echo "check contract tests ok"
