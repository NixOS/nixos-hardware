{ lib, ... }:

{
  imports = [ ../. ];

  # Current solution to avoid black screen on boot is to set
  # PCI registers with GRUB: https://askubuntu.com/a/613573
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.loader.grub = {
    enabe = true;
    efiSupport = true;
    device = lib.mkDefault "nodev";
    extraConfig = lib.mkDefault ''
      insmod setpci;
      setpci -s "00:17.0" 3e.b=8;
      setpci -s "02:00.0" 04.b=7;
    '';
  };

  # Requires nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidiaLegacy340" ];
  services.xserver.deviceSection = lib.mkDefault ''
    Option   "NoLogo"          "TRUE"
    Option   "DPI"             "96 x 96"
    Option   "RegistryDwords"  "EnableBrightnessControl=1"
  '';
}
