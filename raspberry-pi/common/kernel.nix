{
  stdenv,
  lib,
  pkgs,
  fetchFromGitHub,
  buildLinux,
  rpiVersion,
  ...
}@args:

let
  # NOTE: raspberryPiWirelessFirmware should be updated with this
  modDirVersion = "6.12.75";
  hash = "sha256-qrljd20n4tj/7C7gzNnxw7JIyEF2Ppf1PWm2a7vxh1w=";
  inherit (lib.kernel) freeform yes no;
in
(buildLinux (
  args
  // {
    version = "${modDirVersion}-1+rpt1";
    inherit modDirVersion;
    pname = "linux-rpi";

    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "linux";
      # https://github.com/RPi-Distro/linux-packaging/raw/refs/tags/pios/1%256.12.75-1+rpt1/debian/changelog
      rev = "89050b1059997d38d55462b323b099a6436dc10d";
      inherit hash;
    };

    defconfig =
      {
        "1" = "bcmrpi_defconfig";
        "2" = "bcm2709_defconfig";
        "3" = if stdenv.hostPlatform.isAarch64 then "bcm2711_defconfig" else "bcm2709_defconfig";
        "4" = "bcm2711_defconfig";
        "5" = "bcm2712_defconfig";
      }
      .${toString rpiVersion};

    features = {
      efiBootStub = false;
    }
    // (args.features or { });

    isLTS = true;

    kernelPatches = with pkgs.kernelPatches; [
      bridge_stp_helper
      request_key_helper
    ];

    # Override nixpkgs common-config.nix defaults that conflict with the RPi vendor defconfigs.
    # See: https://github.com/raspberrypi/linux/tree/rpi-6.12.y/arch/arm64/configs
    structuredExtraConfig = {
      # Vendor defconfigs set CONFIG_LOCALVERSION to -v7, -v8, -v8-16k, which
      # breaks modDirVersion. Clear it.
      LOCALVERSION = freeform "";

      # RPi has 4 cores; nixpkgs common-config sets 384
      NR_CPUS = lib.mkForce (freeform "4");
      # nixpkgs sets 32MB; RPi vendor defconfig uses 5MB
      CMA_SIZE_MBYTES = lib.mkForce (freeform "5");

      # NFS root boot support (common RPi use case)
      NFS_FS = lib.mkForce yes;
      NFS_V4 = yes;
      ROOT_NFS = yes;
      IP_PNP = lib.mkForce yes;
      IP_PNP_DHCP = yes;
      IP_PNP_RARP = yes;

      # Match vendor defconfig: built-in instead of module
      NET_CLS_BPF = lib.mkForce yes;
      NLS_CODEPAGE_437 = lib.mkForce yes;
      FB_SIMPLE = yes;
    }
    # arm64 vendor defconfigs (bcm2711, bcm2712) use full preempt;
    # arm32 ones (bcmrpi, bcm2709) use voluntary preempt (nixpkgs default)
    // lib.optionalAttrs (rpiVersion >= 3) {
      PREEMPT = lib.mkForce yes;
      PREEMPT_VOLUNTARY = lib.mkForce no;
    };

    extraMeta =
      if (rpiVersion < 3) then
        {
          platforms = with lib.platforms; lib.intersectLists arm linux;
          hydraPlatforms = [ ];
        }
      else
        {
          platforms = with lib.platforms; lib.intersectLists (arm ++ aarch64) linux;
          hydraPlatforms = [ "aarch64-linux" ];
        };
    ignoreConfigErrors = true;
  }
  // (args.argsOverride or { })
)).overrideAttrs
  {
    # The vendor kernel uses different DTB names (bcm2708/bcm2709/bcm2710) than what
    # U-Boot expects (bcm2835/bcm2836/bcm2837). Starting with Pi 4, names match.
    # See: https://github.com/u-boot/u-boot/blob/master/board/raspberrypi/rpi/rpi.c
    postFixup = lib.optionalString (rpiVersion < 4) (
      ''
        dtbDir=${if stdenv.hostPlatform.isAarch64 then "$out/dtbs/broadcom" else "$out/dtbs"}
        rm $dtbDir/bcm283*.dtb
        copyDTB() {
          cp -v "$dtbDir/$1" "$dtbDir/$2"
        }
      ''
      + lib.optionalString (rpiVersion == 1) ''
        copyDTB bcm2708-rpi-zero.dtb bcm2835-rpi-zero.dtb
        copyDTB bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero-w.dtb
        copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-a.dtb
        copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b.dtb
        copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b-rev2.dtb
        copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-a-plus.dtb
        copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-b-plus.dtb
        copyDTB bcm2708-rpi-cm.dtb bcm2835-rpi-cm.dtb
      ''
      + lib.optionalString (rpiVersion == 2) ''
        copyDTB bcm2709-rpi-2-b.dtb bcm2836-rpi-2-b.dtb
      ''
      + lib.optionalString (rpiVersion == 3) ''
        copyDTB bcm2710-rpi-zero-2.dtb bcm2837-rpi-zero-2.dtb
        copyDTB bcm2710-rpi-zero-2-w.dtb bcm2837-rpi-zero-2-w.dtb
        copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
        copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-a-plus.dtb
        copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
        copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
      ''
    );
  }
