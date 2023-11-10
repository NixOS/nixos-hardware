{ lib, pkgs, ... }: {
  imports = [
    ../common
    ../common/amd.nix
  ];

  # Newer kernel is better for amdgpu driver updates
  # Requires at least 5.16 for working wi-fi and bluetooth (RZ616, kmod mt7922):
  # https://wireless.wiki.kernel.org/en/users/drivers/mediatek
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.1") (lib.mkDefault pkgs.linuxPackages_latest);
}
