#!/usr/bin/env python3

import argparse
import json
import multiprocessing
import os
import shlex
import subprocess
import sys
from pathlib import Path
from tempfile import TemporaryDirectory

TEST_ROOT = Path(__file__).resolve().parent
ROOT = TEST_ROOT.parent

GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"

def is_github_actions() -> bool:
    """Check if running in GitHub Actions environment."""
    return os.getenv("GITHUB_ACTIONS") == "true"

def github_error(message: str, title: str = "") -> None:
    """Output GitHub Actions error annotation."""
    if title:
        print(f"::error title={title}::{message}")
    else:
        print(f"::error::{message}")

def github_warning(message: str, title: str = "") -> None:
    """Output GitHub Actions warning annotation."""
    if title:
        print(f"::warning title={title}::{message}")
    else:
        print(f"::warning::{message}")

def format_nix_error(error_text: str) -> str:
    """Format nix evaluation error for better readability."""
    lines = error_text.strip().split('\n')
    # Try to extract the most relevant error line
    for line in lines:
        if 'error:' in line.lower():
            return line.strip()
    # If no specific error line found, return first non-empty line
    for line in lines:
        if line.strip():
            return line.strip()
    return error_text.strip()

def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run hardware tests")
    parser.add_argument(
        "--jobs",
        type=int,
        default=multiprocessing.cpu_count(),
        help="Number of parallel evaluations."
        "If set to 1 it disable multi processing (suitable for debugging)",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print evaluation commands executed",
    )
    return parser.parse_args()


def run_eval_test(gcroot_dir: Path, jobs: int) -> list[str]:
    failed_profiles = []
    cmd = [
        "nix-eval-jobs",
        "--no-instantiate",
        "--extra-experimental-features", "flakes",
        "--option", "eval-cache", "false",
        "--gc-roots-dir",
        str(gcroot_dir),
        "--max-memory-size",
        "2048",
        "--workers",
        str(jobs),
        "--flake",
        str(ROOT) + "#checks",
        "--force-recurse",
    ]
    print(" ".join(map(shlex.quote, cmd)))
    proc = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        text=True,
    )

    with proc as p:
        assert p.stdout is not None
        for line in p.stdout:
            data = json.loads(line)
            attr = data.get("attr")
            if "error" in data:
                failed_profiles.append(attr)
                error_msg = data['error']
                formatted_error = format_nix_error(error_msg)

                # Output for terminal
                print(f"{RED}FAIL {attr}:{RESET}", file=sys.stderr)
                print(f"{RED}{error_msg}{RESET}", file=sys.stderr)

                # Output for GitHub Actions
                if is_github_actions():
                    github_error(
                        formatted_error,
                        title=f"Hardware profile evaluation failed: {attr}"
                    )
            else:
                print(f"{GREEN}OK {attr}{RESET}")
    return failed_profiles


def main() -> None:
    args = parse_args()

    failed_profiles = []

    with TemporaryDirectory() as tmpdir:
        gcroot_dir = Path(tmpdir) / "gcroot"
        failed_profiles = run_eval_test(gcroot_dir, args.jobs)

    if len(failed_profiles) > 0:
        failure_msg = f"The following {len(failed_profiles)} test(s) failed:"
        print(f"\n{RED}{failure_msg}{RESET}")
        for profile in failed_profiles:
            print(f" '{profile}'")

        # GitHub Actions summary
        if is_github_actions():
            github_error(
                f"{failure_msg} {', '.join(failed_profiles)}",
                title="Hardware Profile Tests Failed"
            )

        sys.exit(1)


if __name__ == "__main__":
    main()
