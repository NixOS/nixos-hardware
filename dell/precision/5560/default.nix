{
  config,
  lib,
  ...
}: {
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/cpu/intel
    ../../../common/gpu/intel/tiger-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot = {
    blacklistedKernelModules = ["nouveau"];
    kernelModules = ["kvm-intel"];
    kernelParams = ["i915.modeset=1"];
  };

  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = lib.mkDefault true;
      open = lib.mkDefault false;
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
