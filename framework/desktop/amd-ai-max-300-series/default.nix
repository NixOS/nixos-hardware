{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/ssd
    ../../framework-tool.nix
  ];

  # 6.14 and above have good GPU support
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.14") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}
