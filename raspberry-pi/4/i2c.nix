{ lib, ... }:

{
  imports = [
    ../common/i2c.nix
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "i2c0" "enable" ]
      [ "hardware" "raspberry-pi" "i2c0" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "i2c0" "frequency" ]
      [ "hardware" "raspberry-pi" "i2c0" "frequency" ]
    )
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "i2c1" "enable" ]
      [ "hardware" "raspberry-pi" "i2c1" "enable" ]
    )
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "i2c1" "frequency" ]
      [ "hardware" "raspberry-pi" "i2c1" "frequency" ]
    )
  ];
}
