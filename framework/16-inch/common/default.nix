{ lib, pkgs, ... }: {
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../bluetooth.nix
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

  # Allow `services.libinput.touchpad.disableWhileTyping` to work correctly.
  # Set unconditionally because libinput can also be configured dynamically via
  # gsettings.
  #
  # This is extracted from the quirks file that is in the upstream libinput
  # source.  Once we can assume everyone is on at least libinput 1.26.0, this
  # local override file can be removed.
  # https://gitlab.freedesktop.org/libinput/libinput/-/commit/566857bd98131009699c9ab6efc7af37afd43fd0
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Framework Laptop 16 Keyboard Module]
    MatchName=Framework Laptop 16 Keyboard Module*
    MatchUdevType=keyboard
    MatchDMIModalias=dmi:*svnFramework:pnLaptop16*
    AttrKeyboardIntegration=internal
  '';
}
