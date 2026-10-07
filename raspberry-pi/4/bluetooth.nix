{ lib, ... }:

{
  imports = [
    ../common/bluetooth.nix
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "bluetooth" "enable" ]
      [ "hardware" "raspberry-pi" "bluetooth" "enable" ]
    )
  ];
}
