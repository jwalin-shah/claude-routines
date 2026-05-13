#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

required_files=(
  "CLAUDE.md"
  "skills/morning-digest/SKILL.md"
  "skills/weekly-recap/SKILL.md"
)

for path in "${required_files[@]}"; do
  if [[ ! -f "$path" ]]; then
    echo "missing required file: $path" >&2
    exit 1
  fi
done

grep -q "^# " skills/morning-digest/SKILL.md
grep -q "^# " skills/weekly-recap/SKILL.md

echo "claude routines check ok"
