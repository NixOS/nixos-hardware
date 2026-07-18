{
  fetchurl,
  lib,
  stdenvNoCC,
  unzip,
}:

# Mirror meta-qcom firmware-qcom-boot-qcs9100_00130 + CDT (rb8_core_kit).
# Meta_Build_ID 00130 embeds BOOT.MXF.1.0.c1-00508 and xbl_config_kvm.elf
# (OsConfigTableSelectionFlag=0x2 / Non-Gunyah).
stdenvNoCC.mkDerivation {
  pname = "iq-9075-evk-firmware-boot";
  version = "00130";

  # Prefer binary caches for this large proprietary zip; builders without
  # network still need a substituter that already has the fixed-output drv.
  src = fetchurl {
    url = "https://softwarecenter.qualcomm.com/nexus/generic/product/chip/tech-package/QCS9100_bootbinaries.1.0/qcs9100_bootbinaries.1.0-test-device-public/00130/QCS9100_bootbinaries.zip";
    # meta-qcom SRC_URI[bootbinaries.sha256sum]
    hash = "sha256-Tk/pSk2tijExm24ayijQifijY9uBqvC7Pvj8jG59GHs=";
  };

  cdt = fetchurl {
    url = "https://artifacts.codelinaro.org/artifactory/codelinaro-le/Qualcomm_Linux/QCS9100/cdt/rb8_core_kit.zip";
    # meta-qcom firmware-qcom-cdt-qcs9100.bb SRC_URI[qcs9100-rb8-ck.sha256sum]
    hash = "sha256-olIkT4ANfJ4ViD4Sk1r0ET+fLsumSQ5GzZuUMWnxW/o=";
  };

  nativeBuildInputs = [ unzip ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/boot-binaries $out/cdt

    # Unpack boot binaries and strip the top directory (debos: unpack/*/* → …)
    mkdir -p unpack
    unzip -q $src -d unpack
    mv unpack/*/* $out/boot-binaries/
    rm -rf unpack

    # Unpack CDT; keep cdt_rb8_core_kit.bin at a stable path
    unzip -q $cdt -d $out/cdt
    if [ ! -f $out/cdt/cdt_rb8_core_kit.bin ]; then
      # Some zips nest the bin one level deeper
      cdt_bin=$(find $out/cdt -name cdt_rb8_core_kit.bin -type f | head -n1)
      test -n "$cdt_bin"
      install -m 0644 "$cdt_bin" $out/cdt/cdt_rb8_core_kit.bin
    fi

    # Drop partition/GPT helpers from the NHLOS tree; ptool owns those.
    # Matches qcom-deb-images find filters when copying into flash_lemans-evk_ufs/.
    find $out/boot-binaries -maxdepth 1 \( \
      -name 'gpt_*' \
      -o -name 'patch*.xml' \
      -o -name 'rawprogram*.xml' \
      -o -name 'wipe*.xml' \
      -o -name 'zeros_*' \
    \) -delete

    runHook postInstall
  '';

  meta = {
    description = "QCS9100 NHLOS boot binaries + RB8 CDT for IQ-9075 EVK (lemans-evk)";
    homepage = "https://github.com/qualcomm-linux/meta-qcom";
    # Qualcomm proprietary NHLOS (LICENSE.qcom-2 / softwarecenter terms).
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.all;
  };
}
