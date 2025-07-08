{ lib, config, ... }:

{
  imports = [ ./. ];

  options = {
    hardware.nvidia.primeBatterySaverSpecialisation = lib.mkEnableOption "configure a specialisation which turns on NVIDIA Prime battery saver";
  };

  config = {

    hardware.nvidia.prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
      };
      # Hardware should specify the bus ID for intel/nvidia devices
    };

    specialisation = lib.mkIf config.hardware.nvidia.primeBatterySaverSpecialisation {
      battery-saver.configuration = {
        system.nixos.tags = [ "battery-saver" ];
        imports = [
          # Leave only the integrated GPU enabled
          ./disable.nix
        ];
        hardware.nvidia = {
          prime.offload.enable = lib.mkForce false;
          powerManagement = {
            enable = lib.mkForce false;
            finegrained = lib.mkForce false;
          };
        };
      };
    };
  };
}
