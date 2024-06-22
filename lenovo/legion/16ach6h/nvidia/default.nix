{ lib, options, ... }:

{
  imports = [ ../hybrid ];
  services.xserver.videoDrivers = [ "nvidia" ]; # This will override services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" "nvidia" ];
  # When I play the game through proton, I found that in the case of Dual-Direct GFX
  # enabled (dGPU disabled), proton will crash directly. But in the case of hybrid,
  # the game runs fine with or without nvidia-offload After investigation, this is
  # because when writing the specialization of Dual-Direct GFX, I did not completely
  # remove all packages for amd igpu. I only removed amdgpu from
  # services.xserver.videoDrivers by overriding. This is because the specialization
  # of nix cannot implement such an operation as canceling an import.
  hardware = {
    nvidia.prime.offload.enable = false;
  } // lib.optionalAttrs (options ? amdgpu.opencl.enable) {
    # introduced in https://github.com/NixOS/nixpkgs/pull/319865
    amdgpu.opencl.enable = lib.mkDefault false;
  };
}
