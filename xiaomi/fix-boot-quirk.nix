{ lib, ... }:
{
  # Required fix to allow booting NixOS on certain Xiaomi laptops
  # https://discourse.nixos.org/t/system-wont-boot-path-efi-stub/29212/12
  boot.kernelPatches = lib.singleton {
    name = "Fix boot";
    patch = null;
    extraStructuredConfig = with lib.kernel; {
      ACPI_DEBUG = yes;
    };
  };
}
