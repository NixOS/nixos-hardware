{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  hardware.nvidia = {
    # Enable DRM kernel mode setting
    # This will also cause "PCI-Express Runtime D3 Power Management" to be enabled by default
    modesetting.enable = lib.mkDefault true;

    dynamicBoost.enable = lib.mkDefault true;

    prime = {
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
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
