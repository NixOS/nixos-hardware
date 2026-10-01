{ lib, config, ... }:
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
  ];

  boot.kernelParams = [
    # Disable PSR, PSR-SU, and Panel Replay to fix display hangs and corruption.
    # Panel Replay requires PSR/PSR-SU to also be disabled to avoid issues.
    #
    # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
    # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
    # https://community.frame.work/t/workaround-graphical-corruption-with-780m-igpu/61750
    # https://gist.github.com/lbrame/f9034b1a9fe4fc2d2835c5542acb170a
    "amdgpu.dcdebugmask=0x410"
  ]
  # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
  ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") [
    "rtc_cmos.use_acpi_alarm=1"
  ];

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;
}
