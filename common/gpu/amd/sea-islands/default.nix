{
  imports = [ ../. ];
  boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];
}
