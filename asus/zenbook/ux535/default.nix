{
  lib,
  ...
}:
{
  imports = [
    ../../../common/gpu/nvidia/turing
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/cpu/intel
    ../../../common/gpu/intel/comet-lake
    ../../../common/pc/laptop/ssd
    ../../../common/hidpi.nix # 4K screen is HiDPI
    ../../battery.nix
  ];

  config = {
    hardware.nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0"; # Intel UHD Graphics Comet Lake
        nvidiaBusId = "PCI:1:0:0"; # Nvidia GTX 1650 Ti Max-Q

        reverseSync.enable = lib.mkDefault true; # Turning this on meant the Thunderbolt port was able to be used for video
      };
      dynamicBoost.enable = false; # Doesn't work on this GPU - causes error rebuilding
    };

    powerManagement.powertop.enable = lib.mkDefault false; # This caused issues with USB ports losing power while the device was on

    services.hardware.bolt.enable = lib.mkDefault true; # Thunderbolt
  };
}
