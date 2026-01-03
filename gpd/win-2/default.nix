{
  config,
  lib,
  options,
  ...
}:
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
    !(options.services ? power-profiles-daemon && config.services.power-profiles-daemon.enable)
    && !(options.services ? tuned && config.services.tuned.enable)
  );

  # Required for grub to properly display the boot menu.
  boot.loader.grub.gfxmodeEfi = lib.mkDefault "720x1280x32";

}
