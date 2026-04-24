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
  modDirVersion = "6.12.47";
  tag = "stable_20250916";
  hash = "sha256-HG8Oc04V2t54l0SOn4gKmNJWQUrZfjWusgKcWvx74H0==";
in
lib.overrideDerivation
  (buildLinux (
    args
    // {
      version = "${modDirVersion}-${tag}";
      inherit modDirVersion;
      pname = "linux-rpi";

      src = fetchFromGitHub {
        owner = "raspberrypi";
        repo = "linux";
        inherit tag hash;
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
      structuredExtraConfig =
        with lib.kernel;
        {
          # RPi has 4 cores; nixpkgs common-config sets 384
          NR_CPUS = lib.mkForce (freeform "4");
          # nixpkgs sets 32MB; RPi vendor defconfig uses 5MB
          CMA_SIZE_MBYTES = lib.mkForce (freeform "5");
          # Vendor defconfigs set -v7, -v8, -v8-16k; clear to match modDirVersion
          LOCALVERSION = lib.mkForce (freeform "");

          # NFS root boot support (common RPi use case)
          NFS_FS = lib.mkForce yes;
          NFS_V4 = lib.mkForce yes;
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
        // lib.optionalAttrs (rpiVersion >= 3) (
          with lib.kernel;
          {
            PREEMPT = lib.mkForce yes;
            PREEMPT_VOLUNTARY = lib.mkForce no;
          }
        );

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
  ))
  (_oldAttrs: {

    # Make copies of the DTBs named after the upstream names so that U-Boot finds them.
    # This is ugly as heck, but I don't know a better solution so far.
    postFixup = ''
      dtbDir=${if stdenv.hostPlatform.isAarch64 then "$out/dtbs/broadcom" else "$out/dtbs"}
      rm $dtbDir/bcm283*.dtb
      copyDTB() {
        cp -v "$dtbDir/$1" "$dtbDir/$2"
      }
    ''
    + lib.optionalString (lib.elem stdenv.hostPlatform.system [ "armv6l-linux" ]) ''
      copyDTB bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero.dtb
      copyDTB bcm2708-rpi-zero-w.dtb bcm2835-rpi-zero-w.dtb
      copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-a.dtb
      copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b.dtb
      copyDTB bcm2708-rpi-b.dtb bcm2835-rpi-b-rev2.dtb
      copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-a-plus.dtb
      copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-b-plus.dtb
      copyDTB bcm2708-rpi-b-plus.dtb bcm2835-rpi-zero.dtb
      copyDTB bcm2708-rpi-cm.dtb bcm2835-rpi-cm.dtb
    ''
    + lib.optionalString (lib.elem stdenv.hostPlatform.system [ "armv7l-linux" ]) ''
      copyDTB bcm2709-rpi-2-b.dtb bcm2836-rpi-2-b.dtb
    ''
    +
      lib.optionalString
        (lib.elem stdenv.hostPlatform.system [
          "armv7l-linux"
          "aarch64-linux"
        ])
        ''
          copyDTB bcm2710-rpi-zero-2.dtb bcm2837-rpi-zero-2.dtb
          copyDTB bcm2710-rpi-zero-2-w.dtb bcm2837-rpi-zero-2-w.dtb
          copyDTB bcm2710-rpi-3-b.dtb bcm2837-rpi-3-b.dtb
          copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-a-plus.dtb
          copyDTB bcm2710-rpi-3-b-plus.dtb bcm2837-rpi-3-b-plus.dtb
          copyDTB bcm2710-rpi-cm3.dtb bcm2837-rpi-cm3.dtb
          copyDTB bcm2711-rpi-4-b.dtb bcm2838-rpi-4-b.dtb
        '';
  })
