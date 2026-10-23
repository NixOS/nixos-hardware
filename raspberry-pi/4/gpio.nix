{ lib, ... }:

{
  imports = [
    ../common/gpio.nix
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "gpio" ]
      [ "hardware" "raspberry-pi" "gpio" ]
    )
  ];
}
