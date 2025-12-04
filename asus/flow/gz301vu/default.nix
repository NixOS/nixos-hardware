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
            finegrained = mkDefault true;
          };

          dynamicBoost.enable = mkDefault true;

        };
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
        intelBusId = "PCI:0:2.0";
        nvidiaBusId = "PCI:1:0.0";
>>>>>>> 59abaea (fixed leading zeros on busid)
=======
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
>>>>>>> 47c7f7a (syntax!)
=======
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
>>>>>>> ed24f8a (Fix PCI bus ID formatting for Intel and Nvidia)
=======
>>>>>>> 7506c9d (formatted with nixfmt)
      };

    }
  ];
}
