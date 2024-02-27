# Microchip Icicle-kit board support

## 1. Supported devices
 - [Microchip Icicle Kit](https://www.microchip.com/en-us/development-tool/MPFS-ICICLE-KIT-ES) (**mpfs-icicle-kit**) - device-specific U-boot and Linux kernel, nixos configuration example.

## 2. How to use?
Currently this overlay is used for generating bootable NixOS SD images.

Code snippet example that enables icicle-kit configuration:
```
{ nixos-hardware, }: {
  system = "riscv64-linux";
  modules = [
    nixos-hardware.nixosModules.icicle-kit
  ];
}
```
