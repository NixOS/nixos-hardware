{ lib, pkgs, config, ... }:

{
  imports = [
    ../.
    ../../../../../common/cpu/amd/pstate.nix
  ];

  # Embedded controller wake-ups drain battery in s2idle on this device
  # See https://lore.kernel.org/all/ZnFYpWHJ5Ml724Nv@ohnotp/
  boot.kernelParams = [ "acpi.ec_no_wakeup=1" ];

  # For the Qualcomm NFA765 [17cb:1103] wireless network controller
  # See https://bugzilla.redhat.com/show_bug.cgi?id=2047878
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;
}
