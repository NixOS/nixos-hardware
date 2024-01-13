{ lib, config, ... }:
{
  imports = [
    ../../common/cpu/amd
    ../../common/gpu/amd
    ../../common/gpu/nvidia
    ../../common/pc/laptop  
  ];
  # These are the BusID's for this device.
  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    powerManagement.enable = lib.mkDefault false;
    powerManagement.finegrained = lib.mkDefault false;
    open = lib.mkDefault false;
    package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = lib.mkDefault true;
    prime = {
      offload.enable = lib.mkForce true;
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  #Early KMS
  boot.initrd.kernelModules = [ "amdgpu" "nvidia"];
}
