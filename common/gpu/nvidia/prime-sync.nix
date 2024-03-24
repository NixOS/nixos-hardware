{ lib, config, ... }:

{
  imports = [ ./. ];

  hardware.nvidia.prime = {
    # For people who want to use sync instead of offload. Especially for AMD CPU users
    sync.enable = lib.mkOverride 990 true;
  };
}
