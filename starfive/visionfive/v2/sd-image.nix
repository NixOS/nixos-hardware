{ config, pkgs, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./.
  ];

  sdImage = {
    imageName =
      "${config.sdImage.imageBaseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}-starfive-visionfive2.img";

    # Overridden by postBuildCommands
    populateFirmwareCommands = "";

    firmwarePartitionOffset = 4;
    firmwareSize = 4;

    postBuildCommands = ''
      # preserve root partition
      eval $(partx $img -o START,SECTORS --nr 2 --pairs)

      # increase image size for gpt backup header
      truncate -s '+2M' $img

      sfdisk $img <<EOF
          label: gpt
          unit: sectors
          sector-size: 512

          start=4096, size=4096, type=2E54B353-1271-4842-806F-E436D6AF6985
          start=8192, size=8192, type=5B193300-FC78-40CD-8002-E86C45580B47
          start=$START, size=$SECTORS, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, attrs="LegacyBIOSBootable"
      EOF

      eval $(partx $img -o START,SECTORS --nr 1 --pairs)
      dd conv=notrunc if=${config.system.build.uboot}/u-boot-spl.bin.normal.out of=$img seek=$START count=$SECTORS

      eval $(partx $img -o START,SECTORS --nr 2 --pairs)
      dd conv=notrunc if=${config.system.build.uboot}/u-boot.itb of=$img seek=$START count=$SECTORS
    '';

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };

  environment.systemPackages = [ config.system.build.updater-flash ];
}
