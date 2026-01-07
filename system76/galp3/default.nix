{
  imports = [
    ../.
    # not import ../../common/pc/laptop since tlp and ppd both conflict with system76-power
    ../../common/pc/ssd
    ../../common/cpu/intel/kaby-lake
    ../../common/hidpi.nix
  ];
}
