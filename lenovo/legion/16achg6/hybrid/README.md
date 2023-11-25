## Setup at the time of testing
```
$ nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 6.1.62, NixOS, 23.05 (Stoat), 23.05.20231116.9fb1225`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.13.6`
 - channels(beko): `"home-manager-23.05.tar.gz"`
 - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixos`
 ```
 ```
 $ lspci
...
01:00.0 VGA compatible controller: NVIDIA Corporation GA104M [GeForce RTX 3070 Mobile / Max-Q] (rev a1)
...
05:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] (rev c5)
...
```