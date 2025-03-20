{
  imports = [
    ../../../common/gpu/nvidia/pascal
    ../../../common/gpu/nvidia/prime.nix
  ];

  hardware.nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      dynamicBoost.enable = lib.mkDefault true;
  };
}
