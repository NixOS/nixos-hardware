{ lib, pkgs, ... }:
{
  # Just set the console font, don't mess with the font settings
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  console.earlySetup = lib.mkDefault true;
}
