{
  imports = [ ../. ];

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];
}
