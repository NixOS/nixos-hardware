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

  # For suspending to RAM to work, set Config -> Power -> Sleep State to "Linux S3" in EFI.

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
    };
  };
}
