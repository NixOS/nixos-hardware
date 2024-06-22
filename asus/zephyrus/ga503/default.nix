{ ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  hardware.nvidia.prime = {
    reverseSync.enable = true;
    # Enable if using an external GPU        
    allowExternalGpu = false;
    amdgpuBusId = "PCI:7:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # fixes mic mute button
  services.udev.extraHwdb = ''
    evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
     KEYBOARD_KEY_ff31007c=f20
  '';
}
