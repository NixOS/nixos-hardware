#!/usr/bin/env sh

nix eval --file updateKernelPatches.nix > kernelPatches.nix
nix fmt kernelPatches.nix
