{ config, lib, ... }:

{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # Enables ACPI platform profiles
  boot = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1") {
    kernelModules = [ "hp-wmi" ];
  };
}
