{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.hardware.orange-pi."5-max".graphics;
  mali-firmware = pkgs.callPackage ./mali-firmware.nix { };
in
{
  options.hardware = {
    orange-pi."5-max".graphics = {
      enable = lib.mkEnableOption "gpu configuration" // {
        default = config.hardware.graphics.enable;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      firmware = [
        mali-firmware
      ];
    };
    # VK_KHR_sampler_ycbcr_conversion is not available for g610 in older mesa versions
    environment.sessionVariables = lib.optionalAttrs (lib.versionOlder pkgs.mesa.version "25.1.0") {
      GDK_VULKAN_DISABLE = "ycbcr";
    };
  };
}
