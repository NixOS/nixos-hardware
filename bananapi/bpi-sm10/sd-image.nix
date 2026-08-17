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
  ];

  hardware.enableAllHardware = lib.mkForce false;

  fileSystems."/" = lib.mkForce {
    device = "/dev/disk/by-partlabel/nixos-rootfs";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  image.fileName = "${config.image.baseName}-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}-bpi-sm10.img";

  sdImage = {
    expandOnBoot = false;
    firmwarePartitionOffset = 12;
    firmwarePartitionName = "ESP";
    firmwareSize = 256;

    populateFirmwareCommands =
      let
        systemdBoot = "${pkgs.systemd}/lib/systemd/boot/efi/systemd-bootriscv64.efi";
        kernel = "${config.system.build.kernel}/${config.system.boot.loader.kernelFile}";
        initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
        dtb = "${config.hardware.deviceTree.package}/${config.hardware.deviceTree.name}";
        kernelParams = lib.concatStringsSep " " config.boot.kernelParams;
      in
      ''
        mkdir -p firmware/EFI/BOOT firmware/EFI/systemd firmware/EFI/nixos
        mkdir -p firmware/loader/entries

        cp ${systemdBoot} firmware/EFI/BOOT/BOOTRISCV64.EFI
        cp ${systemdBoot} firmware/EFI/systemd/systemd-bootriscv64.efi

        cp ${kernel}  firmware/EFI/nixos/kernel.efi
        cp ${initrd}  firmware/EFI/nixos/initrd
        cp ${dtb}     firmware/EFI/nixos/k3_com260_ifx.dtb

        cat > firmware/loader/loader.conf <<EOF
        default nixos
        timeout 3
        console-mode auto
        EOF

        cat > firmware/loader/entries/nixos.conf <<EOF
        title NixOS
        linux /EFI/nixos/kernel.efi
        initrd /EFI/nixos/initrd
        devicetree /EFI/nixos/k3_com260_ifx.dtb
        options init=${config.system.build.toplevel}/init ${kernelParams}
        EOF

        cat > firmware/startup.nsh <<EOF
        @echo -off
        echo Booting NixOS...
        for %i in 0 1 2 3 4 5
          if exist FS%i:\EFI\BOOT\BOOTRISCV64.EFI then
            FS%i:\EFI\BOOT\BOOTRISCV64.EFI
          endif
        endfor
        EOF
      '';
    populateRootCommands = "";

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

          start=1280,          size=128,             name="env",      type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=2048,          size=256,             name="bootinfo", type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=3072,          size=1024,            name="fsbl",     type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=8192,          size=6144,            name="esos",     type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=14336,         size=2048,            name="opensbi",  type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=16384,         size=8192,            name="uboot",    type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
          start=24576,         size=524288,          name="ESP",      type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B
          start=$ROOTFS_START, size=$ROOTFS_SECTORS, name="nixos-rootfs", type=0FC63DAF-8483-4772-8E79-3D69D8477DE4
      EOF

      dd if=${config.system.build.fsbl}/bootinfo_block.bin                                    of=$img conv=notrunc bs=1M   seek=1
      dd if=${config.system.build.fsbl}/FSBL.bin                                              of=$img conv=notrunc bs=1024 seek=1536
      dd if=${config.system.build.opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.itb of=$img conv=notrunc bs=1M   seek=7
      dd if=${config.system.build.edk2}/edk2.itb                                              of=$img conv=notrunc bs=1M   seek=8
    '';
  };
}
