{ ... }:

{
  imports = [ ../hybrid ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia.prime.offload.enable = false;
    amdgpu = {
      amdvlk = false;
      opencl = false;
    };
  };
}