{ lib, pkgs, ... }: {
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../kmod.nix
    ../../framework-tool.nix
  ];

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  boot.extraModprobeConfig = lib.mkIf (lib.versionOlder pkgs.linux.version "6.6.8") ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
    # Disabling keyboard waking up from suspend to prevent wakeups while lid is closed due to keyboard being presssed by display flexing. 
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
  '';

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Enable keyboard customization
  hardware.keyboard.qmk.enable = lib.mkDefault true;
}
