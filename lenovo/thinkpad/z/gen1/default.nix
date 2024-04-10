{ lib, pkgs, ... }: {
  imports = [
    ../../../../lenovo/thinkpad/z
  ];

  # Kernel 5.18 is required for the Ryzen 6000 series
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.18") (lib.mkDefault pkgs.linuxPackages_latest);
}
