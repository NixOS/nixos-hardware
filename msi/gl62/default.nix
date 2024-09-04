{ lib, ... }:

{
  imports = [
    ../../common/pc/laptop/ssd
    ../../common/cpu/intel
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/pascal
    ../../common/pc/laptop
  ];

  boot.kernelParams = [
    # For Power consumption in case of NVME SSD
    # was installed.
    "nvme.noacpi=1"

    # For fixing interferences with Fn- action keys
    "video.report_key_events=0"
  ];

  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU.
    intelBusId = lib.mkDefault "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU.
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}
