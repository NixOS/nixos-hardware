{ lib, pkgs, ... }: {
  imports = [
    ../.
    ../../../../../common/pc/laptop/ssd
  ];

  # This laptop is too new for the kernel currently in nixos-unstable.
  # On Kernel 5.15.x, dmesg shows the `hardware is newer than drivers` message.
  # When starting the system with 5.15.x, only a tty is being displayed.
  # After our tests, at least version 5.19 is required for the system to work properly.
  boot.kernelPackages = lib.mkIf
    (lib.versionOlder pkgs.linux.version "5.19")
    (lib.mkDefault pkgs.linuxPackages_latest);
}
