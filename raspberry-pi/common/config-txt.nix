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

  overlayType = lib.types.submodule {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Firmware overlay name without the `.dtbo` suffix.";
      };

      params = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Ordered parameters applied to this overlay.";
      };

      filters = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Ordered config.txt conditional filters without brackets.";
      };
    };
  };

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

  renderOverlay =
    overlay:
    lib.concatStringsSep "\n" (
      [ "[all]" ]
      ++ map (filter: "[${filter}]") overlay.filters
      ++ [ "dtoverlay=${overlay.name}" ]
      ++ map (param: "dtparam=${param}") overlay.params
      ++ [ "dtoverlay=" ]
    );

  # Render settings first, followed by ordered overlays. The final [all] clears
  # any filters left by the last overlay.
  settingsConfig = toConfigTxt cfg.settings;
  overlayConfig = lib.pipe cfg.overlays [
    (map renderOverlay)
    (overlays: overlays ++ [ "[all]" ])
    (lib.concatStringsSep "\n")
    (text: text + "\n")
  ];
  generatedConfig =
    settingsConfig
    + lib.optionalString (cfg.overlays != [ ]) (
      lib.optionalString (settingsConfig != "") "\n" + overlayConfig
    );
  generatedFile = pkgs.writeText "config.txt" generatedConfig;

  # Collect invalid values so assertion messages can show the original input.
  hasLineBreak = value: lib.hasInfix "\n" value || lib.hasInfix "\r" value;
  validOverlayName =
    name:
    name != ""
    && builtins.match "^[A-Za-z0-9][A-Za-z0-9._+-]*$" name != null
    && !lib.hasSuffix ".dtbo" name;
  validFilter =
    filter:
    filter != "" && !hasLineBreak filter && !lib.hasInfix "[" filter && !lib.hasInfix "]" filter;

  invalidNames = lib.pipe cfg.overlays [
    (lib.filter (overlay: !validOverlayName overlay.name))
    (map (overlay: overlay.name))
  ];
  invalidFilters = lib.pipe cfg.overlays [
    (lib.concatMap (overlay: overlay.filters))
    (lib.filter (filter: !validFilter filter))
  ];
  invalidParams = lib.pipe cfg.overlays [
    (lib.concatMap (overlay: overlay.params))
    (lib.filter hasLineBreak)
  ];

  # Raspberry Pi firmware rejects config.txt lines longer than 98 characters.
  longLines = lib.pipe generatedConfig [
    (lib.splitString "\n")
    (lib.filter (line: builtins.stringLength line > 98))
  ];

  # A custom file bypasses generatedConfig. It cannot be combined with ordered
  # overlays, and its lines are not validated here.
  usesGeneratedFile = toString cfg.file == toString generatedFile;

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
        attrsOf molecule // { description = "config.txt setting type"; };
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

    overlays = lib.mkOption {
      type = lib.types.listOf overlayType;
      default = [ ];
      description = ''
        Ordered Raspberry Pi firmware overlay applications.

        Use this option when `dtoverlay` and `dtparam` lines must be
        interleaved. {option}`settings` groups values by key, so it can render
        simple overlays with comma-separated parameters, but not an overlay
        followed by its scoped parameters and then another overlay.

        Entries are rendered after {option}`settings`, in list order. Each one
        writes its filters, `dtoverlay`, and `dtparam` values, then resets the
        overlay scope. The example renders as:

        ```ini
        [all]
        [pi4]
        dtoverlay=dwc2
        dtparam=dr_mode=host
        dtoverlay=
        [all]
        [pi4]
        dtoverlay=gpio-fan
        dtparam=gpiopin=14
        dtparam=temp=80000
        dtoverlay=
        [all]
        ```
      '';
      example = lib.literalExpression ''
        [
          {
            name = "dwc2";
            params = [ "dr_mode=host" ];
            filters = [ "pi4" ];
          }
          {
            name = "gpio-fan";
            params = [
              "gpiopin=14"
              "temp=80000"
            ];
            filters = [ "pi4" ];
          }
        ]
      '';
    };

    file = lib.mkOption {
      type = lib.types.path;
      default = generatedFile;
      defaultText = lib.literalExpression ''pkgs.writeText "config.txt" (generated from settings and overlays)'';
      description = ''
        Path to the generated config.txt file. Defaults to the rendered output
        of `settings` and `overlays`, but can be overridden to supply a custom
        config.txt when `overlays` is empty.
      '';
    };
  };

  config.assertions = [
    {
      assertion = invalidNames == [ ];
      message = "Raspberry Pi config.txt has invalid overlay names: ${builtins.toJSON invalidNames}";
    }
    {
      assertion = invalidFilters == [ ];
      message = "Raspberry Pi config.txt has invalid overlay filters: ${builtins.toJSON invalidFilters}";
    }
    {
      assertion = invalidParams == [ ];
      message = "Raspberry Pi config.txt overlay parameters contain line breaks: ${builtins.toJSON invalidParams}";
    }
    {
      assertion = cfg.overlays == [ ] || usesGeneratedFile;
      message = "Raspberry Pi config.txt overlays cannot be used with a custom configtxt.file.";
    }
    {
      assertion = !usesGeneratedFile || longLines == [ ];
      message = "Raspberry Pi config.txt lines exceed the 98-character limit: ${builtins.toJSON longLines}";
    }
  ];
}
