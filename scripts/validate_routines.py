#!/usr/bin/env python3
"""Validate Claude routine skill contracts."""

from __future__ import annotations

import argparse
import re
import sys
import tempfile
from pathlib import Path


REQUIRED_FRONTMATTER = ("name", "description", "schedule")
REQUIRED_SECTIONS = ("Steps", "Output format")
DESTINATION_RE = re.compile(r"(^|\s)(Post via|Append to) ")
SCHEDULE_RE = re.compile(r'^"([^"]+)"$|^([^"\s]+(?:\s+[^"\s]+){4})$')


def error(message: str) -> str:
    return f"routine validation failed: {message}"


def parse_frontmatter(path: Path, text: str) -> tuple[dict[str, str], str]:
    lines = text.splitlines()
    if not lines or lines[0] != "---":
        raise ValueError(error(f"{path}: missing opening frontmatter fence"))

    try:
        end = lines[1:].index("---") + 1
    except ValueError as exc:
        raise ValueError(error(f"{path}: missing closing frontmatter fence")) from exc

    frontmatter: dict[str, str] = {}
    for line_number, line in enumerate(lines[1:end], start=2):
        if not line.strip():
            continue
        if ":" not in line:
            raise ValueError(error(f"{path}:{line_number}: invalid frontmatter line"))
        key, value = line.split(":", 1)
        key = key.strip()
        value = value.strip()
        if not key or not value:
            raise ValueError(error(f"{path}:{line_number}: empty frontmatter key or value"))
        frontmatter[key] = value

    return frontmatter, "\n".join(lines[end + 1 :])


def validate_schedule(path: Path, value: str) -> None:
    match = SCHEDULE_RE.match(value)
    schedule = next((group for group in match.groups() if group), "") if match else ""
    if len(schedule.split()) != 5:
        raise ValueError(error(f"{path}: schedule must be a five-field cron expression"))


def validate_skill(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    frontmatter, body = parse_frontmatter(path, text)

    for key in REQUIRED_FRONTMATTER:
        if key not in frontmatter:
            raise ValueError(error(f"{path}: missing frontmatter field: {key}"))

    validate_schedule(path, frontmatter["schedule"])

    if not re.search(r"^# .+", body, flags=re.MULTILINE):
        raise ValueError(error(f"{path}: missing top-level heading"))

    for section in REQUIRED_SECTIONS:
        if not re.search(rf"^## {re.escape(section)}$", body, flags=re.MULTILINE):
            raise ValueError(error(f"{path}: missing section: {section}"))

    if not DESTINATION_RE.search(body):
        raise ValueError(error(f"{path}: missing hosted output destination"))

    output_section = body.split("## Output format", 1)[1]
    if output_section.count("```") < 2:
        raise ValueError(error(f"{path}: Output format must include a fenced example"))


def validate_directory(skills_dir: Path) -> None:
    skill_paths = sorted(skills_dir.glob("*/SKILL.md"))
    if not skill_paths:
        raise ValueError(error(f"{skills_dir}: no routine skills found"))

    for path in skill_paths:
        validate_skill(path)


def run_self_test() -> None:
    invalid_skill = """---
name: invalid-routine
description: Invalid routine fixture
schedule: "0 8 * * *"
---

# Invalid Routine

## Steps

1. Do work without a hosted output destination.

## Output format

```
# Missing destination
```
"""

    with tempfile.TemporaryDirectory() as tmpdir:
        skill_dir = Path(tmpdir) / "invalid-routine"
        skill_dir.mkdir()
        (skill_dir / "SKILL.md").write_text(invalid_skill, encoding="utf-8")
        try:
            validate_directory(Path(tmpdir))
        except ValueError:
            return
    raise ValueError(error("negative fixture unexpectedly passed"))


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("skills_dir", nargs="?", default="skills")
    parser.add_argument(
        "--self-test",
        action="store_true",
        help="also prove the validator rejects a known-bad routine",
    )
    args = parser.parse_args()

    try:
        validate_directory(Path(args.skills_dir))
        if args.self_test:
            run_self_test()
    except ValueError as exc:
        print(exc, file=sys.stderr)
        return 1

    print("routine contracts ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
