{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/ssd
  ];

  boot.kernelParams = [
    # Disable "Panel Self Refresh".  Fix random freezes.
    "i915.enable_psr=0"
  ];
}
