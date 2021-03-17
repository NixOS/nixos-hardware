{
  imports = [
    ../.
    ../../../common/cpu/intel
  ];

  boot.kernelParams = [
    # Disable "Panel Self Refresh".  Fix random freezes.
    "i915.enable_psr=0"
  ];
}
