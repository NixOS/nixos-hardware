{ lib, pkgs, ... }:

{
  imports = [
    ../../common/cpu/intel/alder-lake
    ../../common/pc
    ../../common/pc/ssd
  ];

  # i915 GuC/DMC blobs and the Realtek RTL8852BE (rtw89) WiFi firmware
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # The onboard Intel I226-V (igc) is widely reported to stall or flap
  # (repeated Link Down/Up cycles) when the link enters PCIe ASPM low-power
  # states. See README.md for details and references.
  boot.kernelParams = [ "pcie_aspm=off" ];

  # The other half of the same issue: disable Energy-Efficient Ethernet.
  # Matching on the driver keeps the rule independent of the interface name.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", ENV{ID_NET_DRIVER}=="igc", RUN+="${pkgs.ethtool}/bin/ethtool --set-eee %k eee off"
  '';
}
