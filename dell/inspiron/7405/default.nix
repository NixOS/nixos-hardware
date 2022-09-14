{ lib, ... }:

with lib;

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # TSC is unstable
  boot.kernelParams = [ "notsc" "trace_clock=local" ];

  hardware.enableRedistributableFirmware = mkDefault true;
}
