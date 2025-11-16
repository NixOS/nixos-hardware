{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  # NVIDIA GeForce GTX 1650 Mobile
  imports = [
    ../shared.nix
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/turing
  ];

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
  };

  hardware = {
    ## Enable the Nvidia card, as well as Prime and Offload:
    amdgpu.initrd.enable = mkDefault true;

    nvidia = {

      modesetting.enable = true;
      nvidiaSettings = mkDefault true;

      prime = {
        offload = {
          enable = mkDefault true;
          enableOffloadCmd = mkDefault true;
        };
        amdgpuBusId = "PCI:8:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement = {
        enable = mkDefault true;
        finegrained = mkDefault true;
      };

      dynamicBoost.enable = mkDefault true;
    };
  };
}
