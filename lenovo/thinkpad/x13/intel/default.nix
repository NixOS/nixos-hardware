{ ... }: {
  # Reference to hardware: https://certification.ubuntu.com/hardware/202004-27844
  imports = [
    ../common.nix
    ../../../../common/cpu/intel
  ];
}
