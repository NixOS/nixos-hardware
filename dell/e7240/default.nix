{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  boot.loader.systemd-boot.enable = lib.mkDefault true;

  hardware.pulseaudio.enable = true;

  # on current latest (4.17) have suspend issues
  # https://bugzilla.redhat.com/show_bug.cgi?id=1597481
  boot.kernelPackages = pkgs.linuxPackages_4_14;
}
