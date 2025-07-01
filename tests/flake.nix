{
  description = "Test flake for nixos-hardware";

  inputs = {
    nixos-unstable-small.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable-small";
    nixos-stable.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-25.05";
    # override in the test
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixos-unstable-small";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixos-unstable-small";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "riscv64-linux"
      ];
      perSystem =
        {
          system,
          lib,
          pkgs,
          ...
        }:
        let
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

          # There are more, but for those we need to force it.
          # In future we should probably already define it in our module.
          aarch64Systems = [
            "raspberry-pi-3"
            "raspberry-pi-4"
            "raspberry-pi-5"
          ];

          matchArch =
            moduleName:
            if builtins.elem moduleName aarch64Systems then
              pkgs.hostPlatform.system == "aarch64-linux"
            else
              # TODO also add riscv64
              pkgs.hostPlatform.system == "x86_64-linux";

          modules = lib.filterAttrs (
            name: _: !(builtins.elem name blackList || lib.hasPrefix "common-" name) && matchArch name
          ) inputs.nixos-hardware.nixosModules;
          buildProfile = import ./build-profile.nix;

          unfreeNixpkgs =
            importPath:
            import importPath {
              config = {
                allowBroken = true;
                allowUnfree = true;
                nvidia.acceptLicense = true;
              };
              overlays = [ ];
              inherit system;
            };
          nixpkgsUnstable = unfreeNixpkgs inputs.nixos-unstable-small;
          nixpkgsStable = unfreeNixpkgs inputs.nixos-stable;

          checksForNixpkgs =
            channel: nixpkgs:
            lib.mapAttrs' (
              name: module:
              lib.nameValuePair "${channel}-${name}" (buildProfile {
                pkgs = nixpkgs;
                profile = module;
              })
            ) modules;
        in
        {
          _module.args.pkgs = nixpkgsUnstable;

          treefmt = {
            flakeCheck = pkgs.hostPlatform.system != "riscv64-linux";
            projectRootFile = "COPYING";
            programs = {
              deadnix = {
                enable = true;
                no-lambda-pattern-names = true;
              };
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };
            };
            settings = {
              on-unmatched = "info";
            };
          };

          checks =
            checksForNixpkgs "nixos-unstable" nixpkgsUnstable
            // checksForNixpkgs "nixos-stable" nixpkgsStable;
          packages.run = pkgs.writeShellScriptBin "run.py" ''
            #!${pkgs.bash}/bin/bash
            export PATH=${
              lib.makeBinPath [
                pkgs.nix-eval-jobs
                pkgs.nix-eval-jobs.nix
              ]
            }
            exec ${pkgs.python3.interpreter} ${./.}/run.py --nixos-hardware "$@"
          '';
        };
    };
}
