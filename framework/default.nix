{ lib, pkgs, ... }: {
  imports = [
    ../common/cpu/intel
    ../common/pc/laptop
    ../common/pc/laptop/ssd
  ];

  # For Power consumption
  # https://kvark.github.io/linux/framework/2021/10/17/framework-nixos.html
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Requires at least 5.12 for working wi-fi and bluetooth.
  # https://community.frame.work/t/using-the-ax210-with-linux-on-the-framework-laptop/1844/89
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.12") (lib.mkDefault pkgs.linuxPackages_latest);

  # For fingerprint support
  services.fprintd.enable = true;

  # HiDPI
  # Leaving here for documentation
  # hardware.video.hidpi.enable = lib.mkDefault true;

  # Fix font sizes in X
  # services.xserver.dpi = 200;
}
