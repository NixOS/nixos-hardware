{ lib, pkgs, ... }: {
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
  ];

  boot.kernelParams = [
    # Fixes a regression in s2idle, making it more power efficient than deep sleep
    "acpi_osi=\"!Windows 2020\""
  ];

  # Newer kernel is better for amdgpu driver updates
  # Requires at least 5.16 for working wi-fi and bluetooth (RZ616, kmod mt7922):
  # https://wireless.wiki.kernel.org/en/users/drivers/mediatek
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") (lib.mkDefault pkgs.linuxPackages_latest);

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Fix headphone noise when on powersave
    # https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
  '';

  # Mis-detected by nixos-generate-config
  # https://github.com/NixOS/nixpkgs/issues/171093
  # https://wiki.archlinux.org/title/Framework_Laptop#Changing_the_brightness_of_the_monitor_does_not_work
  hardware.acpilight.enable = lib.mkDefault true;

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = lib.mkDefault true;
}
