{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/intel/kaby-lake
    ../../../common/pc/laptop
    ./xps-common.nix
    ../../../common/gpu/nvidia
  ];

  hardware.graphics.enable = true;

  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
  # integrated
    intelBusId = "PCI:0:2:0";

  # dedicated
    nvidiaBusId = "PCI:1:0:0";
  };
}
