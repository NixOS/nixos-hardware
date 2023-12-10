{ ... }:

{
  imports = [ ../hybrid ];
  services.xserver.videoDrivers = [ "nvidia" ]; # This will override services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" "nvidia" ];
  hardware = {
    nvidia.prime.offload.enable = false;
    amdgpu = {
      amdvlk = false;
      opencl = false;
    };
  };
}