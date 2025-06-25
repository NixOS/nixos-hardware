# To build, use:
# nix-build "<nixpkgs/nixos>" -I nixos-config=starfive/visionfive/v1/sd-image.nix -A config.system.build.sdImage
{
  config,
  pkgs,
  modulesPath,
  ...
}:

let
  firmware = pkgs.callPackage ./firmware.nix { };
in
{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./default.nix
  ];

  sdImage = {
    imageName = "${config.sdImage.imageBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}-starfive-visionfive-v1.img";

    # We have to use custom boot firmware since we do not support
    # StarFive's Fedora MMC partition layout. Thus, we include this in
    # the image's firmware partition so the user can flash the custom firmware.
    populateFirmwareCommands = ''
      cp ${firmware}/opensbi_u-boot_starfive_visionfive_v1.bin firmware/opensbi_u-boot_starfive_visionfive_v1.bin
    '';

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
