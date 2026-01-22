{
  imports = [
    ../shared.nix
    ../../../../common/gpu/nvidia/ada-lovelace
  ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
