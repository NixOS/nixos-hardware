{ config, lib, ... }:
{
  imports = [ ../. ];

  # The open source driver does not support Pascal GPUs.
  hardware.nvidia.open = false;
  hardware.nvidia.package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.legacy_580;
}
