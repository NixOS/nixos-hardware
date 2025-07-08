{
  imports = [ ../. ];
  # Explicitly set amdgpu support in place of radeon
  boot.kernelParams = [
    "radeon.cik_support=0"
    "amdgpu.cik_support=1"
  ];
}
