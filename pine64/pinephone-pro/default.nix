{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.hardware.pinephone-pro;
in
{
  imports = [ ./wifi.nix ];
  options.hardware.pinephone-pro = {
    install-ucm2-rules = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to install PinePhone Pro specific UCM2 rules.
        These provide audio usecaseses for HiFi audio and Voice calls.
      '';
    };
  };
  config = {
    nixpkgs.overlays = [
      (final: _prev: {
        pine64-alsa-ucm = final.callPackage ./pine64-alsa-ucm { };
        firmware_pinephone-pro = pkgs.callPackage ./firmware.nix { };
        linuxPackages_pinephone-pro = pkgs.callPackage ./kernel { inherit (config.boot) kernelPatches; };
      })
    ];
    hardware.firmware = [ pkgs.firmware_pinephone-pro ];
    environment.systemPackages = lib.optionals cfg.install-ucm2-rules [ pkgs.pine64-alsa-ucm ];

    boot = {
      kernelPackages = pkgs.linuxPackagesFor pkgs.linuxPackages_pinephone-pro;
      loader = {
        generic-extlinux-compatible.enable = true;
        grub.enable = false;
      };
    };
  };
}
