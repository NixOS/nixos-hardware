{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/amd.nix
  ];

  # 6.14 is the minimum recommended kernel, 6.15 has many useful changes, too
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.15") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  # Everything is updateable through fwupd
  services.fwupd.enable = true;

  # The following mitigations fix various graphics issues
  # See https://gist.github.com/lbrame/f9034b1a9fe4fc2d2835c5542acb170a#user-content-quick-version-apply-the-mitigations-i-am-personally-using
  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x410"
    "amdgpu.sg_display=0"
    "amdgpu.abmlevel=0"
  ];
}
