{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.raspberry-pi."4".i2c0;
  inherit (import ./overlay.nix) simple-pi4-overlay;
in
{
  options.hardware = {
    raspberry-pi."4".i2c0 = {
      enable = lib.mkEnableOption ''
        Turn on the VideoCore I2C bus (maps to /dev/i2c-22) and enable access from the i2c group.
        After a reboot, i2c-tools (e.g. i2cdetect -F 22) should work for root or any user in i2c.
       '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      i2c.enable = lib.mkDefault true;
      deviceTree = {
        overlays = [ (simple-pi4-overlay { target = "i2c0if"; status = "okay"; }) ];
      };
    };
  };
}
