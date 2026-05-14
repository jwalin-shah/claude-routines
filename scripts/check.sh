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
  local field_index
  local bounds
  schedule="$(sed -n 's/^schedule:[[:space:]]*//p' "$skill" | head -n 1)"

  if [[ "$schedule" == \"*\" || "$schedule" == \'*\' ]]; then
    schedule="${schedule:1:${#schedule}-2}"
  fi

  read -r -a fields <<< "$schedule"
  if [[ "${#fields[@]}" -ne 5 ]]; then
    echo "$skill: schedule must be a five-field cron expression" >&2
    exit 1
  fi

  bounds=("0 59" "0 23" "1 31" "1 12" "0 7")
  for field_index in "${!fields[@]}"; do
    validate_cron_field "$skill" "$field_index" "${fields[$field_index]}" "${bounds[$field_index]}"
  done
}

validate_cron_number() {
  local skill="$1"
  local field_index="$2"
  local value="$3"
  local min="$4"
  local max="$5"
  local number

  if [[ ! "$value" =~ ^[0-9]+$ ]]; then
    echo "$skill: schedule field $((field_index + 1)) contains invalid cron token: $value" >&2
    exit 1
  fi

  number=$((10#$value))
  if (( number < min || number > max )); then
    echo "$skill: schedule field $((field_index + 1)) value out of range: $value" >&2
    exit 1
  fi
}

validate_cron_field() {
  local skill="$1"
  local field_index="$2"
  local field="$3"
  local bound="$4"
  local min="${bound% *}"
  local max="${bound#* }"
  local token
  local base
  local step
  local start
  local end
  local tokens

  if [[ "$field" == ","* || "$field" == *"," || "$field" == *",,"* ]]; then
    echo "$skill: schedule field $((field_index + 1)) contains an empty cron token" >&2
    exit 1
  fi

  IFS=',' read -r -a tokens <<< "$field"
  for token in "${tokens[@]}"; do
    if [[ -z "$token" ]]; then
      echo "$skill: schedule field $((field_index + 1)) contains an empty cron token" >&2
      exit 1
    fi

    base="$token"
    step=""
    if [[ "$token" == */* ]]; then
      base="${token%%/*}"
      step="${token#*/}"
      validate_cron_number "$skill" "$field_index" "$step" 1 999
    fi

    if [[ "$base" == "*" ]]; then
      continue
    fi

    if [[ "$base" == *-* ]]; then
      start="${base%-*}"
      end="${base#*-}"
      validate_cron_number "$skill" "$field_index" "$start" "$min" "$max"
      validate_cron_number "$skill" "$field_index" "$end" "$min" "$max"
      if (( 10#$start > 10#$end )); then
        echo "$skill: schedule field $((field_index + 1)) has a descending cron range: $base" >&2
        exit 1
      fi
      continue
    fi

    validate_cron_number "$skill" "$field_index" "$base" "$min" "$max"
  done
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
