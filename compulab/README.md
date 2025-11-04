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

### Building Boot Images

The boot image for flashing to SD cards can be built directly from the flake:

```bash
# Build boot image for UCM-iMX95
nix build github:NixOS/nixos-hardware#packages.aarch64-linux.ucm-imx95-boot
```

The boot image will be available at `./result/image/flash.bin`.

**Note:** These packages target `aarch64-linux`. If you're on a different architecture (e.g., x86_64-linux), you'll need remote builders configured for aarch64-linux.

### Flashing to SD Card

Once built, you can flash the boot image to an SD card:

```bash
# Write boot image to SD card at 32KB offset (adjust /dev/sdX to your SD card device)
sudo dd if=./result/image/flash.bin of=/dev/sdX bs=1k seek=32 conv=fsync
```

**Warning:** Double-check the device path to avoid overwriting the wrong disk!

### Notes
- The configuration, including device-tree, kernel, and bootloader components, is optimized for the UCM-iMX95 SoM and EVK.
- The generated NixOS image supports booting from SD card or eMMC, depending on the hardware configuration.
- The boot components (OEI in TCM/DDR, SM, ATF, U-Boot) follow the standard NXP release layout for i.MX95 platforms.

### Upstream Documentation
- [NXP i.MX95 EVK U-Boot Documentation](https://docs.u-boot.org/en/latest/board/nxp/imx95_evk.html)
- [CompuLab UCM-iMX95 Product Page](https://www.compulab.com/products/computer-on-modules/ucm-imx95-nxp-i-mx-95-som-system-on-module/)
