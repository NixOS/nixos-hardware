{ lib, pkgs, ...  }:

{
  imports = [
    ../../../thinkpad/yoga.nix
    ../../../../common/gpu/amd/default.nix
  ];

  boot.initrd.kernelModules = [ "ideapad_laptop" ];
  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];

  boot.kernelPackages =  lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;

  # energy savings
  hardware.bluetooth.powerOnBoot = lib.mkDefault false;
  boot.kernelParams = ["mem_sleep_default=deep" "pcie_aspm.policy=powersupersave"];
}
