{ pkgs, ... }:
{
  boot.kernelModules = [
    "ipmi_devintf"
    "ipmi_si"
  ];
  environment.systemPackages = [ pkgs.ipmitool ];
}
