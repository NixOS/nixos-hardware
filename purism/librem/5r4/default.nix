{ config, pkgs, lib, ... }:
let cfg = config.hardware.librem5;
in {
  options = {
    hardware.librem5 = {
      wifiCard = lib.mkOption {
        type = lib.types.enum [ "redpine" "sparklan" "none" ];
        description = lib.mdDoc ''
          Which wi-fi card is installed in your phone.

          Phones shipped before January 2023 have redpine, newer phones have sparklan.
        '';
        default = "redpine";
      };
      customInitrdModules = lib.mkEnableOption (lib.mdDoc "use of custom kernel modules in the initrd.");
      installUdevPackages = lib.mkEnableOption (lib.mdDoc "installation of udev packages from librem5-base.");
      lockdownFix = lib.mkEnableOption (lib.mdDoc "fix for orientation and proximity sensors not working after lockdown.");
      audio = lib.mkOption {
        description = lib.mdDoc ''
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

    nixpkgs.overlays = [
      (import ./kernel)
      (final: prev: {
        ubootLibrem5 = final.callPackage ./u-boot { };

        librem5-base = final.callPackage ./librem5-base { };
      })
    ];

    boot = {
      kernelParams = [ "rootwait" ];

      loader = {
        generic-extlinux-compatible.enable = lib.mkDefault true;
        grub.enable = false;
      };

      kernelPackages = lib.mkDefault pkgs.linuxPackages_librem5;
    };

    services.udev.packages = lib.mkIf cfg.installUdevPackages [ pkgs.librem5-base ];

  };
}
