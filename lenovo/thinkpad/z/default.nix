{ lib, pkgs, ... }: {
  imports = [
    ../../../lenovo/thinkpad
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.trackpoint.device = lib.mkDefault "TPPS/2 Elan TrackPoint";

  services.fprintd.enable = lib.mkDefault true;

  # kernel versions below 6.0 don’t contain ACPI suspend2idle drivers for the Z-series’ AMD hardware
  # my Z13 froze after waking up from suspend/ hibernate
  services.logind.lidSwitch = lib.mkIf (lib.versionOlder pkgs.linux.version "6.00") (lib.mkDefault "lock");
}
