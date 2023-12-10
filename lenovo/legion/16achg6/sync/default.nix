{ ... }:

{
  imports = [ ../hybrid ];
  hardware = {
    nvidia.prime = {
      sync.enable = true;
      allowExternalGpu = false;
      offload.enable = false;
    };
  };
}