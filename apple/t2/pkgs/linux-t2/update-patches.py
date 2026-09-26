#!/usr/bin/env nix-shell
#!nix-shell -i python -p nix -p "python3.withPackages (p: [p.requests])"

import argparse
import json
import re
import subprocess
import sys
from tempfile import NamedTemporaryFile
from concurrent.futures import ThreadPoolExecutor, as_completed

import requests

API_BASE = "https://api.github.com"
PATCH_PATTERN = re.compile(r"^\d{4}-.*\.patch$")

parser = argparse.ArgumentParser(
    description="Update linux-t2 patches from a GitHub repository.",
    epilog='''
    If both --branch and --reference flags are given, the argument of --reference will be used to fetch the Git
    revision for patches and --branch as the kernel branch.

    If only --branch is given, the argument will be used for both resolving the Git ref and the kernel branch.
    ''',
)
parser.add_argument("filename", help="the output filename")
parser.add_argument(
    "--repository",
    help="the source github repository (default: %(default)s)",
    default="t2linux/linux-t2-patches",
    nargs="?",
)
parser.add_argument(
    "--reference", help="the git reference for the patches", default=None, nargs="?"
)
parser.add_argument(
    "--branch", help="the kernel branch to fetch (default: latest, example: 6.18)", default=None, nargs="?"
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

def download_task(patch: dict):
    patch_content = requests.get(patch["download_url"])
    patch_hash = get_sri_hash(patch_content.content)
    print(f"{patch['name']}: {patch_hash}")
    return {"name": patch["name"], "hash": patch_hash}

def main():
    args = parser.parse_args()
    reference = args.reference
    branch = args.branch

    print("Fetching kernel releases")
    releases = requests.get("https://kernel.org/releases.json").json()['releases']
    match = None
    patched_url = ""
    if not branch:
        print("Branch not provided, fetching latest non-mainline kernel version")
        # if the json schema changes this script would break, hopefully won't happen
        match = next(filter(lambda x: x["moniker"] != "mainline", releases), None)
    else:
        match = next(filter(lambda x: x["version"].startswith(branch), releases), None)
    if not match:
        print(f"ERROR: could not find a kernel release for branch {branch}.")
        return 1
    patched_url = match['source'].replace('https://cdn.kernel.org/pub', 'mirror://kernel')

    release_hash = subprocess.check_output(["nix-prefetch-url", "--type", "sha256", patched_url]).decode().strip()
    print(f"    Kernel: {match['version']}")
    print(f"       URL: {patched_url}")
    print(f"      Hash: sha256:{release_hash}")
    kernel = {"version": match["version"], "url": patched_url, "hash": f"sha256:{release_hash}"}

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
    with ThreadPoolExecutor() as executor:
        futures = {executor.submit(download_task, patch) for patch in patches}

        for future in as_completed(futures):
            patches_with_hash.append(future.result())

    result = {"base_url": base_url, "kernel": kernel, "patches": sorted(patches_with_hash, key=lambda p: p["name"])}

    with open(args.filename, "w+") as f:
        json.dump(result, f, indent=2)
        f.write("\n")  # write final newline
        print(f"Wrote to {args.filename}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
