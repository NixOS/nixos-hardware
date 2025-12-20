# NXP i.MX8 SOC family support

## 1. Supported devices
 - [i.MX8QuadMax Multisensory Enablement Kit](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/i-mx-8quadmax-multisensory-enablement-kit-mek:MCIMX8QM-CPU) (**imx8qm-mek**) - device-specific U-boot and Linux kernel, nixos configuration example.
 - [i.MX8QuadXPlus Multisensory Enablement Kit](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/i-mx-8quadxplus-multisensory-enablement-kit-mek:MCIMX8QXP-CPU) (**imx8qxp-mek**) - device-specific U-Boot and Linux kernel.

## 2. How to use

### 2.1  For imx8qm-mek
Currently this NXP overlay is used for generating EFI-bootable NixOS images.
I recommend to use [Tow-Boot](https://tow-boot.org/) as a bootloader, but U-Boot from this overlay can also be used.
U-Boot was tested separately from NixOS.

Code snippet example that enables imx8qm configuration:
```
{ nixos-hardware, }: {
  system = "aarch64-linux";
  modules = [
    nixos-hardware.nixosModules.imx8qm-mek
  ];
}
```

### 2.2 For imx8mq-evk/imx8mp-evk/imx93-evk
This NXP overlay is used for generating sdimage.
Current configuration uses uboot as a bootloader. It provides an options to use optee-os which is currently disabled. It can be enabled using `enable-tee` boolean argument avalable in `imx8m<q/p>-boot.nix`, which is `false` by default in imx8m platform.

Code snippet example that enables 'imx8mp-evk/imx8mq-evk/imx93-evk' configuration:

```
{ nixos-hardware, }: {
  system = "aarch64-linux";
  modules = [
    nixos-hardware.nixosModules.imx8mp-evk  #For imx8mp-evk
    #nixos-hardware.nixosModules.imx93-evk  #For imx93-evk
    #nixos-hardware.nixosModules.imx8mq-evk  #For imx8mq-evk
  ];
}
```

### 2.3 Building Boot Images

Boot images for flashing to SD cards can be built directly from the flake:

```bash
# Build boot image for i.MX8MP EVK
nix build github:NixOS/nixos-hardware#packages.aarch64-linux.imx8mp-boot

# Build boot image for i.MX8MQ EVK
nix build github:NixOS/nixos-hardware#packages.aarch64-linux.imx8mq-boot

# Build boot image for i.MX93 EVK
nix build github:NixOS/nixos-hardware#packages.aarch64-linux.imx93-boot

# Or from a local checkout
nix build .#packages.aarch64-linux.imx8mp-boot
```

The boot image will be available at `./result/image/flash.bin`.

**Note:** These packages target `aarch64-linux`. If you're on a different architecture (e.g., x86_64-linux), you'll need remote builders configured for aarch64-linux.

### 2.4 Flashing to SD Card

Once built, you can flash the boot image to an SD card:

```bash
# For i.MX8MP and i.MX93 (32KB offset):
sudo dd if=./result/image/flash.bin of=/dev/sdX bs=1k seek=32 conv=fsync

# For i.MX8MQ (33KB offset):
sudo dd if=./result/image/flash.bin of=/dev/sdX bs=1k seek=33 conv=fsync
```

**Note:** Different i.MX processors require different offsets. i.MX8MP and i.MX93 use 32KB (seek=32), while i.MX8MQ uses 33KB (seek=33).

**Warning:** Double-check the device path to avoid overwriting the wrong disk!

## 3. Upstream Documentation

### U-Boot Board Documentation
- [NXP i.MX8MP EVK U-Boot Documentation](https://docs.u-boot.org/en/latest/board/nxp/imx8mp_evk.html)
- [NXP i.MX8MQ EVK U-Boot Documentation](https://docs.u-boot.org/en/latest/board/nxp/imx8mq_evk.html)
- [NXP i.MX93 11x11 EVK U-Boot Documentation](https://docs.u-boot.org/en/latest/board/nxp/imx93_11x11_evk.html)
- [NXP i.MX95 EVK U-Boot Documentation](https://docs.u-boot.org/en/latest/board/nxp/imx95_evk.html)

### Additional Resources
- [NXP i.MX 8M Series TF-A Documentation](https://trustedfirmware-a.readthedocs.io/en/latest/plat/imx8m.html)

