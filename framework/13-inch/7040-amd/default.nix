{ lib, pkgs, ... }: {
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Newer kernel is better for amdgpu driver updates
  # Requires at least 5.16 for working wi-fi and bluetooth (RZ616, kmod mt7922):
  # https://wireless.wiki.kernel.org/en/users/drivers/mediatek
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.1") (lib.mkDefault pkgs.linuxPackages_latest);

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  #
  # Temporary until a kernel patch is merged to fix this
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"

    # Prevent wake when plugging in AC during suspend. Trade-off: keyboard wake disabled. See:
    # https://community.frame.work/t/tracking-framework-amd-ryzen-7040-series-lid-wakeup-behavior-feedback/39128/45
    #ACTION=="add", SUBSYSTEM=="serio", DRIVERS=="atkbd", ATTR{power/wakeup}="disabled"
  '';

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = lib.mkDefault true;
}
