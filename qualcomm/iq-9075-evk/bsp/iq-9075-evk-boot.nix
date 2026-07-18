{
  pkgs,
}:

let
  uboot = pkgs.callPackage ./iq-9075-evk-uboot.nix { };
  linux = pkgs.callPackage ./iq-9075-evk-linux.nix { };
  firmware = pkgs.callPackage ./iq-9075-evk-firmware-boot.nix { };
  partitions = pkgs.callPackage ./iq-9075-evk-partitions.nix { };
  dtbBin = pkgs.callPackage ./iq-9075-evk-dtb-bin.nix { };
  # Vendored from the QLI reference qcomflash (meta-qcom / BOOT.MXF …-00508):
  # stable GPT GUIDs + NHLOS LUN1–5 rawprogram/patch XMLs (LUN GUIDs must not
  # drift vs a working flash). MultiDTB FIT VFAT is built in iq-9075-evk-dtb-bin.
  assets = ./assets;
in
{
  # Assembles qcom-deb-images-style flash_lemans-evk_ufs/ plus kernel/U-Boot.
  iq-9075-evk-boot = pkgs.stdenvNoCC.mkDerivation {
    pname = "iq-9075-evk-boot";
    version = uboot.version;

    dontUnpack = true;

    buildPhase = ''
      runHook preBuild

      flash=flash_lemans-evk_ufs
      mkdir -p image "$flash" deploy/firmware

      # Kernel / U-Boot artifacts (U-Boot unused on Type2 ESP / NHLOS uefi.elf path)
      cp ${uboot}/u-boot.bin image/
      test -f ${uboot}/u-boot-nodtb.bin && cp ${uboot}/u-boot-nodtb.bin image/ || true
      cp ${linux}/Image image/
      cp ${linux}/dtbs/qcom/lemans-evk.dtb image/

      # Partition / QDL scripts from ptool (iq-9075-evk/ufs) — keep LUN0 map
      # for NixOS disk-ufs.img1/2; overlay QLI LUN1–5 XML below. GPT binaries
      # (including LUN0) come from vendored assets for stable disk/part GUIDs.
      cp -a ${partitions}/flash/. "$flash"/
      chmod -R u+w "$flash"
      cp -a ${partitions}/partitions deploy/

      # NHLOS from QCS9100_bootbinaries_00130 (embeds BOOT.MXF …-00508).
      # Mirror meta-qcom: exclude xbl_config*.elf here, then install kvm as
      # xbl_config.elf (Non-Gunyah / OsConfigTableSelectionFlag=0x2).
      find ${firmware}/boot-binaries -maxdepth 1 \( \
        -name LICENSE \
        -o -name 'Qualcomm-Technologies-Inc.-Proprietary' \
        -o -name 'prog_*' \
        -o -name 'boot.img' \
        -o -name '*.bin' \
        -o -name '*.elf' \
        -o -name '*.melf' \
        -o -name '*.fv' \
        -o -name '*.mbn' \
      \) ! -name 'xbl_config*.elf' -exec cp -a {} "$flash"/ \;

      if [ -d ${firmware}/boot-binaries/sail_nor ]; then
        cp -a ${firmware}/boot-binaries/sail_nor "$flash"/
      fi

      if [ -f ${firmware}/boot-binaries/xbl_config_kvm.elf ]; then
        cp -a ${firmware}/boot-binaries/xbl_config_kvm.elf "$flash"/xbl_config.elf
      else
        echo "error: xbl_config_kvm.elf missing from QCS9100 boot binaries" >&2
        exit 1
      fi

      # Store copies are mode-0444; make writable before QLI asset overlays.
      chmod -R u+w "$flash"

      # CDT: QLI rawprogram3 uses filename="cdt.bin"
      cp --no-preserve=mode ${assets}/cdt.bin "$flash"/cdt.bin

      # MultiDTB FIT VFAT (ParseFitDt → qcom,qcs9075-iot + lemans-el2)
      cp --no-preserve=mode ${dtbBin}/dtb.bin "$flash"/dtb.bin

      # Stable GPT GUIDs (LUN0–5) + QLI NHLOS rawprogram/patch for LUN1–5
      cp --no-preserve=mode -a ${assets}/gpt/. "$flash"/
      for i in 1 2 3 4 5; do
        cp --no-preserve=mode ${assets}/qdl/rawprogram$i.xml "$flash"/
        cp --no-preserve=mode ${assets}/qdl/patch$i.xml "$flash"/
      done

      # Contract checks on generated / fetched inputs.
      grep -qa 'BOOT.MXF.1.0.c1-00508-KODIAKLA-1' "$flash/uefi.elf"
      grep -q '../disk-ufs.img1' "$flash/rawprogram0.xml"
      grep -q '../disk-ufs.img2' "$flash/rawprogram0.xml"

      cp -a ${firmware}/boot-binaries/. deploy/firmware/qcs9100/
      cp -a ${firmware}/cdt/cdt_rb8_core_kit.bin deploy/firmware/
      cp --no-preserve=mode ${dtbBin}/dtb.bin deploy/firmware/dtb.bin

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -a image $out/
      cp -a flash_lemans-evk_ufs $out/
      cp -a deploy $out/
      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "IQ-9075 EVK boot bundle (kernel, U-Boot, flash_lemans-evk_ufs)";
      platforms = [ "aarch64-linux" ];
    };
  };
}
