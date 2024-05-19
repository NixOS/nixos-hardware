#!/usr/bin/env nix-shell
#!nix-shell --quiet -p nix-eval-jobs -p nix -p python3 -i python

import argparse
import json
import multiprocessing
import re
import subprocess
import sys
import textwrap
from pathlib import Path
from tempfile import TemporaryDirectory
from typing import IO

TEST_ROOT = Path(__file__).resolve().parent
ROOT = TEST_ROOT.parent

GREEN = "\033[92m"
RED = "\033[91m"
RESET = "\033[0m"

re_nixos_hardware = re.compile(r"<nixos-hardware/([^>]+)>")


def parse_readme() -> list[str]:
    profiles = set()
    with ROOT.joinpath("README.md").open() as f:
        for line in f:
            if (m := re_nixos_hardware.search(line)) is not None:
                profiles.add(m.group(1).strip())
    return list(profiles)


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
    parser.add_argument("profiles", nargs="*")
    return parser.parse_args()


def write_eval_test(f: IO[str], profiles: list[str]) -> None:
    build_profile = TEST_ROOT.joinpath("build-profile.nix")
    f.write(
        textwrap.dedent(
            f"""
            let
              purePkgs = system: import <nixpkgs> {{
                config = {{
                  allowBroken = true;
                  allowUnfree = true;
                  nvidia.acceptLicense = true;
                }};
                overlays = [];
                inherit system;
              }};
              pkgs.x86_64-linux = purePkgs "x86_64-linux";
              pkgs.aarch64-linux = purePkgs "aarch64-linux";
              buildProfile = import {build_profile};
            in
            """
        )
    )
    f.write("{\n")
    for profile in profiles:
        # does import-from-derivation
        if profile == "toshiba/swanky":
            continue
        # uses custom nixpkgs config
        if profile == "raspberry-pi/2":
            continue

        system = "x86_64-linux"
        if "raspberry-pi/4" == profile or "raspberry-pi/5" == profile:
            system = "aarch64-linux"

        f.write(
            f'  "{profile}" = buildProfile {{ profile = import {ROOT}/{profile}; pkgs = pkgs.{system}; }};\n'
        )
    f.write("}\n")


def run_eval_test(eval_test: Path, gcroot_dir: Path, jobs: int) -> list[str]:
    failed_profiles = []
    cmd = [
        "nix-eval-jobs",
        "--gc-roots-dir",
        gcroot_dir,
        "--max-memory-size",
        "2048",
        "--workers",
        str(jobs),
        str(eval_test),
    ]
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
    profiles = parse_readme() if len(args.profiles) == 0 else args.profiles

    failed_profiles = []
    with TemporaryDirectory() as tmpdir:
        eval_test = Path(tmpdir) / "eval-test.nix"
        gcroot_dir = Path(tmpdir) / "gcroot"
        with eval_test.open("w") as f:
            write_eval_test(f, profiles)
        failed_profiles = run_eval_test(eval_test, gcroot_dir, args.jobs)

    if len(failed_profiles) > 0:
        print(f"\n{RED}The following {len(failed_profiles)} test(s) failed:{RESET}")
        for profile in failed_profiles:
            print(f"{sys.argv[0]} '{profile}'")
        sys.exit(1)


if __name__ == "__main__":
    main()
