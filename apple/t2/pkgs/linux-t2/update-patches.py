#!/usr/bin/env nix-shell
#!nix-shell -i python -p nix -p "python3.withPackages (p: [p.requests])"

import argparse
import json
import re
import subprocess
import sys
from tempfile import NamedTemporaryFile

import requests

API_BASE = "https://api.github.com"
PATCH_PATTERN = re.compile(r"^\d{4}-.*\.patch$")

parser = argparse.ArgumentParser(
    description="Update linux-t2 patches from a GitHub repository."
)
parser.add_argument("filename", help="the output filename")
parser.add_argument(
    "--repository",
    help="the source github repository",
    default="t2linux/linux-t2-patches",
    nargs="?",
)
ref_group = parser.add_mutually_exclusive_group()
ref_group.add_argument(
    "--reference", help="the git reference for the patches", default=None, nargs="?"
)
ref_group.add_argument(
    "--branch", help="the git branch to fetch", default=None, nargs="?"
)


def get_api(endpoint, *args, **kwargs):
    kwargs["headers"] = {"X-GitHub-Api-Version": "2022-11-28"}
    response = requests.get(API_BASE + endpoint, *args, **kwargs)
    response.raise_for_status()
    return response.json()


def get_sri_hash(data: bytes):
    with NamedTemporaryFile() as tmpfile:
        tmpfile.write(data)
        tmpfile.flush()
        proc = subprocess.run(
            ["nix-hash", "--sri", "--flat", "--type", "sha256", tmpfile.name],
            check=True,
            capture_output=True,
        )
        return proc.stdout.decode("utf8").strip()


def main():
    args = parser.parse_args()
    reference = args.reference
    branch = args.branch

    if reference is None:
        if branch is None:
            print("Branch and reference not provided, fetching default branch")
            branch = get_api(f"/repos/{args.repository}")["default_branch"]

        print(f"Reference not provided, fetching from branch {branch}")
        branch_data = get_api(f"/repos/{args.repository}/branches/{branch}")
        reference = branch_data["commit"]["sha"]

    print(f"Repository: {args.repository}")
    print(f" Reference: {reference}")

    base_url = f"https://raw.githubusercontent.com/{args.repository}/{reference}/"
    contents = get_api(f"/repos/{args.repository}/contents", {"ref": reference})
    patches = filter(lambda e: PATCH_PATTERN.match(e.get("name")), contents)

    patches_with_hash = []
    for patch in patches:
        patch_content = requests.get(patch["download_url"])
        patch_hash = get_sri_hash(patch_content.content)
        print(f"{patch['name']}: {patch_hash}")
        patches_with_hash.append({"name": patch["name"], "hash": patch_hash})

    result = {"base_url": base_url, "patches": patches_with_hash}

    with open(args.filename, "w+") as f:
        json.dump(result, f, indent=2)
        f.write("\n")  # write final newline
        print(f"Wrote to {args.filename}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
