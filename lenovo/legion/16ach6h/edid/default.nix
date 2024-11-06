{
  pkgs,
  lib,
  options,
  ...
}:

let
  # This file was obtained from the display while "DDG" mode was enabled.
  chip_edid = pkgs.runCommandNoCC "chip_edid" { } ''
    mkdir -p $out/lib/firmware/edid
    cp ${./16ach6h.bin} $out/lib/firmware/edid/16ach6h.bin
  '';
in
{
  config = lib.optionalAttrs (options ? hardware.display) {
    hardware.display = {
      edid.packages = [ chip_edid ];

      outputs = {
        # For some reason, the internal display is sometimes eDP-1, and sometimes it's eDP-2
        "eDP-1".edid = "16ach6h.bin";
        "eDP-2".edid = "16ach6h.bin";
      };
    };

    # This fails at the moment, https://github.com/NixOS/nixos-hardware/issues/795
    # Extra refresh rates seem to work regardless
    # boot.initrd.extraFiles."lib/firmware/edid/16ach6h.bin".source = pkgs.runCommandLocal "chip_edid" { } "cp ${./16ach6h.bin} $out";
  };
}
