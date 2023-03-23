{lib, ...}: {
  imports = [
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
    ../../common/cpu/intel
    ../../common/cpu/intel/kaby-lake
  ];

  # HiDPI settings
  fonts.optimizeForVeryHighDPI = lib.mkDefault true;
}
