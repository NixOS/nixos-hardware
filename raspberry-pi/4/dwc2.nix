{ lib, ... }:

{
  imports = [
    ../common/dwc2.nix
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "dwc2" ]
      [ "hardware" "raspberry-pi" "dwc2" ]
    )
  ];
}
