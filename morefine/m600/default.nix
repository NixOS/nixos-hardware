{ lib, pkgs, ...}: {
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # If the wireless card is not replaced
  # boot.initrd.availableKernelModules = [ "r8169" ];
}
