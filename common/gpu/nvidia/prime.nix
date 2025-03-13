{ lib, config, ... }:

{
  imports = [ ./. ];

  options = {
    hardware.nvidia.primeBatterySaverSpecialisation = lib.mkEnableOption "Enable the battery saver specialisation for NVIDIA Prime";
  };

  config = {

    hardware.nvidia.prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
      };
      # Hardware should specify the bus ID for intel/nvidia devices
    };

    # A specialisation for optimal battery life
    specialisation = lib.optionalAttrs config.hardware.nvidia.primeBatterySaverSpecialisation {
      battery-saver.configuration = {
        system.nixos.tags = ["battery-saver"];
        imports = [
          # Leave only the integrated GPU enabled
          ./disable.nix
        ];
        hardware.nvidia.prime.offload.enable = lib.mkForce false;
        hardware.nvidia.powerManagement.enable = lib.mkForce false;
        hardware.nvidia.powerManagement.finegrained = lib.mkForce false;
      };
    };
  };
}
