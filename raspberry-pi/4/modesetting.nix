{ lib, ... }:

{
  imports = [
    ../common/modesetting.nix
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "fkms-3d" "enable" ]
      [ "hardware" "raspberry-pi" "fkms-3d" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "fkms-3d" "cma" ]
      [ "hardware" "raspberry-pi" "fkms-3d" "cma" ]
    )
  ];
}
