#!/bin/sh
set -u
here=$(cd "$(dirname "$0")" && pwd)

if [ -z "$1" ]; then
  echo "Usage: $0 <profile>"
  exit 1
fi

profile=$1
logfile=$(mktemp)

# shellcheck disable=SC2039
echo -n "evaluating $profile: "

nix-build \
  '<nixpkgs/nixos>' \
  -I "nixos-config=$here/eval-test.nix" \
  -I "nixos-hardware-profile=$profile" \
  --dry-run \
  --no-out-link \
  --show-trace \
  -A system > "$logfile" 2>&1
ret=$?

if [ "$ret" -gt 0 ]; then
  echo ERROR
  echo ===================================================================== >&2
  cat "$logfile" >&2
else
  echo OK
fi

rm "$logfile"
exit "$ret"
