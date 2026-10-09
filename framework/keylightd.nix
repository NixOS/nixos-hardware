{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.hardware.keylightd;
  rustPlatform = pkgs.rustPlatform;
  source = pkgs.fetchFromGitHub {
    owner = "jonas-schievink";
    repo = "keylightd";
    rev = "b7b17e3ac9402cbaac9ca9192c33755f6e8394a6"; # PR#3 that fixes build
    sha256 = "sha256-QFsbd3npKQkiNuv9xxU0erKClbDACiu8fg7NNecsqz8=";
  };
  cargoToml = builtins.fromTOML (builtins.readFile "${source}/Cargo.toml");
  package = rustPlatform.buildRustPackage {
    pname = "keylightd";
    version = cargoToml.package.version;
    src = source;
    cargoLock = {
      lockFile = "${source}/Cargo.lock";
    };
    buildInputs = with pkgs; [ libevdev ];
    meta = with lib; {
      description = "A keyboard backlight daemon for Framework laptops";
      license = licenses.bsd0;
      platforms = platforms.linux;
      mainProgram = "keylightd";
    };
  };

in
{
  options = with lib; {
    services.hardware.keylightd = {
      enable = mkEnableOption "keylightd";
      package = mkOption {
        type = types.package;
        default = package;
        description = "The keylightd package to use.";
      };
      brightness = mkOption {
        type = types.int;
        default = 30;
        description = "The default brightness of the keyboard backlight (0-100).";
      };
      timeout = mkOption {
        type = types.int;
        default = 10;
        description = "The timeout in seconds after which the keyboard backlight will turn off.";
      };
      powerLight = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to control the power light on the keyboard.";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.keylightd = {
      description = "Keyboard backlight daemon for Framework laptops";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart =
          lib.getExe cfg.package
          + " --brightness ${toString cfg.brightness}"
          + " --timeout ${toString cfg.timeout}"
          + lib.optionalString cfg.powerLight " --power";
        Restart = "on-failure";
        RestartSec = "1s";
      };
    };
  };
}
