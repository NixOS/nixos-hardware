{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../shared/backlight.nix
  ];

  hardware.nvidia = {
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    modesetting.enable = lib.mkDefault true;
    dynamicBoost.enable = lib.mkDefault true;
  };

  services = {
    asusd.enable = lib.mkDefault true;

    udev.extraHwdb = ''
      evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
        KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
        KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
        KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
    '';
  };
}
