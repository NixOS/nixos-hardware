{ ... }:
{
  imports = [
    ../../common/cpu/amd
    ../../common/gpu/amd
    ../../common/gpu/nvidia
    ../../common/pc/laptop  
  ];
  # These are the BusID's for this device.
  hardware.nvidia.prime = {
    offload.enable = lib.mkDefault true;
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # force kernel to use iGPU first
  boot.initrd.kernelModules = [ "amdgpu" ];

}
