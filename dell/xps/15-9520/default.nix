{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/intel/alder-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;

  # WiFi speed is slow and crashes by default (https://bugzilla.kernel.org/show_bug.cgi?id=213381)
  # disable_11ax - required until ax driver support is fixed
  # power_save - works well on this card
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=1 disable_11ax=1
  '';
}
