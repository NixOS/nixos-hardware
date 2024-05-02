{ config, lib, pkgs, ... }:

{
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    initrd = {
      availableKernelModules = [
        "amdgpu"
        "radeon"
        "mmc_block"
        "sdhci_sophgo"
      ];
    };
    kernelPackages = pkgs.linuxPackagesFor (pkgs.callPackage ./linux.nix {
      inherit (config.boot) kernelPatches;
    });
    kernelParams = lib.mkDefault [
      "earlycon"
      "console=ttyS0,115200"
      "console=tty1"
    ];
  };

  hardware.deviceTree = {
    enable = true;
    name = lib.mkDefault "sophgo/mango-milkv-pioneer.dtb";
  };
}
