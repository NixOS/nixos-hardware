{
  pkgs,
}:

let
  linux = pkgs.callPackage ./iq-9075-evk-linux.nix { };
  firmware = pkgs.callPackage ./iq-9075-evk-firmware-boot.nix { };
  partitions = pkgs.callPackage ./iq-9075-evk-partitions.nix { };
  dtbBin = pkgs.callPackage ./iq-9075-evk-dtb-bin.nix {
    iq-9075-evk-linux = linux;
  };
in
{
  # Assembles meta-qcom-style flash_lemans-evk_ufs/ for the Type2 ESP path
  # (NHLOS uefi.elf → systemd-boot → UKI). GPT + QDL from qcom-ptool; NHLOS +
  # CDT from firmware fetches; MultiDTB FIT VFAT from iq-9075-evk-dtb-bin.
  iq-9075-evk-boot = pkgs.stdenvNoCC.mkDerivation {
    pname = "iq-9075-evk-boot";
    version = linux.version;

    dontUnpack = true;

    buildPhase = ''
      runHook preBuild

      flash=flash_lemans-evk_ufs
      mkdir -p image "$flash" deploy/firmware

      cp ${linux}/Image image/
      cp ${linux}/dtbs/qcom/lemans-evk.dtb image/

      # Partition / QDL scripts + GPT from ptool (iq-9075-evk/ufs)
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

      chmod -R u+w "$flash"

      # CDT: rawprogram3 filename="cdt.bin" (same bytes as cdt_rb8_core_kit.bin)
      cp --no-preserve=mode ${firmware}/cdt/cdt_rb8_core_kit.bin "$flash"/cdt.bin

      # MultiDTB FIT VFAT (ParseFitDt → qcom,qcs9075-iot + lemans-el2)
      cp --no-preserve=mode ${dtbBin}/dtb.bin "$flash"/dtb.bin

      # Fail closed so a flash_lemans dir never ships with the wrong NHLOS,
      grep -qa 'BOOT.MXF.1.0.c1-00508-KODIAKLA-1' "$flash/uefi.elf"
      # ptool XML filename must match the cdt.bin we install above.
      grep -q 'filename="cdt.bin"' "$flash/rawprogram3.xml"
      # LUN0 programs NixOS ESP+rootfs paths, not QLI efi.bin/rootfs.img.
      grep -q '../disk-ufs.img1' "$flash/rawprogram0.xml"
      grep -q '../disk-ufs.img2' "$flash/rawprogram0.xml"
      # ptool emitted GPT for LUN0 (ESP/rootfs) and LUN4 (uefi/dtb).
      test -f "$flash/gpt_main0.bin"
      test -f "$flash/gpt_main4.bin"

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
      description = "IQ-9075 EVK boot bundle (kernel, flash_lemans-evk_ufs)";
      platforms = [ "aarch64-linux" ];
      maintainers = with maintainers; [ govindsi ];
    };
  };
}
