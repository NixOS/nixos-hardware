{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./firmware.nix
  ];

  boot = {
    consoleLogLevel = lib.mkDefault 7;

    initrd.availableKernelModules = [ "dw_mmc_starfive" ];

    # Support booting SD-image from NVME SSD
    initrd.kernelModules = [
      "clk-starfive-jh7110-aon"
      "clk-starfive-jh7110-stg"
      "phy-jh7110-pcie"
      "pcie-starfive"
      "nvme"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

}
