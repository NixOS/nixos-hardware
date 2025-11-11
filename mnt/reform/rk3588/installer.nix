{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/image/file-options.nix"
    "${modulesPath}/profiles/installation-device.nix"
    ./.
  ];

  options.installerImage = {
    compressImage = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Whether the installer image should be compressed using
        {command}`zstd`.
      '';
    };
    squashfsCompression = lib.mkOption {
      default = "zstd -Xcompression-level 19";
      type = lib.types.nullOr lib.types.str;
      description = ''
        Compression settings to use for the squashfs nix store.
        `null` disables compression.
      '';
      example = "zstd -Xcompression-level 6";
    };
    storeContents = lib.mkOption {
      example = lib.literalExpression "[ pkgs.stdenv ]";
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated installer image.
      '';
    };
  };
  config =
    let
      squashfs = pkgs.callPackage "${modulesPath}/../lib/make-squashfs.nix" {
        storeContents = config.installerImage.storeContents;
        comp = config.installerImage.squashfsCompression;
      };
      packages = pkgs.callPackage ../pkgs { };
      ubootImage = packages.ubootImage.reform2-rk3588-dsi;
      content = pkgs.callPackage (
        {
          stdenv,
          e2fsprogs,
          libfaketime,
          fakeroot,
        }:
        stdenv.mkDerivation {
          name = "ext4-fs.img";
          nativeBuildInputs = [
            e2fsprogs.bin
            libfaketime
            fakeroot
          ];
          buildCommand = ''
            img=$out
            mkdir -p ./files
            ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./rootImage/boot
            (
              GLOBIGNORE=".:.."
              shopt -u dotglob

              for f in ./files/*; do
                  cp -a --reflink=auto -t ./rootImage/ "$f"
              done
            )
            cp -a --reflink=auto ${squashfs} ./rootImage/nix-store.squashfs


            # Make a crude approximation of the size of the target image.
            # If the script starts failing, increase the fudge factors here.
            numInodes=$(find ./rootImage | wc -l)
            numDataBlocks=$(du -s -c -B 4096 --apparent-size ./rootImage | tail -1 | awk '{ print int($1 * 1.20) }')
            bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
            echo "Creating an EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks)"

            mebibyte=$(( 1024 * 1024 ))
            # Round up to the nearest mebibyte.
            # This ensures whole 512 bytes sector sizes in the disk image
            # and helps towards aligning partitions optimally.
            if (( bytes % mebibyte )); then
              bytes=$(( ( bytes / mebibyte + 1) * mebibyte ))
            fi

            truncate -s $bytes $img

            faketime -f "1970-01-01 00:00:01" fakeroot mkfs.ext4 -L NIXOS_ROOT -U 44444444-4444-4444-8888-888888888888 -d ./rootImage $img

            export EXT2FS_NO_MTAB_OK=yes
            # I have ended up with corrupted images sometimes, I suspect that happens when the build machine's disk gets full during the build.
            if ! fsck.ext4 -n -f $img; then
              echo "--- Fsck failed for EXT4 image of $bytes bytes (numInodes=$numInodes, numDataBlocks=$numDataBlocks) ---"
              cat errorlog
              return 1
            fi

            # We may want to shrink the file system and resize the image to
            # get rid of the unnecessary slack here--but see
            # https://github.com/NixOS/nixpkgs/issues/125121 for caveats.

            # shrink to fit
            resize2fs -M $img

            # Add 16 MebiByte to the current_size
            new_size=$(dumpe2fs -h $img | awk -F: \
              '/Block count/{count=$2} /Block size/{size=$2} END{print (count*size+16*2**20)/size}')

            resize2fs $img $new_size
          '';
        }
      ) { };
    in
    {
      fileSystems = {
        "/" = lib.mkImageMediaOverride {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
        };

        "/iso" = lib.mkImageMediaOverride {
          device = "/dev/disk/by-label/NIXOS_ROOT";
          neededForBoot = true;
          noCheck = true;
          options = [ "ro" ];
        };

        # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
        # image) to make this a live CD.
        "/nix/.ro-store" = lib.mkImageMediaOverride {
          fsType = "squashfs";
          device = "/iso/nix-store.squashfs";
          options = [
            "loop"
          ]
          ++ lib.optional (config.boot.kernelPackages.kernel.kernelAtLeast "6.2") "threads=multi";
          neededForBoot = true;
        };

        "/nix/.rw-store" = lib.mkImageMediaOverride {
          fsType = "tmpfs";
          options = [ "mode=0755" ];
          neededForBoot = true;
        };

        "/nix/store" = lib.mkImageMediaOverride {
          fsType = "overlay";
          device = "overlay";
          options = [
            "lowerdir=/nix/.ro-store"
            "upperdir=/nix/.rw-store/store"
            "workdir=/nix/.rw-store/work"
          ];
          depends = [
            "/nix/.ro-store"
            "/nix/.rw-store/store"
            "/nix/.rw-store/work"
          ];
        };
      };

      boot = {
        initrd.availableKernelModules = [
          "squashfs"
          "uas"
          "overlay"
        ];
        initrd.kernelModules = [
          "loop"
          "overlay"
        ];
        loader.timeout = 0;
      };

      image.extension = if config.installerImage.compressImage then "img.zst" else "img";
      image.filePath = "installer-image/${config.image.fileName}";

      installerImage.storeContents = [ config.system.build.toplevel ];

      system.build.image = pkgs.callPackage (
        { stdenv, util-linux }:
        stdenv.mkDerivation {
          name = config.image.fileName;
          nativeBuildInputs = [ util-linux ];
          inherit (config.installerImage) compressImage;
          buildCommand = ''
            mkdir -p $out/nix-support $out/installer-image
            img=$out/installer-image/${config.image.baseName}.img

            echo "${stdenv.buildPlatform.system}" > $out/nix-support/system
            if test -n "$compressImage"; then
              echo "file installer-image $img.zst" >> $out/nix-support/hydra-build-products
            else
              echo "file installer-image $img" >> $out/nix-support/hydra-build-products
            fi

            sectors=$((($(stat -c '%s' ${content})+511)/512))
            # create disk image
            truncate -s $((($sectors + 32768 + 2048)*512)) $img
            sfdisk $img <<EOF
              label: gpt
              unit: sectors
              sector-size: 512

              start=32768, size=$sectors, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, attrs="LegacyBIOSBootable"
            EOF

            eval $(partx $img -o START,SECTORS --nr 1 --pairs)
            dd conv=notrunc if=${content} of=$img seek=$START count=$SECTORS

            dd conv=notrunc if=${ubootImage}/rk3588-mnt-reform2-dsi-flash.bin of=$img seek=64

            if test -n "$compressImage"; then
              zstd -T$NIX_BUILD_CORES --rm $img
            fi
          '';
        }
      ) { };

      boot.postBootCommands = ''
        # After booting, register the contents of the Nix store on the
        # CD in the Nix database in the tmpfs.
        ${config.nix.package.out}/bin/nix-store --load-db < /nix/store/nix-path-registration

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';
      boot.initrd.supportedFilesystems = [ "ext4" ];
    };
}
