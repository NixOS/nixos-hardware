{ lib, pkgs, ... }:

{
  imports = [
    ../../../thinkpad/yoga.nix
    ../../../../common/gpu/amd/default.nix
  ];

  boot.initrd.kernelModules = [ "ideapad_laptop" ];

  # latest kernel needed to make wifi work
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;

  # energy savings
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "pcie_aspm.policy=powersupersave"
  ];

  # Fix for unstable wifi connection on Lenovo laptops
  boot.extraModprobeConfig = ''
    options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
  '';

  hardware.bluetooth.enable = lib.mkDefault true;
}
