{ lib, config, ... }: {
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
  ];

  boot.kernelParams =
    [
      # There seems to be an issue with panel self-refresh (PSR) that
      # causes hangs for users.
      #
      # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
      # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
      "amdgpu.dcdebugmask=0x10"
    ];
}
