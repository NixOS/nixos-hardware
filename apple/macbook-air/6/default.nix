{ config, lib, ... }:

{
  imports = [ ../. ];

  boot.blacklistedKernelModules = [ "bcma" ];

  boot = {
    # Divides power consumption by two.
    kernelParams = [ "acpi_osi=" ];
  };

  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
  '';
}
