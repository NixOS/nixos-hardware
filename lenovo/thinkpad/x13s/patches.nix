{
  config,
  lib,
  pkgs,
  extendModules,
  ...
}:

let
  cfg = config.hardware.x13s.patches;

  # Only `enable` is read here, so this never touches the kernel version and is
  # safe to compute before the probe below.
  enabledNames = lib.attrNames (lib.filterAttrs (_: f: f.enable) cfg);

  # The kernel the system would build with this module inert. Forcing the whole
  # option empty in the child severs the feedback edge; that child then has
  # enabledNames == [], so this binding cannot recurse into itself. One probe
  # covers every feature.
  version =
    if enabledNames == [ ] then
      pkgs.linuxPackages.kernel.version
    else
      (extendModules {
        modules = [ { hardware.x13s.patches = lib.mkForce { }; } ];
      }).config.boot.kernelPackages.kernel.version;

  knownFeatures = lib.attrNames (
    lib.filterAttrs (_: t: t == "directory") (builtins.readDir ./patches)
  );

  # <numeric> optionally suffixed -rcN; compareVersions orders rc9 < rc10 by
  # maximal digit runs, and "rc" sorts below both "" and "0".
  baselineRe = "[0-9]+(\\.[0-9]+)*(-rc[0-9]+)?";

  evalFeature =
    name: feature:
    let
      root = ./patches + "/${name}";
      exists = builtins.pathExists root;
      entries = if exists then builtins.readDir root else { };

      isDir = n: builtins.hasAttr n entries && entries.${n} == "directory";
      baselines = lib.sort (a: b: lib.versions.compareVersions a b < 0) (
        lib.filter (n: isDir n && builtins.match baselineRe n != null) (lib.attrNames entries)
      );

      eligible = lib.filter (b: lib.versions.compareVersions b version <= 0) baselines;
      baseline = if eligible == [ ] then null else lib.last eligible;

      dir = if baseline == null then root else root + "/${baseline}";
      contents = if baseline == null then { } else builtins.readDir dir;

      isPatch =
        n: builtins.hasAttr n contents && contents.${n} != "directory" && lib.hasSuffix ".patch" n;

      # attrNames is alphabetical: 0001-…, 0002-… apply in order.
      files = lib.filter isPatch (lib.attrNames contents);

      retired = builtins.hasAttr ".retired" contents;
      noop = files == [ ];

      configFile = dir + "/config.nix";
      fromFile =
        if baseline != null && !noop && builtins.pathExists configFile then
          import configFile { inherit lib pkgs; }
        else
          { };
    in
    {
      inherit
        name
        feature
        root
        exists
        baselines
        baseline
        dir
        files
        retired
        noop
        ;
      # Symbols are suppressed for a retired series; a capability probe is not.
      extraConfig = lib.optionalAttrs (!noop) (fromFile.structuredExtraConfig or { });
      extraFeatures = fromFile.features or { };
    };

  enabled = map (n: evalFeature n cfg.${n}) enabledNames;

  claims = lib.concatMap (
    f:
    map (symbol: {
      inherit (f) name;
      inherit symbol;
    }) (lib.attrNames f.extraConfig)
  ) enabled;
  duplicateSymbols = lib.filterAttrs (_: v: lib.length v > 1) (lib.groupBy (c: c.symbol) claims);

  patchEntries =
    f:
    lib.optional (f.extraConfig != { } || f.extraFeatures != { }) {
      # `patch = null` is supported: the builder filters nulls out of the list
      # before use, precisely so config-only entries are possible.
      name = "x13s-${f.name}-${toString f.baseline}-config";
      patch = null;
      structuredExtraConfig = f.extraConfig;
      features = f.extraFeatures;
    }
    ++ lib.imap0 (_i: file: {
      name = "x13s-${f.name}-${lib.removeSuffix ".patch" file}";
      patch = f.dir + "/${file}";
    }) f.files;
in
{
  options.hardware.x13s.patches = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.enable = lib.mkEnableOption "this kernel patch series";
      }
    );
    default = { };
    description = ''
      Patch series to apply, keyed by feature. `hardware.x13s.patches.foo.enable`
      selects the greatest directory under `patches/foo/` that is not newer than
      `config.boot.kernelPackages.kernel.version`, and applies its `*.patch`
      files plus, if present, its `config.nix`.

      Set `boot.kernelPackages` as usual — patches attach to whatever kernel you
      choose. Because the baseline is selected from the resulting kernel, that
      kernel's version must be evaluable without `boot.kernelPatches`: a nixpkgs
      kernel package set, possibly `override`d or `extend`ed, not a hand-built
      attrset.
    '';
  };

  config = lib.mkIf (enabled != [ ]) {
    assertions =
      lib.map (n: {
        assertion = builtins.elem n knownFeatures;
        message = ''
          hardware.x13s.patches.${n}: no such feature.
          Known: ${lib.concatStringsSep ", " knownFeatures}.
          Create patches/${n}/ if this is a new series.
        '';
      }) enabledNames
      ++ lib.concatMap (
        f:
        lib.optional (f.exists && f.baseline == null) {
          assertion = false;
          message = ''
            hardware.x13s.patches.${f.name}: no baseline at or below kernel ${version}.
            Available: ${lib.concatStringsSep ", " f.baselines}.
          '';
        }
        ++ lib.optional (f.baseline != null) {
          assertion = !f.noop || f.retired;
          message = ''
            hardware.x13s.patches.${f.name}: ${toString f.dir} has no .patch files.
            Either the change merged upstream at or before ${f.baseline} — add a
            .retired marker naming the commit — or run git format-patch into it.
          '';
        }
      ) enabled
      ++ lib.mapAttrsToList (symbol: cs: {
        assertion = false;
        message = ''
          hardware.x13s.patches: CONFIG_${symbol} is defaulted by more than one
          enabled series (${lib.concatMapStringsSep ", " (c: c.name) cs}). nixpkgs
          merges each series as a separate module, so two lib.mkDefault
          definitions of one symbol still conflict — leave exactly one owner.
        '';
      }) duplicateSymbols;

    boot.kernelPatches = lib.concatMap patchEntries enabled;
  };
}
