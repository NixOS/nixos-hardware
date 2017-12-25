#!/bin/sh
set -efu
cd "$(dirname "$0")/.." || exit 1

echo "### Evaluating all profiles ###"
echo

# shellcheck disable=SC2044
for profile in $(find . -name default.nix); do
  ./tests/eval-one.sh "$profile"
done
