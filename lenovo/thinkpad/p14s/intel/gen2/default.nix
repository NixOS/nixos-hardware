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
    ../../../../../common/gpu/intel/tiger-lake
    ../../../../../common/pc/laptop
    ../../../../../common/pc/ssd
    ../../../../../common/pc
    ../.
  ];

  # For suspending to RAM to work, set Config -> Power -> Sleep State to "Linux S3" in EFI.

  hardware = {
    intelgpu.driver = "xe";
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  services = {
    xserver.videoDrivers = [
      "modesetting" # apparently required for offload, should this be added into common? https://wiki.nixos.org/wiki/NVIDIA#Offload_mode
    ];
  };
}
