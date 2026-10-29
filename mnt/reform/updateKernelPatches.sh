#!/usr/bin/env sh

nix build .#mnt-reform-kernel-patches
cp result kernelPatches.nix
