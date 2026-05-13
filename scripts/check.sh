#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

required_files=(
  "AGENTS.md"
  "CLAUDE.md"
  "README.md"
  "skills/morning-digest/SKILL.md"
  "skills/weekly-recap/SKILL.md"
)

for path in "${required_files[@]}"; do
  if [[ ! -f "$path" ]]; then
    echo "missing required file: $path" >&2
    exit 1
  fi
done

for skill in skills/*/SKILL.md; do
  grep -q "^---$" "$skill"
  grep -q "^name: " "$skill"
  grep -q "^description: " "$skill"
  grep -q "^schedule: " "$skill"
  grep -q "^# " "$skill"
  grep -q "^## Output format$" "$skill"
  grep -Eq "(^|[[:space:]])(Post via|Append to) " "$skill"
done

echo "claude routines check ok"
