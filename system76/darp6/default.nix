# Hardware profile for the Darter Pro 6 laptop by System76.
#
# https://system76.com/laptops/darter

{ config, ... }:
let
  # darp6 needs system76-acpi-dkms, not system76-dkms:
  #
  # [1] https://github.com/pop-os/system76-dkms/issues/39
  # jackpot51> system76-acpi-dkms is the correct driver to use on the darp6
  #
  # system76-io-dkms also appears to be loaded on darp6 with Pop!_OS, and
  # system76-dkms does not, and in fact refuses to load.
  packages = with config.boot.kernelPackages; [ system76-acpi system76-io ];
in
{
  imports = [
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
  ];

  boot.extraModulePackages = packages;

  # system76_acpi automatically loads on darp6, but system76_io does not.
  # Explicitly list all modules to be loaded, for consistency.
  boot.kernelModules = map (drv: drv.moduleName) packages;
}
