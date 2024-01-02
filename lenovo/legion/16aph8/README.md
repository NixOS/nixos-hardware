I was unable to get the hybrid settings working well with lightdm or sddm, but Optimus Sync
mode seems to work the best for me.

I am running the Linux 6.6 LTS kernel with KDE + SDDM, and it seems to be working well.

## hardware-configuration.nix

I have the following customizations added for my nvidia drivers.

```
hardware.nvidia = {
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
};
```

## Setup at the time of testing

### nix-info
```
$ nix-info -m
 - system: `"x86_64-linux"`
 - host os: `Linux 6.6.8, NixOS, 23.11 (Tapir), 23.11.20231231.32f6357`
 - multi-user?: `yes`
 - sandbox: `yes`
 - version: `nix-env (Nix) 2.18.1`
 - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixos`
```

### lspci
```
$ lspci
...
01:00.0 VGA compatible controller: NVIDIA Corporation AD107M [GeForce RTX 4060 Max-Q / Mobile] (rev a1)
...
05:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Phoenix1 (rev c2)
...
```
