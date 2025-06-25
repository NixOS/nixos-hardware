{ lib, ... }:

with lib;

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # TSC is unstable
  boot.kernelParams = [
    "notsc"
    "trace_clock=local"
  ];

  hardware.enableRedistributableFirmware = mkDefault true;
}
