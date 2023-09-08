# NixOS on T2 Macs

This is the `nixos-hardware` module of the [T2 Linux Project](https://t2linux.org).

Overall, most features (WiFi, bluetooth, audio, touchbar, ...) of Macs are supported, [see this page](https://wiki.t2linux.org/state/) for a detailed list of things that work and things that don't/partially work.

Following [this guide](https://wiki.t2linux.org/distributions/nixos/installation/) is the recommended way to install, as it incudes the extra things you have to do on a T2 Mac.

You can consult the [wiki](https://wiki.t2linux.org/) for information specific to T2 Macs.

## Unlocking Internal iGPU

The `apple-set-os-loader-installer` module serves as an installer for the [`apple-set-os-loader`](https://github.com/Redecorating/apple_set_os-loader). This tool is designed to unlock the internal integrated GPU (iGPU) on certain MacBooks. See https://wiki.t2linux.org/guides/hybrid-graphics/ for more details.

### What it Does:

Upon activation, this module performs the following:

- Renames the existing `BOOTX64.EFI` file to `bootx64_original.efi`.
- Installs the `apple-set-os-loader` hook in its place as `bootx64.efi`.
- Before the system boots the hook unlocks the iGPU and subsequently calls the original `bootx64_original.efi`.
- Enables the iGPU by default.

### How to Implement:

1. Add this into your `configuration.nix`:
```
appleT2Config.enableAppleSetOsLoader = true;
```

2. **Rebuild your system**:
```
sudo nixos-rebuild switch
```

> **Note**: Always ensure compatibility and make backups of your data before making any system changes.
