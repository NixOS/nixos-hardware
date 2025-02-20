{ lib, ... }:
{

  imports = [ 
    ../../../common/cpu/intel/coffee-lake
    ../../../common/pc/laptop
  ];

  # Solution to rcu_sched freezing
  boot.kernelParams = [ "acpi_rev_override" ];

  # This will save you money and possibly your life!
  # https://github.com/NixOS/nixos-hardware/pull/127
  services.thermald.enable = lib.mkDefault true;

  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
  };
}
