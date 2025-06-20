{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../../../common/gpu/nvidia/prime.nix
    ../../../../../common/gpu/nvidia/turing
    ../../../../../common/cpu/intel/tiger-lake
    ../.
  ];

  hardware = {
    enableAllFirmware = lib.mkDefault true;

    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    intelgpu.driver = "xe";

    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement = lib.mkIf config.hardware.nvidia.prime.sync.enable {
        enable = lib.mkDefault true;
      };

      modesetting = lib.mkIf config.hardware.nvidia.prime.sync.enable {
        enable = lib.mkDefault true;
      };
    };

  };

  services.thermald.enable = lib.mkDefault true;
}
