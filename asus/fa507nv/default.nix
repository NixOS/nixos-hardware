{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/raphael/igpu.nix
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/nvidia
    ../../common/gpu/nvidia/prime.nix
    ../../common/hidpi.nix
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../battery.nix
  ];

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.6") pkgs.linuxPackages_latest;

  # The bottom 2 parts are taken from the framework 16-inch laptops configurations.
  # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
  boot.kernelParams = lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") ["rtc_cmos.use_acpi_alarm=1"];

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;

  # Adds the missing asus functionality to Linux.
  # https://asus-linux.org/manual/asusctl-manual/
  services = {
    asusd = {
      enable = lib.mkDefault true;
      enableUserService = lib.mkDefault true;
    };
  };

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault false;
    nvidiaSettings = lib.mkDefault true;
    prime = {
      amdgpuBusId = "PCI:54:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
