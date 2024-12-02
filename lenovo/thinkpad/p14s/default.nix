{ lib, pkgs, ... }:

{
  # P14s is a rebadged T14 with slight internal differences.
  # This may change for future models, so we duplicate the T14 hierarchy here.

  imports = [
    ../.
    ../../../common/pc/laptop/ssd
  ];

  # Force use of the amdgpu driver for backlight control on kernel versions where the
  # native backlight driver is not already preferred. This is preferred over the
  # "vendor" setting, in this case the thinkpad_acpi driver.
  # See https://hansdegoede.livejournal.com/27130.html
  # See https://lore.kernel.org/linux-acpi/20221105145258.12700-1-hdegoede@redhat.com/
  boot.kernelParams = lib.mkIf (lib.versionOlder pkgs.linux.version "6.2") [ "acpi_backlight=native" ];

  # see https://github.com/NixOS/nixpkgs/issues/69289
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.2") pkgs.linuxPackages_latest;
}
