{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkMerge
    ;
in
{

  imports = [
    ../../../common/cpu/intel/raptor-lake
    ../../../common/gpu/intel/raptor-lake
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  config = mkMerge [
    {
      # Configure basic system settings:
      boot = {
        blacklistedKernelModules = [ "nouveau" ];
        kernelModules = [ "kvm-intel" ];
        kernelParams = [
          "mem_sleep_default=deep"
          "pcie_aspm.policy=powersupersave"
          "nvidia-drm.modeset=1"
          "nvidia-drm.fbdev=1"
        ];
      };

      services = {
        asusd = {
          enable = mkDefault true;
          enableUserService = mkDefault true;
        };

        supergfxd.enable = mkDefault true;

      };

      #flow devices are 2 in 1 laptops
      hardware.sensor.iio.enable = mkDefault true;

      hardware = {

        nvidia = {

          modesetting.enable = true;
          nvidiaSettings = mkDefault true;
          forceFullCompositionPipeline = mkDefault true;

          prime = {
            offload = {
              enable = mkDefault true;
              enableOffloadCmd = mkDefault true;
            };
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };

          powerManagement = {
            enable = mkDefault true;
            finegrained = mkDefault false;
          };

          dynamicBoost.enable = mkDefault true;

        };
      };

    }
  ];
}
