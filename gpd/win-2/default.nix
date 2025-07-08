{ config, lib, ... }:
{
  imports = [
    ../../common/cpu/intel
    ../../common/pc/ssd
  ];

  boot.kernelParams = [
    "fbcon=rotate:1"
    "video=eDP-1:panel_orientation=right_side_up"
  ];

  services.tlp.enable = lib.mkDefault (
    (lib.versionOlder (lib.versions.majorMinor lib.version) "21.05")
    || !config.services.power-profiles-daemon.enable
  );

  # Required for grub to properly display the boot menu.
  boot.loader.grub.gfxmodeEfi = lib.mkDefault "720x1280x32";

}
