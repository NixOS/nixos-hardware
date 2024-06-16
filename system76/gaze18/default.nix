{ config, lib, pkgs, ... }:
{
  imports = [
    ../.
  ];
  boot.initrd.kernelModules = [ "nvidia" ];

  hardware.opengl = {
    enable = lib.mkDefault true;
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    modesetting.enable = lib.mkDefault true;

    powerManagement.finegrained = lib.mkDefault true;

    nvidiaSettings = lib.mkDefault true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = lib.mkDefault true;
      };
    };
  };
}



