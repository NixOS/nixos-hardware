{ config, lib, modulesPath, pkgs, ... }:

let
  inherit (pkgs) callPackage;

  fip = callPackage ./fip.nix { };
  zsbl = callPackage ./zsbl.nix { };
  opensbi = callPackage ./opensbi.nix { };
  linuxboot-kernel = callPackage ./linuxboot-kernel.nix { };
  linuxboot-initrd = callPackage ./linuxboot-initrd.nix { };
  dtbs = config.hardware.deviceTree.package;
  firmware = callPackage ./firmware.nix {
    inherit fip zsbl opensbi linuxboot-kernel linuxboot-initrd dtbs;
  };
in
{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./default.nix
  ];

  boot.loader = {
    grub.enable = lib.mkDefault false;
    generic-extlinux-compatible.enable = lib.mkDefault true;
  };

  hardware.enableRedistributableFirmware = true;

  # For some reason the serial getty is not started automatically
  # even though console=ttyS0,115200 is passed to the kernel.
  # https://docs.kernel.org/admin-guide/serial-console.html
  # https://github.com/NixOS/nixpkgs/issues/84105
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  sdImage = {
    imageName = "${config.sdImage.imageBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}-milkv-pioneer.img";

    populateFirmwareCommands = ''
      mkdir -p firmware/
      cp -a ${firmware}/* firmware/
      touch firmware/BOOT
    '';

    firmwarePartitionOffset = 1;
    firmwareSize = 128;

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
