{ lib, ... }:

{
  imports = [ ../. ];

  # Current solution to avoid black screen on boot is to set
  # PCI registers of PCIe bridge and display: https://askubuntu.com/a/613573
  boot.initrd.preDeviceCommands = ''
    setpci -s "00:17.0" 3e.b=8;
    setpci -s "02:00.0" 04.b=7;
  '';
  
  boot.initrd.extraUtilsCommands = ''
    cp -v ${pkgs.pciutils}/bin/setpci $out/bin
  '';

  # Requires nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidiaLegacy340" ];
  services.xserver.deviceSection = lib.mkDefault ''
    Option   "NoLogo"          "TRUE"
    Option   "DPI"             "96 x 96"
    Option   "RegistryDwords"  "EnableBrightnessControl=1"
  '';
}
