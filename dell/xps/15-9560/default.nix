{
  imports = [
    ../../../common/cpu/intel
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
    ./xps-common.nix
  ];

# enable opengpl and gpu drivers
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia.modesetting.enable = true;

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;  # provides the nvidia-offload command
    };

# integrated
    intelBusId = "PCI:0:2:0";

# dedicated
    nvidiaBusId = "PCI:1:0:0";
  };

}
