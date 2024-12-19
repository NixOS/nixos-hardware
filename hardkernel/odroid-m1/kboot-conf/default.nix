{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.boot.loader.kboot-conf;

  # The builder used to write during system activation
  builder = pkgs.substituteAll {
    src = ./generate-kboot-conf.sh;
    isExecutable = true;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    inherit (pkgs) bash;
  };
  # The builder exposed in populateCmd, which runs on the build architecture
  populateBuilder = pkgs.buildPackages.substituteAll {
    src = ./generate-kboot-conf.sh;
    isExecutable = true;
    path = with pkgs.buildPackages; [coreutils gnused gnugrep];
    inherit (pkgs.buildPackages) bash;
  };
in {
  options = {
    boot.loader.kboot-conf = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to create petitboot-compatible /kboot.conf
        '';
      };
      configurationLimit = mkOption {
        default = 10;
        example = 5;
        type = types.int;
        description = ''
          Maximum number of configurations in the generated kboot.conf.
        '';
      };
      populateCmd = mkOption {
        type = types.str;
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
    mkIf cfg.enable {
      system.build.installBootLoader = lib.mkForce "${builder} ${args} -c";
      system.boot.loader.id = "kboot-conf";
      boot.loader.kboot-conf.populateCmd = "${populateBuilder} ${args}";
    };
}
