{ lib, ... }:
{
  imports = [
    ../.
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop/ssd
  ];

  # available cpufreq governors: performance powersave
  # The powersave mode locks the cpu to 700Mhz which is not really usable
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
