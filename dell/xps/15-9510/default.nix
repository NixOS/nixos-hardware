{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;

  # WiFi speed is slow and crashes by default (https://bugzilla.kernel.org/show_bug.cgi?id=213381)
  # Tuning based on iwlwifi reference(https://wiki.archlinux.org/title/Network_configuration/Wireless#iwlwifi)
  boot.extraModprobeConfig = ''
    options iwlwifi 11n_disable=8
  '';
}
