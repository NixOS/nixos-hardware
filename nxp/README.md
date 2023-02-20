# NXP i.MX8 SOC family support

## 1. Supported devices
 - [i.MX8QuadMax Multisensory Enablement Kit](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/i-mx-8quadmax-multisensory-enablement-kit-mek:MCIMX8QM-CPU) (**imx8qm-mek**) - device-specific U-boot and Linux kernel, nixos configuration example.
 - [i.MX8QuadXPlus Multisensory Enablement Kit](https://www.nxp.com/design/development-boards/i-mx-evaluation-and-development-boards/i-mx-8quadxplus-multisensory-enablement-kit-mek:MCIMX8QXP-CPU) (**imx8qxp-mek**) - device-specific U-Boot and Linux kernel.

## 2. How to use
Currently this NXP overlay is used for generating EFI-bootable NixOS images. [Tow-Boot](https://tow-boot.org/) is used as a bootloader in our case, but U-Boot can also be used.

Code snippet example that enables imx8qm configuration:
```
{ nixos-hardware, }: {
  system = "aarch64-linux";
  modules = [
    nixos-hardware.nixosModules.imx8qm-mek
  ];
}
```
