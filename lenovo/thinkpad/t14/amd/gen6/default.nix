{
  ...
}:

{
  imports = [
    ../.
    ../../../../../common/cpu/amd/pstate.nix
  ];

  # Embedded controller wake-ups drain battery in s2idle on this device
  # See https://lore.kernel.org/all/ZnFYpWHJ5Ml724Nv@ohnotp/
  boot.kernelParams = [ "acpi.ec_no_wakeup=1" ];
}
