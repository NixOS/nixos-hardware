{ ... }: {
  # Reference to hardware: https://ubuntu.com/certified/202012-28574
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/ssd
  ];
}
