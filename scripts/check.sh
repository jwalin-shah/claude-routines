#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

run_contract_tests=1
print_required_files=0
print_runtime_dir=0
smoke_only=0
runtime_output_dir="${CLAUDE_ROUTINES_RUNTIME_DIR:-.codex-runtime}"

case "${1:-}" in
  "")
    ;;
  --smoke)
    smoke_only=1
    run_contract_tests=0
    ;;
  --skip-contract-tests)
    run_contract_tests=0
    ;;
  --print-required-files)
    print_required_files=1
    run_contract_tests=0
    ;;
  --print-runtime-dir)
    print_runtime_dir=1
    run_contract_tests=0
    ;;
  *)
    echo "usage: $0 [--smoke|--skip-contract-tests|--print-required-files|--print-runtime-dir]" >&2
    exit 2
    ;;
esac

required_files=(
  ".gitignore"
  "AGENTS.md"
  "CLAUDE.md"
  "README.md"
  "skills/morning-digest/SKILL.md"
  "skills/weekly-recap/SKILL.md"
  "tests/check-contract.sh"
)

validate_required_files() {
  local path

  for path in "${required_files[@]}"; do
    if [[ ! -f "$path" ]]; then
      echo "missing required file: $path" >&2
      exit 1
    fi
  done
}

print_required_repository_files() {
  local path

  for path in "${required_files[@]}"; do
    printf '%s\n' "$path"
  done
}

print_default_runtime_dir() {
  printf '%s\n' "$runtime_output_dir"
}

validate_runtime_dir_is_ignored() {
  if ! git check-ignore -q -- "$runtime_output_dir/"; then
    echo "runtime output dir must be git-ignored: $runtime_output_dir/" >&2
    exit 1
  fi
}

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

validate_skill_contract() {
  local skill="$1"

  grep -q "^---$" "$skill"
  grep -q "^name: " "$skill"
  grep -q "^description: " "$skill"
  grep -q "^schedule: " "$skill"
  validate_schedule "$skill"
  grep -q "^# " "$skill"
  grep -q "^## Output format$" "$skill"
  grep -Eq "(^|[[:space:]])(Post via|Append to) " "$skill"
}

validate_skills() {
  local skill

  for skill in skills/*/SKILL.md; do
    validate_skill_contract "$skill"
  done
}

if [[ "$print_required_files" -eq 1 ]]; then
  print_required_repository_files
  exit 0
fi

if [[ "$print_runtime_dir" -eq 1 ]]; then
  print_default_runtime_dir
  exit 0
fi

validate_required_files
validate_runtime_dir_is_ignored
validate_skills

if [[ "$smoke_only" -eq 1 ]]; then
  echo "claude routines smoke ok"
  exit 0
fi

if [[ "$run_contract_tests" -eq 1 && -x tests/check-contract.sh ]]; then
  tests/check-contract.sh
fi

echo "claude routines check ok"
