# config.txt generation module for Raspberry Pi
#
# This module renders config.txt from structured Nix options. The type models
# config.txt as nested attrs: each level of nesting adds a conditional filter,
# and the leaves are config values. Lists produce repeated keys for dtparam,
# dtoverlay and gpio.
#
# Device tree overlays have their own option. A dtparam applies to the overlay
# that loaded last, and values grouped by key cannot express that order.
# Overlays render after settings, so base parameters apply first.
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
      abort "config.txt: unsupported value type: ${builtins.typeOf v}";

  mkKeyValue = lib.generators.mkKeyValueDefault { inherit mkValueString; } "=";

  # Overlay parameters use on/off for booleans. This follows the Raspberry Pi
  # documentation and the overlay README. Plain settings keep 1/0.
  mkParamValue = v: if builtins.isBool v then (if v then "on" else "off") else mkValueString v;

  # An "all" filter resets state rather than narrowing it, so it never has to be
  # recorded. The rest are sorted, which makes two paths that stack the same
  # filters in a different order compare equal.
  mkConditionals =
    path:
    lib.pipe path [
      (lib.filter (k: k != "all"))
      (lib.sort builtins.lessThan)
    ];

  # Flatten settings into { conditionals, items } groups, one group per leaf.
  # Every level above the leaf is a conditional filter. A null value drops out,
  # so `mkForce null` removes a default.
  recurseSettings =
    path: value:
    if value == null then
      [ ]
    else if !(builtins.isAttrs value) then
      [
        {
          conditionals = mkConditionals (lib.init path);
          items = [
            {
              name = lib.last path;
              inherit value;
            }
          ];
        }
      ]
    else
      lib.pipe value [
        (lib.mapAttrsToList (name: recurseSettings (path ++ [ name ])))
        lib.concatLists
      ];

  # The same flattening for overlays. Here the leaf is already the ordered
  # overlay list for that filter set, so every level of nesting is a filter.
  recurseOverlays =
    path: value:
    if value == null then
      [ ]
    else if builtins.isList value then
      [
        {
          conditionals = mkConditionals path;
          items = value;
        }
      ]
    else
      lib.pipe value [
        (lib.mapAttrsToList (name: recurseOverlays (path ++ [ name ])))
        lib.concatLists
      ];

  # Merge groups that share a filter set. Two paths can reduce to the same set
  # (all.pi4 and pi4.all both yield [ "pi4" ]), so merging is needed even though
  # each recursion returns one group per leaf.
  #
  # Sorting first puts equal sets next to each other, so a single pass coalesces
  # them. Folding from the right lets each step prepend, which keeps the result
  # in order without a second pass. builtins.sort is stable, so items keep their
  # original relative order, which overlays depend on.
  #
  # The sort is not redundant with mkConditionals, which only orders the filters
  # within one group. Groups arrive in attrs walk order, driven by the raw names
  # before "all" is stripped, so all.z.foo walks before b.bar.
  groupByConditionals =
    groups:
    lib.pipe groups [
      (lib.sort (a: b: a.conditionals < b.conditionals))
      (lib.foldr (
        group: merged:
        let
          next = lib.head merged;
        in
        if merged != [ ] && next.conditionals == group.conditionals then
          [ (group // { items = group.items ++ next.items; }) ] ++ lib.tail merged
        else
          [ group ] ++ merged
      ) [ ])
    ];

  # Every group opens with [all] plus its own filters. For settings that leading
  # [all] is only a reset. For overlays it is required: a bare `dtoverlay=` ends
  # overlay scope but leaves the conditional filters set, and only [all] clears
  # them.
  mkFilterHeader = conditionals: lib.concatMapStrings (f: "[${f}]\n") ([ "all" ] ++ conditionals);

  renderSettingsGroup =
    group:
    mkFilterHeader group.conditionals
    + lib.pipe group.items [
      builtins.listToAttrs
      (lib.generators.toKeyValue {
        inherit mkKeyValue;
        listsAsDuplicateKeys = true;
      })
    ];

  # Each entry ends with a bare `dtoverlay=`. This terminator closes the parameter
  # scope of that overlay, so a later dtparam applies to the base DTB instead. A
  # terminator must never come first in the file, where it means "load no HAT
  # overlay". Settings render first, and every terminator here follows a
  # dtoverlay=<name>, so no terminator comes first today. A change to the section
  # order can break this guarantee.
  renderOverlayGroup =
    group:
    mkFilterHeader group.conditionals
    + lib.concatMapStrings (
      entry:
      let
        name = lib.head (lib.attrNames entry);
      in
      lib.concatMapStrings (line: line + "\n") (
        [ "dtoverlay=${name}" ]
        ++ lib.pipe entry.${name} [
          (lib.filterAttrs (_: v: v != null))
          (lib.mapAttrsToList (p: v: "dtparam=${p}=${mkParamValue v}"))
        ]
        ++ [ "dtoverlay=" ]
      )
    ) group.items;

  render =
    conf: renderSectionFunc: recurseFunc:
    lib.pipe conf [
      (recurseFunc [ ])
      groupByConditionals
      (map renderSectionFunc)
      (lib.concatStringsSep "\n")
    ];

  # Settings render first, so base DT parameters apply before any overlay loads.
  # The overlay groups follow. A blank line separates the two sections, and the
  # filter keeps that separator from becoming a stray leading or trailing line
  # when one of the two is empty.
  generatedConfig =
    lib.pipe
      [
        (render cfg.settings renderSettingsGroup recurseSettings)
        (render cfg.deviceTreeOverlays renderOverlayGroup recurseOverlays)
      ]
      [
        (lib.filter (section: section != ""))
        (lib.concatStringsSep "\n")
      ];
in
{
  options.hardware.raspberry-pi.configtxt = {
    settings = lib.mkOption {
      type =
        let
          inherit (lib.types)
            attrsOf
            bool
            int
            listOf
            nullOr
            oneOf
            str
            ;
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

        Set device tree overlays through {option}`deviceTreeOverlays` rather
        than a `dtoverlay` key here. A `dtoverlay` written here gets no
        terminator, so it captures every `dtparam` that follows it.

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

    deviceTreeOverlays = lib.mkOption {
      type =
        let
          inherit (lib.types)
            addCheck
            attrsOf
            bool
            int
            listOf
            nullOr
            oneOf
            str
            ;
          params = attrsOf (
            nullOr (oneOf [
              str
              int
              bool
            ])
          );
          # Each list element names one overlay. Without this check one element
          # can name two overlays, as in [ { a = { }; b = { }; } ]. Nix sorts
          # attribute names, so the order between them is lost.
          entry = addCheck (attrsOf params) (e: builtins.length (builtins.attrNames e) == 1) // {
            description = "attribute set naming exactly one overlay, mapped to its parameters";
          };
          node = oneOf [
            (listOf entry)
            (attrsOf node)
          ];
        in
        attrsOf node // { description = "config.txt device tree overlay type"; };
      default = { };
      description = ''
        Device tree overlays for the Raspberry Pi firmware, rendered in list
        order.

        Keys are conditional filter sections and nest exactly like
        {option}`settings`. The leaf is an ordered list, and each element names
        one overlay mapped to its parameters.

        Use this instead of a `dtoverlay` key in {option}`settings` when an
        overlay has parameters. `settings` groups values by key and cannot keep
        an overlay next to the `dtparam` lines that belong to it. A parameter
        stays in scope only until the next overlay loads.

        Each parameter becomes its own `dtparam` line rather than an addition to
        the `dtoverlay` line, which keeps them clear of the 98-character limit
        on `config.txt` lines. Booleans render as `on` or `off`. Use `null` with
        `mkForce` to remove a default.

        Overlays render after {option}`settings`, so base device tree parameters
        set there apply before any overlay loads. The example renders as:

        ```ini
        [all]
        [pi4]
        dtoverlay=dwc2
        dtparam=dr_mode=host
        dtoverlay=
        dtoverlay=gpio-fan
        dtparam=gpiopin=14
        dtparam=temp=80000
        dtoverlay=
        ```
      '';
      example = lib.literalExpression ''
        {
          pi4 = [
            { dwc2.dr_mode = "host"; }
            {
              gpio-fan = {
                gpiopin = 14;
                temp = 80000;
              };
            }
          ];
        }
      '';
    };

    file = lib.mkOption {
      type = lib.types.path;
      default = pkgs.writeText "config.txt" generatedConfig;
      defaultText = lib.literalExpression ''pkgs.writeText "config.txt" (generated from settings and deviceTreeOverlays)'';
      description = ''
        Path to the config.txt file to install. Defaults to the rendered output
        of {option}`settings` and {option}`deviceTreeOverlays`. A custom file
        replaces that output, so the module then ignores both options.
      '';
    };
  };
}
