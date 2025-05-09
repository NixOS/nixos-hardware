{ modulesPath
, config
, pkgs
, ...
}:
let
  uboot = config.hardware.orange-pi."5-max".uboot.package;
in
{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./default.nix
  ];

  sdImage = {
    imageName =
      "${config.sdImage.imageBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}-orange-pi-5-max.img";

    firmwarePartitionOffset = 16;
    firmwarePartitionName = "BOOT";

    compressImage = true;
    expandOnBoot = true;

    populateFirmwareCommands = "dd if=${uboot}/u-boot-rockchip.bin of=$img seek=64 conv=notrunc";

    postBuildCommands = ''
      cp ${uboot}/u-boot-rockchip.bin firmware/
    '';

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
