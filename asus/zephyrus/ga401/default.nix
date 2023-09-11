{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  hardware.nvidia = {
    # PCI-Express Runtime D3 Power Management is enabled by default on this laptop
    # But it can fix screen tearing & suspend/resume screen corruption in sync mode
    modesetting.enable = lib.mkDefault true;
    # Enable DRM kernel mode setting
    powerManagement.enable = lib.mkDefault true;
    
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
