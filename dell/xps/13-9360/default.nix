{ lib, pkgs, ... }:

{
  # 4K screen, use bigger console font
  # i18n.consoleFont deprecated and obsolete in >=20.03
  # hardware-configuration.nix generates console.font
  i18n.consoleFont = lib.mkIf (lib.versionOlder (lib.versions.majorMinor lib.version) "20.03") (lib.mkDefault "latarcyrheb-sun32");
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
  ];

  boot.blacklistedKernelModules = [ "psmouse" ]; # touchpad goes over i2c

  # TODO: decide on boot loader policy
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkDefault true;
    systemd-boot.enable = lib.mkDefault true;
  };

  hardware.firmware = lib.mkBefore [ pkgs.qca6174-firmware ];

  # TODO: upstream to NixOS/nixpkgs
  nixpkgs.overlays = [(final: previous: {
    qca6174-firmware = final.callPackage ./qca6174-firmware.nix {};
  })];

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}
