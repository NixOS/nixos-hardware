{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/coffee-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/pascal
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Specify bus id of Nvidia and Intel graphics
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  boot = {
    # Use same ACPI identifier as Dell Ubuntu
    kernelParams = [ "acpi_osi=Linux-Dell-Video" ];

    # Enable fan sensors.
    kernelModules = [ "dell-smm-hwmon" ];

    # Forces the driver to load on unknown hardware
    extraModprobeConfig = "options dell-smm-hwmon	ignore_dmi=1";
    # NOTE: PWM fan control compatibility needs explicit whitelisting in the kernel driver's code.
  };
}
