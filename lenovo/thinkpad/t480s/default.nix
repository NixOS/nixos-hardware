{
  pkgs,
  lib,
  config,
  ...
}:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/ssd
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;

  # There is currently a kernel regression with the psmouse driver. As such, the kernel version is held back to 6.10.
  # See https://bugzilla.kernel.org/show_bug.cgi?id=219352
  boot.kernelPackages = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages "6.11") (
    lib.warn "Linux kernel held back to 6.10 due to regression: https://bugzilla.kernel.org/show_bug.cgi?id=219352" pkgs.linuxPackages_6_10
  );
}
