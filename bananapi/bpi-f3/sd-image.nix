{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./default.nix
    ./firmware.nix
  ];

  hardware.enableAllHardware = lib.mkForce false;

  boot.loader = {
    grub.enable = lib.mkDefault false;
    generic-extlinux-compatible.enable = lib.mkDefault true;
  };

  image.fileName = "${config.image.baseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}-bpi-f3.img";

  sdImage = {
    expandOnBoot = false;
    firmwarePartitionOffset = 4;
    firmwareSize = 256;
    populateFirmwareCommands = "";

    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
        -c ${config.system.build.toplevel} -d ./files/boot
    '';

    postBuildCommands = ''
      eval $(${pkgs.util-linux}/bin/partx $img -o START,SECTORS --nr 2 --pairs)
      ROOTFS_START=$START
      ROOTFS_SECTORS=$SECTORS

      truncate -s '+2M' $img

      ${pkgs.util-linux}/bin/sfdisk $img <<EOF
          label: gpt
          unit: sectors
          sector-size: 512
          first-lba: 256

          start=256,           size=512,             name="fsbl",    type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=768,           size=128,             name="env",     type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=2048,          size=2048,            name="opensbi", type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=4096,          size=4096,            name="uboot",   type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=8192,          size=524288,          name="bootfs",  type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=$ROOTFS_START, size=$ROOTFS_SECTORS, name="rootfs",  type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
      EOF

      dd if=${config.system.build.fsbl}/FSBL.bin                                              of=$img conv=notrunc bs=1024 seek=128
      dd if=${config.system.build.opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.itb of=$img conv=notrunc bs=1M   seek=1
      dd if=${config.system.build.uboot}/u-boot.itb                                            of=$img conv=notrunc bs=1M   seek=2
      dd if=${config.system.build.fsbl}/bootinfo_sd.bin                                        of=$img conv=notrunc bs=1    seek=0 count=80
    '';
  };
}
