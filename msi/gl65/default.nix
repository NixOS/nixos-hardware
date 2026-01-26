{ lib, ... }:

{
  imports = [
    ../../common/pc/ssd
    ../../common/cpu/intel/comet-lake
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/turing
    ../../common/pc/laptop
  ];

  hardware.bluetooth.enable = lib.mkDefault true;

  hardware.graphics.enable = lib.mkDefault true;

  hardware.nvidia = {
    prime = {
      # Bus ID of the Intel GPU.
      intelBusId = lib.mkDefault "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    };
  };

  boot.blacklistedKernelModules = [ "ucsi_ccg" ]; # The laptop lacks USB-C display hardware, but the kernel attempts to initialize it anyway, causing a boot delay.
}
