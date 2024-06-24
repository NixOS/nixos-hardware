# TUXEDO Pulse 14 - Gen3

## About

[NixOS hardware configuration](https://github.com/NixOS/nixos-hardware) for
[TUXEDO Pulse 14 -
Gen3](https://www.tuxedocomputers.com/en/TUXEDO-Pulse-14-Gen3).

## Troubleshooting

### Shutdown and Power Issues

With the Linux Kernel version `6.6.33` (NixOS 24.05) there are shutdown issues resulting in the battery not turning off
completely. Apparently a newer Kernel (tested with `6.8.12`) fixes this (the exact version where this problem is fixed is unknown).

You can use

```nix
  boot.kernelPackages =
    if (config.boot.zfs.enabled)
    then pkgs.zfs.latestCompatibleLinuxPackages
    else pkgs.linuxPackages_latest;
```

to use the latest Kernel, where `pkgs` should probably
be the `nixos-unstable` channel (`github:nixos/nixpkgs/nixos-unstable`).
