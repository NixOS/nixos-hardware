# config.txt generation module for Raspberry Pi
#
# Generates config.txt from structured Nix options. The type system models
# config.txt as nested attrs: each nesting level adds a conditional filter,
# and leaves are config values. Repeated keys (dtparam, dtoverlay, gpio)
# are supported via lists.
#
# Based on work from nvmd/nixos-raspberrypi (MIT License) and rendering
# approach suggested by @quentinmit. Follows RFC 42.
#
# Reference: https://www.raspberrypi.com/documentation/computers/config_txt.html

{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hardware.raspberry-pi.configtxt;

  mkValueString =
    v:
    if builtins.isInt v then
      toString v
    else if builtins.isString v then
      v
    else if true == v then
      "1"
    else if false == v then
      "0"
    else
      builtins.abort "config.txt: unsupported value type: ${builtins.typeOf v}";

  mkKeyValue = lib.generators.mkKeyValueDefault { inherit mkValueString; } "=";

  # Recursively flatten nested attrs into a list of { conditionals, name, value } records.
  # Each nesting level (except the leaf) is a conditional filter.
  # "all" filters are omitted from the conditionals list since they reset state.
  # null values are filtered out, allowing `mkForce null` to remove defaults.
  recurse =
    path: value:
    if value == null then
      [ ]
    else if builtins.isAttrs value && !(builtins.isList value) && !(value ? _type) then
      lib.flatten (lib.mapAttrsToList (name: recurse ([ name ] ++ path)) value)
    else
      {
        conditionals = lib.sort builtins.lessThan (lib.filter (k: k != "all") (lib.tail path));
        name = lib.head path;
        inherit value;
      };

  # Group flattened items by their conditional filter set, then render.
  groupItems =
    items:
    lib.mapAttrsToList (groupJSON: groupItems: {
      conditionals = builtins.fromJSON groupJSON;
      items = builtins.listToAttrs groupItems;
    }) (builtins.groupBy (x: builtins.toJSON x.conditionals) items);

  mkGroup =
    group:
    lib.concatMapStrings (k: "[${k}]\n") group.conditionals
    + lib.generators.toKeyValue {
      inherit mkKeyValue;
      listsAsDuplicateKeys = true;
    } group.items;

  toConfigTxt =
    attrs:
    let
      groups = lib.sort (a: b: a.conditionals < b.conditionals) (
        groupItems (lib.flatten (recurse [ ] attrs))
      );
    in
    lib.concatMapStringsSep "\n[all]\n" mkGroup groups;

in
{
  options.hardware.raspberry-pi.configtxt = {
    settings = lib.mkOption {
      type =
        with lib.types;
        let
          atom = nullOr (oneOf [
            str
            int
            bool
          ]);
          molecule = oneOf [
            atom
            (listOf atom)
            (attrsOf molecule)
          ];
        in
        attrsOf molecule;
      default = { };
      description = ''
        Structured configuration for the Raspberry Pi `config.txt` file.

        Top-level keys are conditional filter sections (`all`, `pi4`, `pi5`,
        `cm4`, etc.). Nesting adds stacked conditional filters. Leaves are
        config values rendered as `key=value`. Lists produce repeated keys.

        Booleans render as `0`/`1`. Use `null` with `mkForce` to remove a
        default.

        See <https://www.raspberrypi.com/documentation/computers/config_txt.html>
      '';
      example = lib.literalExpression ''
        {
          all = {
            arm_boost = true;
            disable_overscan = true;
            dtparam = [ "audio=on" ];
            dtoverlay = [ "vc4-kms-v3d" ];
          };
          pi5.arm_freq = 2400;
          cm4.otg_mode = true;
        }
      '';
    };

    file = lib.mkOption {
      type = lib.types.path;
      default = pkgs.writeText "config.txt" (toConfigTxt cfg.settings);
      defaultText = lib.literalExpression ''pkgs.writeText "config.txt" (generated from settings)'';
      description = ''
        Path to the generated config.txt file. Defaults to the rendered output
        of `settings`, but can be overridden to supply a custom config.txt.
      '';
    };
  };
}
