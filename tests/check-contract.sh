#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/scripts"
cp scripts/check.sh "$tmpdir/scripts/"

while IFS= read -r path; do
  mkdir -p "$tmpdir/$(dirname "$path")"
  cp "$path" "$tmpdir/$path"
done < <(scripts/check.sh --print-required-files)

git -C "$tmpdir" init -q

"$tmpdir/scripts/check.sh" --smoke >/dev/null
"$tmpdir/scripts/check.sh" --skip-contract-tests >/dev/null

runtime_dir="$("$tmpdir/scripts/check.sh" --print-runtime-dir)"

if [[ "$runtime_dir" != ".codex-runtime" ]]; then
  echo "expected default runtime output dir to be .codex-runtime" >&2
  exit 1
fi

if ! git -C "$tmpdir" check-ignore -q -- "$runtime_dir/"; then
  echo "expected default runtime output dir to be git-ignored" >&2
  exit 1
fi

invalid_output="$tmpdir/invalid-option.out"

if "$tmpdir/scripts/check.sh" --unknown >"$invalid_output" 2>&1; then
  echo "expected unknown check option to fail validation" >&2
  exit 1
fi

if ! grep -q "^usage: " "$invalid_output"; then
  echo "expected unknown check option to print usage" >&2
  exit 1
fi

perl -0pi -e 's/schedule: "0 8 \* \* \*"/schedule: "daily"/' \
  "$tmpdir/skills/morning-digest/SKILL.md"

if "$tmpdir/scripts/check.sh" --skip-contract-tests >/dev/null 2>&1; then
  echo "expected invalid routine schedule to fail validation" >&2
  exit 1
fi

echo "check contract tests ok"
