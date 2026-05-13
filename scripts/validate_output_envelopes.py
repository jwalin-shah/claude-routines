#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

SKILLS = {
    "morning-digest": {
        "path": ROOT / "skills" / "morning-digest" / "SKILL.md",
        "envelope": "morning-digest.v1",
        "required": [
            "generated_at",
            "window",
            "sections",
            "items",
            "delivery",
            "source_ref",
            "priority_reason",
        ],
        "sections": ["must_act", "fyi", "noise"],
        "limits": ["Maximum 15 items total", "one sentence"],
    },
    "weekly-recap": {
        "path": ROOT / "skills" / "weekly-recap" / "SKILL.md",
        "envelope": "weekly-recap.v1",
        "required": [
            "generated_at",
            "week",
            "sections",
            "items",
            "destination",
            "source_refs",
            "status",
        ],
        "sections": ["shipped", "stalled", "surprises", "next_week"],
        "limits": ["Maximum 20 items total", "one page"],
    },
}


def require(errors: list[str], condition: bool, message: str) -> None:
    if not condition:
        errors.append(message)


def validate_skill(name: str, spec: dict[str, object]) -> list[str]:
    path = spec["path"]
    assert isinstance(path, Path)
    text = path.read_text(encoding="utf-8")
    errors: list[str] = []

    require(errors, "## Output Envelope" in text, f"{name}: missing Output Envelope section")
    require(errors, f"Envelope name: `{spec['envelope']}`" in text, f"{name}: missing envelope name")
    require(errors, "Required fields:" in text, f"{name}: missing required fields")
    require(errors, "Optional fields:" in text, f"{name}: missing optional fields")
    require(errors, "Limits:" in text, f"{name}: missing limits")
    require(errors, "Consumer contract:" in text, f"{name}: missing consumer contract")
    require(errors, "## Markdown Rendering" in text, f"{name}: missing rendering section")

    for token in spec["required"]:
        require(errors, f"`{token}`" in text, f"{name}: missing required token `{token}`")
    for section in spec["sections"]:
        require(errors, f"`{section}`" in text, f"{name}: missing section id `{section}`")
    for limit in spec["limits"]:
        require(errors, limit in text, f"{name}: missing limit {limit!r}")

    source_ref_count = len(re.findall(r"`source_refs?`", text))
    require(errors, source_ref_count >= 1, f"{name}: missing source reference contract")
    return errors


def main() -> int:
    errors: list[str] = []
    for name, spec in SKILLS.items():
        errors.extend(validate_skill(name, spec))

    if errors:
        print("output envelope validation failed")
        for error in errors:
            print(f"- {error}")
        return 1

    print("output envelope validation passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
