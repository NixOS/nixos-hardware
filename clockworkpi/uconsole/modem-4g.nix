# uConsole 4G Modem Support
#
# Optional module for the 4G modem expansion card.
# Provides uconsole-4g command to control modem power via GPIO.

{ lib, pkgs, config, ... }:

let
  cfg = config.hardware.clockworkpi-uconsole-cm4.modem-4g;

  uconsole-4g = pkgs.writeShellScriptBin "uconsole-4g" ''
    case "''${1:-}" in
      enable)
        echo "Powering on 4G modem..."
        ${pkgs.libraspberrypi}/bin/pinctrl set 24 op dh
        ${pkgs.libraspberrypi}/bin/pinctrl set 15 op dh
        sleep 5
        ${pkgs.libraspberrypi}/bin/pinctrl set 15 dl
        echo "Waiting for modem to initialize..."
        sleep 13
        echo "4G modem enabled. Use 'mmcli -L' to check status."
        ;;
      disable)
        echo "Powering off 4G modem..."
        ${pkgs.libraspberrypi}/bin/pinctrl set 24 op dl
        ${pkgs.libraspberrypi}/bin/pinctrl set 24 dh
        sleep 3
        ${pkgs.libraspberrypi}/bin/pinctrl set 24 dl
        sleep 20
        echo "4G modem disabled."
        ;;
      *)
        echo "Usage: uconsole-4g enable|disable"
        echo ""
        echo "Controls power to the 4G modem expansion card."
        echo "After enabling, use 'mmcli -L' to verify modem is detected."
        exit 1
        ;;
    esac
  '';
in
{
  options.hardware.clockworkpi-uconsole-cm4.modem-4g = {
    enable = lib.mkEnableOption "uConsole 4G modem support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ uconsole-4g ];
    networking.modemmanager.enable = true;
    networking.networkmanager.enable = true;
  };
}
