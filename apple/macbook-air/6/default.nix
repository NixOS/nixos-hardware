{ config, lib, ... }:

{
  imports = [
    ../.
    ../../../common/broadcom-wifi.nix
  ];

  config = {
    boot = {
      # Divides power consumption by two.
      kernelParams = [ "acpi_osi=" ];

      blacklistedKernelModules = [ "bcma" ];
    };

    services.xserver.deviceSection = lib.mkDefault ''
      Option "TearFree" "true"
    '';
  };
}
