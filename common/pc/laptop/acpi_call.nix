{ config, lib, ... }: let
  inherit (lib) types;
in {
  options.boot.acpi_call.enable = lib.mkOption {
    type = types.bool;
    default = true;
    description = ''
      `acpi_call` kernel module is used for battery charge
      thresholds and recalibration on Sandy Bridge and newer models
      (X220/T420, X230/T430 et al.)
    '';
  };
  config = lib.mkIf config.boot.acpi_call.enable {
    boot.kernelModules = [ "acpi_call" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
