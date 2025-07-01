{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkOption types;

  reloadDesignware = pkgs.writeShellApplication {
    name = "reload-i2c-designware.sh";
    runtimeInputs = [ pkgs.kmod ];
    text = ''
      # Reload the i2c Designware driver after resuming from sleep.

      # Wait up-to 0.5 second for each module to be unloaded:
      # (It should never take this long)
      modprobe -r --wait 500 i2c_designware_platform
      modprobe -r --wait 500 i2c_designware_core
      modprobe -r --wait 500 i2c_hid_acpi
      modprobe -r --wait 500 i2c_hid

      # Should reload the module dependencies automatically:
      modprobe i2c_designware_platform
    '';
  };

  cfg = config.services.sleep-resume.i2c-designware;
in
{
  options = {
    services.sleep-resume.i2c-designware = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Reload the i2c_designware driver after resuming from sleep.";
      };
    };
  };

  config = mkIf cfg.enable {
    powerManagement.resumeCommands = "${reloadDesignware}/bin/reload-i2c-designware.sh";
  };
}
