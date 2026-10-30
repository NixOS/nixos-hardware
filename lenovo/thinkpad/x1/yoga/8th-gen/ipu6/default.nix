{ lib, ... }:
{
  imports = [ ../. ];

  hardware.ipu6 = {
    enable = lib.mkDefault true;
    platform = lib.mkDefault "ipu6ep";
  };
}
