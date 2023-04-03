# acpi_call makes tlp work for newer thinkpads

{ config, lib, ... }:

{
  boot = lib.mkIf config.services.tlp.enable {
    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
