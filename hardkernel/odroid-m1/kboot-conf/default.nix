{ config, lib, pkgs, ... }:

let
  cfg = config.boot.loader.kboot-conf;

  # The builder used to write during system activation
  builder = pkgs.replaceVarsWith {
    src = ./generate-kboot-conf.sh;
    replacements = {
      bash = pkgs.bash;
      path = lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnused
        pkgs.gnugrep
      ];
    };
    name = "system-activation-generate-kboot-conf";
    isExecutable = true;
  };
  # The builder exposed in populateCmd, which runs when building the sdImage
  populateBuilder = pkgs.buildPackages.replaceVarsWith {
    src = ./generate-kboot-conf.sh;
    replacements = {
      bash = pkgs.buildPackages.bash;
      path = lib.makeBinPath [
        pkgs.buildPackages.coreutils
        pkgs.buildPackages.gnused
        pkgs.buildPackages.gnugrep
      ];
    };
    name = "build-image-generate-kboot-conf";
    isExecutable = true;
  };
in
{
  options = {
    boot.loader.kboot-conf = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to create petitboot-compatible /kboot.conf
        '';
      };
      configurationLimit = lib.mkOption {
        default = 10;
        example = 5;
        type = lib.types.int;
        description = ''
          Maximum number of configurations in the generated kboot.conf.
        '';
      };
      populateCmd = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          Contains the builder command used to populate an image,
          honoring all options except the <literal>-c &lt;path-to-default-configuration&gt;</literal>
          argument.
          Useful to have for sdImage.populateRootCommands
        '';
      };
    };
  };
  config = let
    args = "-g ${toString cfg.configurationLimit} -n ${config.hardware.deviceTree.name}";
  in
    lib.mkIf cfg.enable {
      system.build.installBootLoader = lib.mkForce "${builder} ${args} -c";
      system.boot.loader.id = "kboot-conf";
      boot.loader.kboot-conf.populateCmd = "${populateBuilder} ${args}";
    };
}
