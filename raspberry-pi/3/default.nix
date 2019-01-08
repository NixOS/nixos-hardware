{ lib, pkgs, ...}:

{
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    extraTTYs = [ "ttyAMA0" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi;
    kernelParams = [
      "dwc_otg.lpm_enable=0"
      "console=ttyAMA0,115200"
      "rootwait"
      "elevator=deadline"
      "cma=32M"
    ];
    loader = {
      grub.enable = lib.mkDefault false;
      generationsDir.enable = lib.mkDefault false;
      raspberryPi = {
        enable = lib.mkDefault true;
        version = lib.mkDefault 3;
      };
    };
  };

  nix.buildCores = 4;

  nixpkgs.config.platform = lib.systems.platforms.aarch64-multiplatform;

  services.openssh.enable = lib.mkDefault true;
}
