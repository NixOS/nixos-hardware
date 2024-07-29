{ config, pkgs, lib, ... }:
let
  cfg = config.hardware.librem5;
  linuxPackages_librem5 = pkgs.linuxPackagesFor (pkgs.callPackage ./kernel.nix { });
  ubootLibrem5 = pkgs.callPackage ./u-boot { };
in {
  options = {
    hardware.librem5 = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.callPackage ./librem5-base { };
      };
      wifiCard = lib.mkOption {
        type = lib.types.enum [ "redpine" "sparklan" "none" ];
        description = ''
          Which wi-fi card is installed in your phone.

          Phones shipped before January 2023 have redpine, newer phones have sparklan.
        '';
        default = "redpine";
      };
      customInitrdModules = lib.mkEnableOption "use of custom kernel modules in the initrd.";
      installUdevPackages = lib.mkEnableOption "installation of udev packages from librem5-base.";
      lockdownFix = lib.mkEnableOption "fix for orientation and proximity sensors not working after lockdown.";
      audio = lib.mkOption {
        description = ''
          Whether to enable and configure PulseAudio for the Librem5 modem.

          This is required for audio during calls to work at all.
        '';
        type = lib.types.bool;
        default = true;
        example = false;
      };
    };
  };

  imports = [
    ./audio.nix
    ./initrd.nix
    ./wifi.nix
    ./lockdown-fix.nix
  ];

  config = {
    hardware.librem5 = {
      customInitrdModules = lib.mkDefault true;
      installUdevPackages = lib.mkDefault true;
      lockdownFix = lib.mkDefault true;
    };

    boot = {
      kernelParams = [ "rootwait" ];

      loader = {
        generic-extlinux-compatible.enable = lib.mkDefault true;
        grub.enable = false;
      };

      kernelPackages = lib.mkDefault linuxPackages_librem5;
    };

    services.udev.packages = lib.mkIf cfg.installUdevPackages [ config.hardware.librem5.package ];

    environment.systemPackages = [ ubootLibrem5 ];
  };
}
