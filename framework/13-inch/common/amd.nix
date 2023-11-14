{ lib, ... }: {
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
  ];

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;
}
