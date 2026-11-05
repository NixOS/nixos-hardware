{ lib, ... }:

{
  imports = [
    ../common/audio.nix
    (lib.mkRenamedOptionModule
      [ "hardware" "raspberry-pi" "4" "audio" "enable" ]
      [ "hardware" "raspberry-pi" "audio" "enable" ]
    )
  ];
}
