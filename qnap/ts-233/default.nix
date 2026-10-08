{ lib, ... }:

{
  imports = [ ../ts-x33 ];

  hardware.deviceTree.name = lib.mkDefault "rockchip/rk3568-qnap-ts233.dtb";
}
