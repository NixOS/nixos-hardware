{ lib, pkgs, ... }:

{
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault (
      pkgs.linuxPackagesFor (
        pkgs.callPackage ../common/kernel.nix {
          rpiVersion = 2;
        }
      )
    );
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      "console=ttyAMA0,115200"
      "rootwait"
      "elevator=deadline"
    ];
    loader = {
      grub.enable = lib.mkDefault false;
      generationsDir.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  nixpkgs.config.platform = lib.systems.platforms.armv7l-hf-multiplatform;

  # cpufrequtils doesn't build on ARM
  powerManagement.enable = lib.mkDefault false;

  services.openssh.enable = lib.mkDefault true;
}
