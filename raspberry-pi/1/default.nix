{ lib, pkgs, ... }:

{
  # Preserve the legacy ARMv6 boot configuration rather than opting into the
  # graphics and camera defaults used by the newer Raspberry Pi profiles.
  imports = [
    ../common/config-txt.nix
    ../common/firmware.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "armv6l-linux";

  boot = {
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault (
      pkgs.linuxPackagesFor (pkgs.callPackage ../common/kernel.nix { rpiVersion = 1; })
    );
    # The vendor defconfig does not provide the generic PCI storage drivers.
    initrd = {
      includeDefaultModules = lib.mkDefault false;
      systemd.tpm2.enable = lib.mkDefault false;
      availableKernelModules = {
        mmc_block = true;
        usb_storage = true;
        usbhid = true;
        # EFI variable access is not needed for the U-Boot boot path.
        efivarfs = lib.mkForce false;
      };
    };
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.raspberry-pi = {
    configtxt.settings.all = {
      enable_uart = lib.mkDefault true;
      avoid_warnings = lib.mkDefault 1;
    };
    firmware.uboot = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.ubootRaspberryPi;
    };
  };
}
