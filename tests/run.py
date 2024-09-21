#!/usr/bin/env python3

import argparse
import json
import multiprocessing
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
    parser.add_argument(
        "--nixos-hardware",
        help="Print evaluation commands executed",
    )
    return parser.parse_args()


def run_eval_test(nixos_hardware: str, gcroot_dir: Path, jobs: int) -> list[str]:
    failed_profiles = []
    cmd = [
        "nix-eval-jobs",
        "--extra-experimental-features",
        "flakes",
        "--override-input",
        "nixos-hardware",
        nixos_hardware,
        "--gc-roots-dir",
        str(gcroot_dir),
        "--max-memory-size",
        "2048",
        "--workers",
        str(jobs),
        "--flake",
        str(TEST_ROOT) + "#checks",
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
                print(f"{RED}FAIL {attr}:{RESET}", file=sys.stderr)
                print(f"{RED}{data['error']}{RESET}", file=sys.stderr)
            else:
                print(f"{GREEN}OK {attr}{RESET}")
    return failed_profiles


def main() -> None:
    args = parse_args()

    failed_profiles = []

    with TemporaryDirectory() as tmpdir:
        gcroot_dir = Path(tmpdir) / "gcroot"
        failed_profiles = run_eval_test(args.nixos_hardware, gcroot_dir, args.jobs)

    if len(failed_profiles) > 0:
        print(f"\n{RED}The following {len(failed_profiles)} test(s) failed:{RESET}")
        for profile in failed_profiles:
            print(f" '{profile}'")
        sys.exit(1)


if __name__ == "__main__":
    main()
