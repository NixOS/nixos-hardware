#!/usr/bin/env sh

nix eval .#lib.mnt-reform-patches > kernelPatches.nix
nix fmt kernelPatches.nix
