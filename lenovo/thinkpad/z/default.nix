{ lib, pkgs, ... }: {
  imports = [
    ../../../lenovo/thinkpad
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd
    ../../../common/hidpi.nix # can be dropped after nixos 23.05
  ];
  # kernel versions prior to 5.18 won't boot
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.18") (lib.mkDefault pkgs.linuxPackages_latest);

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.trackpoint.device = lib.mkDefault "TPPS/2 Elan TrackPoint";

  services.fprintd.enable = lib.mkDefault true;

  # kernel versions below 6.0 don't contain ACPI suspend2idle drivers for the Z13s AMD hardware
  # my Z13 froze after waking up from suspend/ hibernate
  services.logind.lidSwitch = lib.mkIf (lib.versionOlder pkgs.linux.version "6.00") (lib.mkDefault "lock");
}
