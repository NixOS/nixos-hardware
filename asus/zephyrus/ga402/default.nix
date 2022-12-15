{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  services = {
    asusd.enable = lib.mkDefault true;
  };

  boot = {
    kernelParams = [ "pcie_aspm.policy=powersupersave" "acpi.prefer_microsoft_dsm_guid=1" ];
  };
}
