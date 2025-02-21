{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # enable firmwares with a license allowing redistribution
  # this includes the Wi-Fi and Bluetooth firmwares
  hardware.enableRedistributableFirmware = true;

  # touchpad uses I²C, so PS/2 is unnecessary
  boot.blacklistedKernelModules = ["psmouse"];

  # enable finger print sensor
  # configure with `sudo fprintd-enroll <username>`
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # enable updating firmware via `fwupdmgr`
  services.fwupd.enable = true;

  # enable cooling management, see NixOS/nixos-hardware#127
  services.thermald.enable = lib.mkDefault true;

  # fix laptop's screen flickering, see https://wiki.archlinux.org/title/Intel_graphics#Screen_flickering
  boot.kernelParams = ["i915.enable_psr=0"];
}
