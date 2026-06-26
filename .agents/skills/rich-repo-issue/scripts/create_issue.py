#!/usr/bin/env python3
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path


def run(cmd: list[str], cwd: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, cwd=cwd, text=True, capture_output=True, check=False)


def get_origin_url(cwd: Path) -> str:
    result = run(["git", "remote", "get-url", "origin"], cwd)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "failed to read git origin remote")
    return result.stdout.strip()


def detect_forge(origin_url: str) -> str:
    lowered = origin_url.lower()
    if "github.com" in lowered:
        return "github"
    if "gitlab.com" in lowered or "gitlab" in lowered:
        return "gitlab"
    raise RuntimeError(f"unsupported forge for origin remote: {origin_url}")


def ensure_cli(forge: str) -> str:
    cli = "gh" if forge == "github" else "glab"
    if shutil.which(cli):
        return cli
    raise RuntimeError(f"required CLI '{cli}' is not installed or not in PATH")


def build_issue_command(cli: str, forge: str, title: str, body_file: Path, labels: list[str]) -> list[str]:
    if forge == "github":
        cmd = [cli, "issue", "create", "--title", title, "--body-file", str(body_file)]
        for label in labels:
            cmd.extend(["--label", label])
    else:
        cmd = [cli, "issue", "create", "--title", title, "--description", body_file.read_text()]
        for label in labels:
            cmd.extend(["--label", label])
    return cmd


def create_issue(cli: str, forge: str, title: str, body_file: Path, labels: list[str], cwd: Path) -> str:
    cmd = build_issue_command(cli, forge, title, body_file, labels)
    result = run(cmd, cwd)
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or result.stdout.strip() or "issue creation failed")
    return result.stdout.strip()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Create a repository issue with gh or glab.")
    parser.add_argument("--title", required=True, help="Issue title")
    parser.add_argument("--body-file", required=True, type=Path, help="Path to markdown body file")
    parser.add_argument("--label", action="append", default=[], dest="labels", help="Issue label; repeatable")
    parser.add_argument("--cwd", default=".", type=Path, help="Repository path")
    parser.add_argument("--dry-run", action="store_true", help="Print the detected forge and command without creating the issue")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    cwd = args.cwd.resolve()
    body_file = args.body_file.resolve()

    if not body_file.exists():
        print(f"body file not found: {body_file}", file=sys.stderr)
        return 1

    try:
        origin_url = get_origin_url(cwd)
        forge = detect_forge(origin_url)
        cli = ensure_cli(forge)
        if args.dry_run:
            cmd = build_issue_command(cli, forge, args.title, body_file, args.labels)
            print(f"forge={forge}")
            print(f"origin={origin_url}")
            print("command=" + " ".join(cmd))
            return 0
        output = create_issue(cli, forge, args.title, body_file, args.labels, cwd)
    except RuntimeError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    print(output)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
