{ ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # fixes mic mute button
  services.udev.extraHwdb = ''
    evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
     KEYBOARD_KEY_ff31007c=f20
  '';
}
