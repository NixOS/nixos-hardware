{ lib, config, ... }:

{
  imports = [ ./. ];

  hardware.nvidia.prime = {
    # For people who want to use sync insted of offload. Esipecially for AMD CPU users
    sync.enable = lib.mkOverride 990 true;
  };
}
