{
  self,
  privateInputs,
  system,
  pkgs,
}:
let
  # Hardware profile checks
  blackList = [
    # does import-from-derivation
    "toshiba-swanky"
    # uses custom nixpkgs config
    "raspberry-pi-2"
    # deprecated profiles
    "framework"
    "asus-zephyrus-ga402x"
    "lenovo-yoga-7-14ARH7"
  ];

  aarch64Systems = [
    "raspberry-pi-3"
    "raspberry-pi-4"
    "raspberry-pi-5"
    "nxp-imx8mp-evk"
    "nxp-imx8mq-evk"
    "nxp-imx8qm-mek"
    "nxp-imx93-evk"
    "ucm-imx95"
  ];

  matchArch =
    moduleName:
    if builtins.elem moduleName aarch64Systems then
      system == "aarch64-linux"
    else
      # TODO also add riscv64
      system == "x86_64-linux";

  modules = pkgs.lib.filterAttrs (
    name: _: !(builtins.elem name blackList || pkgs.lib.hasPrefix "common-" name) && matchArch name
  ) self.nixosModules;

  buildProfile = import ./build-profile.nix;

  unfreeNixpkgs = {
    config = {
      allowBroken = true;
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
    overlays = [ ];
    inherit system;
  };

  nixpkgsUnstable = import privateInputs.nixos-unstable-small unfreeNixpkgs;
  nixpkgsStable = import privateInputs.nixos-stable unfreeNixpkgs;

  # Build checks for both unstable and stable
  unstableChecks = pkgs.lib.mapAttrs' (
    name: module:
    pkgs.lib.nameValuePair "unstable-${name}" (buildProfile {
      pkgs = nixpkgsUnstable;
      profile = module;
    })
  ) modules;

  stableChecks = pkgs.lib.mapAttrs' (
    name: module:
    pkgs.lib.nameValuePair "stable-${name}" (buildProfile {
      pkgs = nixpkgsStable;
      profile = module;
    })
  ) modules;
in
unstableChecks // stableChecks
