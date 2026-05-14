#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

required_files=(
  "AGENTS.md"
  "CLAUDE.md"
  "README.md"
  "skills/morning-digest/SKILL.md"
  "skills/weekly-recap/SKILL.md"
  "tests/check-contract.sh"
)

for path in "${required_files[@]}"; do
  if [[ ! -f "$path" ]]; then
    echo "missing required file: $path" >&2
    exit 1
  fi
done

validate_schedule() {
  local skill="$1"
  local schedule
  schedule="$(sed -n 's/^schedule:[[:space:]]*//p' "$skill" | head -n 1)"

  if [[ "$schedule" == \"*\" || "$schedule" == \'*\' ]]; then
    schedule="${schedule:1:${#schedule}-2}"
  fi

  read -r -a fields <<< "$schedule"
  if [[ "${#fields[@]}" -ne 5 ]]; then
    echo "$skill: schedule must be a five-field cron expression" >&2
    exit 1
  fi
}

for skill in skills/*/SKILL.md; do
  grep -q "^---$" "$skill"
  grep -q "^name: " "$skill"
  grep -q "^description: " "$skill"
  grep -q "^schedule: " "$skill"
  validate_schedule "$skill"
  grep -q "^# " "$skill"
  grep -q "^## Output format$" "$skill"
  grep -Eq "(^|[[:space:]])(Post via|Append to) " "$skill"
done

if [[ "${CLAUDE_ROUTINES_SKIP_CONTRACT_TESTS:-}" != "1" && -x tests/check-contract.sh ]]; then
  tests/check-contract.sh
fi

echo "claude routines check ok"
