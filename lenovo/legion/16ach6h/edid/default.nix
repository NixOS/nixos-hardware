{ pkgs, ... }:

let
  # This file was obtained from the display while "DDG" mode was enabled.
  chip_edid = pkgs.runCommandNoCC "chip_edid" { } ''
    mkdir -p $out/lib/firmware/edid
    cp ${./16ach6h.bin} $out/lib/firmware/edid/16ach6h.bin
  '';
in
{
  hardware.firmware = [ chip_edid ];

  boot.kernelParams = [ "drm.edid_firmware=edid/16ach6h.bin" ];
  # This fails at the moment, https://github.com/NixOS/nixos-hardware/issues/795
  # Extra refresh rates seem to work regardless
  # boot.initrd.extraFiles."lib/firmware/edid/16ach6h.bin".source = pkgs.runCommandLocal "chip_edid" { } "cp ${./16ach6h.bin} $out";
}
