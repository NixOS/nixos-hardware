{ lib, ... }:

{
  imports = [
    ../common
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "fkms-3d" ]
      [ "hardware" "raspberry-pi" "fkms-3d" ]
    )
  ];
}
