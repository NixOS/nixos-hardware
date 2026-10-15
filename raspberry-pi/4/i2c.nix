{ lib, ... }:

{
  imports = [
    ../common/i2c.nix
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "i2c0" ]
      [ "hardware" "raspberry-pi" "i2c0" ]
    )
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "i2c1" ]
      [ "hardware" "raspberry-pi" "i2c1" ]
    )
  ];
}
