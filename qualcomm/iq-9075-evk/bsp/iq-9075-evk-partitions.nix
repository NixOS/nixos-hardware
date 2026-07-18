{
  fetchFromGitHub,
  lib,
  python3,
  stdenvNoCC,
}:

# Ship qcom-ptool platforms and generate GPT / rawprogram / patch files for
# iq-9075-evk/ufs (same platform key as qcom-deb-images / meta-qcom).
# meta-qcom qcom-ptool.inc SRCREV = 8e85e196… (packaged CLI under qcom_ptool/).
stdenvNoCC.mkDerivation {
  pname = "iq-9075-evk-partitions";
  version = "8e85e19";

  src = fetchFromGitHub {
    owner = "qualcomm-linux";
    repo = "qcom-ptool";
    rev = "8e85e196d2478e67b32558dc833be3beceeea512";
    hash = "sha256-NtnGlhAIw5M74g6fh/TFx2PJVElUEMdsidYQvHLRgcY=";
  };

  nativeBuildInputs = [ python3 ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export PYTHONPATH="$PWD''${PYTHONPATH:+:$PYTHONPATH}"
    ptool() { ${python3.interpreter} -m qcom_ptool.cli "$@"; }

    platform="iq-9075-evk/ufs"
    cdt_filename="cdt_rb8_core_kit.bin"
    buildid="nixos-iq-9075-evk"
    # UFS: ESP/rootfs placeholders match qcom-deb-images gen-ptool.sh /
    # meta-qcom image_types_qcom (efi.bin / rootfs.img → ../disk-ufs.img*)
    partition_map="cdt=$(basename "$cdt_filename")"
    # Match the QLI qcomflash rawprogram label filename="dtb.bin"
    partition_map="$partition_map,dtb_a=dtb.bin"
    partition_map="$partition_map,dtb_b=dtb.bin"
    partition_map="$partition_map,efi=../disk-ufs.img1"
    partition_map="$partition_map,rootfs=../disk-ufs.img2"

    mkdir -p gen/$platform
    ptool gen_partition \
      -i platforms/$platform/partitions.conf \
      -o gen/$platform/ptool-partitions.xml \
      -m "$partition_map"

    if [ -e platforms/$platform/contents.xml.in ]; then
      ptool gen_contents \
        -p gen/$platform/ptool-partitions.xml \
        -t platforms/$platform/contents.xml.in \
        -b "$buildid" \
        -o gen/$platform/contents.xml
    fi

    (
      cd gen/$platform
      ptool ptool -x ptool-partitions.xml
      # Avoid accidental full-wipe / blank-GPT programs (qcom-deb-images)
      rm -f rawprogram*_BLANK_GPT.xml \
            rawprogram*_WIPE_PARTITIONS.xml \
            wipe_rawprogram*.xml
    )

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -d $out/partitions $out/flash
    cp -a platforms $out/partitions/
    cp -a gen/iq-9075-evk/ufs/. $out/flash/
    runHook postInstall
  '';

  meta = {
    description = "UFS GPT and QDL scripts for IQ-9075 EVK (qcom-ptool iq-9075-evk/ufs)";
    homepage = "https://github.com/qualcomm-linux/qcom-ptool";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
