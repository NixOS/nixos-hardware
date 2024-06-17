{
  imports = [ ../intel ];

  boot.kernelParams = [ "i915.enable_psr=0" ]; # Disable Intel Panel Self Refresh
}