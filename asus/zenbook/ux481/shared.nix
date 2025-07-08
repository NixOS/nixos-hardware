{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/comet-lake/cpu-only.nix
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../battery.nix
  ];

  boot.kernelParams = [
    # These options are needed for suspend to work,
    # otherwise the nvme will be mounted read-only on resume
    "pcie_aspm=off"
    "pcie_port_pm=off"
    "nvme_core.default_ps_max_latency_us=0"
    "mem_sleep_default=deep"
  ];

  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
