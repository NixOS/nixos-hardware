#!/usr/bin/env sh

nix eval .#mnt-reform-kernel-patches > kernelPatches.nix
nix fmt kernelPatches.nix
