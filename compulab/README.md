# UCM-iMX95 SOM support

## Supported devices
- [UCM-iMX95 System-on-Module](https://www.compulab.com/products/som-evaluation-kits/ucm-imx95-evaluation-kit/) (**ucm-imx95**) – based on the NXP i.MX95 SoC (A0 silicon), with device-specific boot components(OEI, SM, ATF), U-Boot, and Linux kernel support, including a NixOS configuration example.

## How to use
This overlay provides configuration and hardware support for the **CompuLab UCM-iMX95** platform, based on the **NXP i.MX95 A0 silicon**. It enables generating NixOS images suitable for booting via U-Boot, using the CompuLab UCM-iMX95 Evaluation Kit carrier board.

### Boot flow
The boot flow for the UCM-iMX95 platform follows the standard NXP i.MX95 sequence:

Boot ROM → OEI (initially in TCM, then DDR) → System Manager (SM) → ARM Trusted Firmware (ATF) → U-Boot → Linux kernel → NixOS userspace

Boot ROM initializes the SoC and loads OEI, which runs in TCM to perform early setup, then configures DDR and loads the System Manager (SM). SM completes SoC initialization and passes control to ATF, which handles secure world setup and then transfers execution to U-Boot, eventually booting the Linux kernel and NixOS root filesystem.

### Example NixOS configuration
```nix
{ nixos-hardware, }: {
  system = "aarch64-linux";
  modules = [
    nixos-hardware.nixosModules.ucm-imx95
  ];
}
```

### Notes
- The configuration, including device-tree, kernel, and bootloader components, is optimized for the UCM-iMX95 SoM and EVK.  
- The generated NixOS image supports booting from SD card or eMMC, depending on the hardware configuration.  
- The boot components (OEI in TCM/DDR, SM, ATF, U-Boot) follow the standard NXP release layout for i.MX95 platforms.
