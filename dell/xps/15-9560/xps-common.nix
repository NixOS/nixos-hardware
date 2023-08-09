{ lib, ... }:

{
  # Solution to rcu_sched freezing
  boot.kernelParams = [ "acpi_rev_override" ];

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;
}
