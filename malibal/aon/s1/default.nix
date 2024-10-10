{ pkgs, lib, ... }:

{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd

    ../../../common/cpu/intel

    ../../../common/gpu/nvidia/disable.nix
  ];

  boot = {
    kernelParams = [
      "mem_sleep_default=deep"
      "i915.fastboot=1"
    ];
    kernelModules = [
      "coretemp"
    ];
  };

  powerManagement = {
    powertop.enable = lib.mkDefault true;
  };

  services = {
    fwupd = {
      enable = lib.mkDefault true;
    };
  };
}
