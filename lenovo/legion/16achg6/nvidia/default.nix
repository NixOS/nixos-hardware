{ lib, options, ... }:

{
  imports = [ ../hybrid ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia.prime.offload.enable = false;
  } // lib.optionalAttrs (options ? amdgpu.opencl.enable) {
    # introduced in https://github.com/NixOS/nixpkgs/pull/319865
    amdgpu.opencl.enable = lib.mkDefault false;
  };
}
