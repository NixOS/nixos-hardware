{ lib, config, ... }:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../kmod.nix
    ../../framework-tool.nix
    ../../keylightd.nix
  ];

  # For fingerprint support
  services.fprintd.enable = lib.mkDefault true;

  # Custom udev rules
  services.udev.extraRules = ''
    # Ethernet expansion card support
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"

    # Allow access to the keyboard modules for programming, for example by
    # visiting https://keyboard.frame.work with a WebHID-compatible browser.
    #
    # https://community.frame.work/t/responded-help-configuring-fw16-keyboard-with-via/47176/5
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Enable keyboard customization
  hardware.keyboard.qmk.enable = lib.mkDefault true;

  # Everything is updateable through fwupd
  services.fwupd.enable = true;
}
