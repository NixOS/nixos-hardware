{ ... }:

{
  imports = [ ../hybrid ];
  hardware = {
    nvidia.prime = {
      reverseSync.enable = true;
      allowExternalGpu = false;
      offload.enable = false;
    };
    amdgpu = {
      amdvlk = false;
      opencl = false;
    };
  };
}