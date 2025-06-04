{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf mkOption types;

  reloadBtusb = pkgs.writeShellApplication {
    name = "reload-btusb.sh";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.kmod
    ];
    text = ''
      # Reload Bluetooth after resuming from sleep.

      # Wait up-to 0.5 second for the module to be unloaded:
      # (It should never take this long)
      modprobe -r --wait 500 btusb

      # "btusb" sometimes seems to need a little bit of time to settle after unloading:
      sleep 0.2
      modprobe btusb
    '';
  };

  cfg = config.services.sleep-resume.bluetooth;
in
{
  options = {
    services.sleep-resume.bluetooth = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Reload Bluetooth after resuming from sleep";
      };
    };
  };

  config = mkIf cfg.enable {
    powerManagement.resumeCommands = "${reloadBtusb}/bin/reload-btusb.sh";
  };
}
