{ lib, pkgs, ... }: {
  imports = [
    ../common
    ../common/amd.nix
  ];

  # Newer kernel is better for amdgpu driver updates
  # Requires at least 5.16 for working wi-fi and bluetooth (RZ616, kmod mt7922):
  # https://wireless.wiki.kernel.org/en/users/drivers/mediatek
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.1") (lib.mkDefault pkgs.linuxPackages_latest);

  # Custom udev rules
  services.udev.extraRules = ''
    # Prevent wake when plugging in AC during suspend. Trade-off: keyboard wake disabled. See:
    # https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
    #ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
  '';
}
