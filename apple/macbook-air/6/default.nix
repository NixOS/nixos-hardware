{ config, lib, ... }:

{
  imports = [ ../. ];

  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.blacklistedKernelModules = [ "bcma" ];

  boot = {
    # Divides power consumption by two.
    kernelParams = [ "acpi_osi=" ];
  };

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';
}
