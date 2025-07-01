{ lib, config, ... }:
{
  imports = [
    ../../.
  ];

  # Add Motorcomm YT6801 Driver if available
  boot.extraModulePackages =
    with config.boot;
    lib.lists.optional (kernelPackages ? yt6801) kernelPackages.yt6801;
}
