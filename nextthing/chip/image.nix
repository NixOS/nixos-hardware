# We are not going to flash it to an SD card, just utilizing the sdImage infrastructure to build a flashable image

{ config, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
  ];

  sdImage = {
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    populateFirmwareCommands = "";
  };
}
