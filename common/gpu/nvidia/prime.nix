{ lib, config, ... }:

{
  imports = [ ./. ];

  hardware.nvidia.prime = {
    offload = {
      enable = lib.mkOverride 990 true;
      enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
    };
    # Hardware should specify the bus ID for intel/nvidia devices
  };
}
