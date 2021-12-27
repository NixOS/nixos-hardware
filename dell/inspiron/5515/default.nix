{ lib, pkgs, ... }:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # touchpad identifies itself as DELL0A78:00 27C6:0D42 Touchpad in xinput list
  # it sometimes fails to register (ps2 mouse emulation works, but not scrolling)
  # hack around it by unloading and reloading module i2c_hid
  systemd.services.fix-touchpad = {
    path = [ pkgs.kmod ];
    serviceConfig.ExecStart = "${./fix_touchpad.sh}";
    description = "reload touchpad driver";
    # must run at boot (and not too early), and after suspend
    wantedBy = [ "display-manager.service" "sleep.target" ];
    after = [ "sleep.target" ];
  };


  # fix suspend
  # https://bbs.archlinux.org/viewtopic.php?id=266108 says linux >= 5.12 required
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.12") pkgs.linuxPackages_latest;


}
