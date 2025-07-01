{
  imports = [
    ../../../../../common/gpu/nvidia/prime.nix
    ../../../../../common/gpu/nvidia/turing
    ../../../../../common/cpu/intel/tiger-lake
    ../../../../../common/pc/laptop
    ../../../../../common/pc/ssd
    ../../../../../common/pc
    ../.
  ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.xserver.videoDrivers = [ "modesetting" ];
}
