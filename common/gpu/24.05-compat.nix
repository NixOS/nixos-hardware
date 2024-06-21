{
  config,
  lib,
  ...
}:
{
  # Backward-compat for 24.05, can be removed after we drop 24.05 support
  options = {
    hardware.graphics = lib.optionalAttrs (lib.versionOlder lib.version "24.11pre") {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      enable32Bit = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
      };
      extraPackages32 = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
      };
    };
  };

  config = {
    hardware.opengl = lib.optionalAttrs (lib.versionOlder lib.version "24.11pre") {
      enable = config.hardware.graphics.enable;
      driSupport32Bit = config.hardware.graphics.enable32Bit;
      extraPackages = config.hardware.graphics.extraPackages;
      extraPackages32 = config.hardware.graphics.extraPackages32;
    };
  };
}
