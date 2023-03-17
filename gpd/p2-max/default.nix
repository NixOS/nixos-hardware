{lib, ...}: {
  imports = [
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
    ../../common/cpu/intel
    ../../common/cpu/intel/kaby-lake
  ];

  # HiDPI settings
  hardware.video.hidpi.enable = lib.mkDefault true;
}
