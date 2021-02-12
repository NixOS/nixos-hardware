{ lib, pkgs, ... }:

let
  bridge-drv = pkgs.callPackage ../../kernel-modules/bridge-drv.nix {
    inherit pkgs;
    kernel = pkgs.linuxPackages_latest.kernel;
  };
in

{

  # it is absolutely crucial that these are false
  # otherwise the bootloader disfunctions
  # causing kernel panic and infinite loop
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  # iwd is the only backend known to work
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  # prevent false detection of built-in ethernet
  # causing a 90 sec wait job on startup
  networking.interfaces.enp2s0f1u1.useDHCP = false;

  # if built-in wifi is set up, it should appear as wlan0
  networking.interfaces.wlan0.useDHCP = true;

  # required to get the keyboard working before startup
  boot.initrd.kernelModules = [ "bce" ];

  # prevent system being stuck on boot (not always needed?)
  # https://gist.github.com/TRPB/437f663b545d23cc8a2073253c774be3#gistcomment-3055646
  boot.blacklistedKernelModules = [ "thunderbolt" ];

  # needed to get basic trackpad support
  # adds the "bce" kernel module
  boot.extraModulePackages = [ bridge-drv ];

  # needed to get suspend working
  boot.kernelParams = [
    "pcie_ports=compat"
    "acpi_mask_gpe=0x6e" # forgot why this was needed
  ];

}
