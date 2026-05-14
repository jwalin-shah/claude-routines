#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

required_files=(
  "AGENTS.md"
  "CLAUDE.md"
  "README.md"
  "scripts/validate_routines.py"
  "skills/morning-digest/SKILL.md"
  "skills/weekly-recap/SKILL.md"
)

for path in "${required_files[@]}"; do
  if [[ ! -f "$path" ]]; then
    echo "missing required file: $path" >&2
    exit 1
  fi
done

python3 scripts/validate_routines.py --self-test skills
git diff --check HEAD --

echo "claude routines check ok"
