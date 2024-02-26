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

### 2.2 For imx8mq-evk/imx8mp-evk
This NXP overlay is used for generating sdimage.
Current configuration uses uboot as a bootloader. It provides an options to use optee-os which is currently disabled. It can be enabled using `enable-tee` boolean argument avalable in `imx8m<q/p>-boot.nix`, which is `false` by default.  

Code snippet example that enables 'imx8mp-evk/emx8mq-evk' configuration:

```
{ nixos-hardware, }: {
  system = "aarch64-linux";
  modules = [
    nixos-hardware.nixosModules.imx8mp-evk  #For imx8mp-evk
    #nixos-hardware.nixosModules.imx8mq-evk  #For imx8mq-evk
  ];
}
```

