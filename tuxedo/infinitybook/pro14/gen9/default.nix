{ lib, config, ... }:
{
  imports = [
    ../../.
  ];

  # Add Motorcomm YT6801 Driver if available and kernel version is below 7.0
  boot.extraModulePackages =
    with config.boot;
    lib.lists.optional (
      (lib.versionOlder kernelPackages.kernel.version "7.0") && (kernelPackages ? yt6801)
    ) kernelPackages.yt6801;
}
