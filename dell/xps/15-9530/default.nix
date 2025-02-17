{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;

  # 9530 wifi is:
  # > lspci | grep i Network
  # - 00:14.3 Network controller: Intel Corporation Raptor Lake PCH CNVi WiFi (rev 01)
  # > sudo lspci -vv -s 00:14.3
  # 00:14.3 Network controller: Intel Corporation Raptor Lake PCH CNVi WiFi (rev 01)
	# Subsystem: Intel Corporation Wi-Fi 6E AX211 160MHz
  #
  # WiFi speed is slow and crashes by default (https://bugzilla.kernel.org/show_bug.cgi?id=213381)
  # disable_11ax - required until ax driver support is fixed
  # power_save - works well on this card
  # boot.extraModprobeConfig = ''
  #   options iwlwifi power_save=1 disable_11ax=1
  # '';

  boot.extraModprobeConfig = ''
    options iwlwifi power_save=1
  '';
}
