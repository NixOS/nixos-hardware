{ ... }:

{
  imports = [ ../hybrid ];
  services.xserver.videoDrivers = [ "nvidia" ]; # This will override services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" "nvidia" ];
  # When I play the game through proton, I found that in the case of Dual-Direct GFX
  # enabled (dGPU disabled), proton will crash directly. But in the case of hybrid,
  # the game runs fine with or without nvidia-offload After investigation, this is
  # because when writing the specialization of Dual-Direct GFX, I did not completely
  # remove all packages for amd igpu. I only removed amdgpu from
  # services.xserver.videoDrivers by overriding. This is because the specialization
  # of nix cannot implement such an operation as canceling an import. In the end, if
  # it is enabled in Dual-Direct GFX In the absence of amd igpu, the amdvlk package
  # caused the proton to crash. In order to solve this problem, I add the option of
  # whether to enable amdvlk to the configuration file of amd gpu, and open it by
  # default, and turn it off in specialization, so as to delete amdvlk package and
  # other packages for amd igpu in specialization. At the same time, I also added an
  # option to amdgpu's opencl runtime.
  hardware = {
    nvidia.prime.offload.enable = false;
    amdgpu = {
      amdvlk = false;
      opencl = false;
    };
  };
}