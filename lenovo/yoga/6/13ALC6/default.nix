{ lib, pkgs, ...  }:

{
  imports = [
    ../../../thinkpad/yoga.nix
    ../../../../common/gpu/amd/default.nix
    ../../../../common/gpu/24.05-compat.nix
  ];

  boot.initrd.kernelModules = [ "ideapad_laptop" ];
  hardware.graphics.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];

  # latest kernel needed to make wifi work
  boot.kernelPackages =  lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;

  # energy savings
  boot.kernelParams = ["mem_sleep_default=deep" "pcie_aspm.policy=powersupersave"];
}
