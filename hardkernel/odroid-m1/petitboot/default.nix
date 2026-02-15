{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.boot.loader.petitboot;
  args = "-g ${toString cfg.configurationLimit} -n ${config.hardware.deviceTree.name}";

  # The installer used when running nixos-rebuild switch or similar
  installer = pkgs.replaceVarsWith {
    src = ./install-petitboot.sh;
    replacements = {
      bash = pkgs.bash;
      path = lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnused
        pkgs.gnugrep
      ];
    };
    name = "install-petitboot";
    isExecutable = true;
  };
  # The installer used to write to SD card images
  sdImageInstaller = pkgs.buildPackages.replaceVarsWith {
    src = ./install-petitboot.sh;
    replacements = {
      bash = pkgs.buildPackages.bash;
      path = lib.makeBinPath [
        pkgs.buildPackages.coreutils
        pkgs.buildPackages.gnused
        pkgs.buildPackages.gnugrep
      ];
    };
    name = "install-petitboot-sd-image";
    isExecutable = true;
  };
in
{
  options = {
    boot.loader.petitboot = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable the Petitboot bootloader.
        '';
      };

      configurationLimit = lib.mkOption {
        default = 10;
        example = 5;
        type = lib.types.int;
        description = ''
          Maximum number of configurations to display when booting.
        '';
      };

      populateCmd = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        description = ''
          Contains the script used to populate petitboot when building an image.
          Primarily used for sdImage.populateRootCommands.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    system.build.installBootLoader = lib.mkForce "${installer} ${args} -c";
    system.boot.loader.id = "petitboot";
    boot.loader.petitboot.populateCmd = "${sdImageInstaller} ${args}";
  };
}
