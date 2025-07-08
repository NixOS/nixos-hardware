{
  imports = [ ../. ];
  # Explicitly set amdgpu support in place of radeon
  boot.kernelParams = [
    "radeon.si_support=0"
    "amdgpu.si_support=1"
  ];
}
