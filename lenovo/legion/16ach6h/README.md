## Introduction
Due to the introduction of DDG feature, you may toggle DDG frequently, so for the default settings of this laptop, we use "specialization" feature of Nix so that you can easily select the required graphics card driver in the startup menu.  
**But It will slow down NixOS evaluation by factor 2 and increase memory usage.**  
So if you don't need specialization feature, you can just use hybrid only configuration or nvidia only (DDG only) configuration

## Using multiple drives with this configuration

When using more than one drive, the value of `hardware.nvidia.prime.amdgpuBusId` will change from the default of `PCI:5:0:0`.

Make sure you override this default in your personal configuration. For two drives, it should be `PCI:6:0:0`.

## Using and troubleshooting power profiles (hybrid-only)

Power profile support (cycled via Fn + Q) is provided by `nvidia-powerd`.
Should you encounter issues with the `nvidia-powerd` daemon, 
override the value of `hardware.nvidia.dynamicBoost.enable` to `false` in your personal configuration (and consider creating an issue if one does not exist).

## Setup at the time of testing
```
$ nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 6.0.9, NixOS, 22.11 (Raccoon), 22.11beta19.c9538a9b707`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.11.0`
 - channels(root): `"nixos-22.11"`
 - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixos`
 ```
 ```
 $ lspci
...
01:00.0 VGA compatible controller: NVIDIA Corporation GA104M [GeForce RTX 3070 Mobile / Max-Q] (rev a1)
...
06:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne (rev c5)
...
```