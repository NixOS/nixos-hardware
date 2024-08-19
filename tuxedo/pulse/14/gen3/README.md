# TUXEDO Pulse 14 - Gen3

## About

[NixOS hardware configuration](https://github.com/NixOS/nixos-hardware) for
[TUXEDO Pulse 14 -
Gen3](https://www.tuxedocomputers.com/en/TUXEDO-Pulse-14-Gen3).

## Troubleshooting

### Shutdown and Power Issues

With the Linux Kernel version `6.6.33` (NixOS 24.05) there are shutdown issues resulting in the battery not turning off
completely. Apparently a newer Kernel (tested with `6.6.35`) fixes this (the exact version where this problem is fixed is unknown).
This `default.nix` will upgrade to the `pkgs.linuxPackages_latest` if the kernel is older than `6.6.35`.
