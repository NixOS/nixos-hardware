I personally use my laptop with an external display attached and haven't observed any issues so far.

From my experience, it's better to use gdm, as sddm seems to have a problem detecting the external monitor (more details available [here](https://github.com/sddm/sddm/issues/1558)). Of course it's not a blocker, as it is still possible to log in using sddm. I personally find it annoying that my main display remains idle.

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