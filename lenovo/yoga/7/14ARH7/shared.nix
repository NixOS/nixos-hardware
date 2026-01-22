{ ... }:

{
  imports = [
    ../../../../common/cpu/amd
    # Better power-savings from AMD PState:
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/gpu/amd
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # Configure basic system settings:
  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelParams = [
      "mem_sleep_default=deep"
      "pcie_aspm.policy=powersupersave"

      ## Supposed to help fix for suspend issues: SSD not correctly working, and Keyboard not responding:
      ## Not needed for the 6.1+ kernels?
      # "iommu=pt"

      ## Fixes for s2idle:
      ##    https://www.phoronix.com/news/More-s2idle-Rembrandt-Linux
      "acpi.prefer_microsoft_dsm_guid=1"
    ];

    blacklistedKernelModules = [ "nouveau" ];
  };
}
