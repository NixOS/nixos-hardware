{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  bc,
  bison,
  flex,
  openssl,
  perl,
  python3,
  dtc,
  ubootTools,
  dosfstools,
  mtools,
  iq-9075-evk-linux,
}:

# MultiDTB FIT VFAT (dtb.bin) matching meta-qcom linux-qcom-dtbbin +
# dtb-fit-image for iq-9075-evk:
#   KERNEL_DEVICETREE + LINUX_QCOM_KERNEL_DEVICETREE
#   FIT_DTB_COMPATIBLE from fit-dtb-compatible-linux-qcom.inc (qcs9075-*)
#   mkimage -E -B 8 → qclinux_fit.img in a 4096 KiB VFAT (sector 4096)

let
  # Basename list shipped in the FIT (base .dtb first for ITS ordering).
  fitBlobs = [
    "lemans-evk.dtb"
    "lemans-evk-camera-csi1-imx577.dtbo"
    "lemans-el2.dtbo"
    "lemans-evk-camx.dtbo"
    "lemans-camx-el2.dtbo"
    "lemans-evk-ifp-mezzanine.dtbo"
    "lemans-evk-staging.dtbo"
    "lemans-staging.dtbo"
    "lemans-evk-emmc.dtbo"
    "lemans-evk-sd-card.dtbo"
  ];

  # compatible → ordered fdt stems (base + overlays), meta-qcom linux-qcom.
  fitConfigs = [
    {
      compatible = "qcom,qcs9075-iot";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-camera-csi1-imx577.dtbo"
        "lemans-el2.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-staging";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-camera-csi1-imx577.dtbo"
        "lemans-staging.dtbo"
        "lemans-el2.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-el2gh-staging";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-camera-csi1-imx577.dtbo"
        "lemans-staging.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-camx";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-camx.dtbo"
        "lemans-el2.dtbo"
        "lemans-camx-el2.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-camx-staging";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-camx.dtbo"
        "lemans-el2.dtbo"
        "lemans-camx-el2.dtbo"
        "lemans-staging.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-el2gh-camx";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-camx.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-el2gh-camx-staging";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-camx.dtbo"
        "lemans-staging.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-subtype1";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-ifp-mezzanine.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-subtype1-staging";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-ifp-mezzanine.dtbo"
        "lemans-staging.dtbo"
        "lemans-evk-staging.dtbo"
        "lemans-evk-sd-card.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-subtype1-emmc";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-ifp-mezzanine.dtbo"
        "lemans-evk-emmc.dtbo"
      ];
    }
    {
      compatible = "qcom,qcs9075-iot-subtype1-staging-emmc";
      fdts = [
        "lemans-evk.dtb"
        "lemans-evk-ifp-mezzanine.dtbo"
        "lemans-staging.dtbo"
        "lemans-evk-staging.dtbo"
        "lemans-evk-emmc.dtbo"
      ];
    }
  ];

  fitBlobsFile = writeText "iq9075-fit-blobs.json" (builtins.toJSON fitBlobs);
  fitConfigsFile = writeText "iq9075-fit-configs.json" (builtins.toJSON fitConfigs);

  qcomDtbMetadata = fetchFromGitHub {
    owner = "qualcomm-linux";
    repo = "qcom-dtb-metadata";
    rev = "v1.0";
    hash = "sha256-ItioE8e2LRMMTQlfuFAdnuricj4t1HxNU6EvYzoWfOU=";
  };
in
stdenv.mkDerivation {
  pname = "iq-9075-evk-dtb-bin";
  version = iq-9075-evk-linux.version;

  inherit (iq-9075-evk-linux) src;

  nativeBuildInputs = [
    bc
    bison
    flex
    openssl
    perl
    python3
    dtc
    ubootTools
    dosfstools
    mtools
  ];

  # DTBs only — no Image / modules.
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export ARCH=arm64
    export CROSS_COMPILE=${stdenv.cc.targetPrefix}

    # Same board defconfig as iq-9075-evk-linux (already in patched src).
    make iq9075_evk_defconfig
    make -j''${NIX_BUILD_CORES:-$(nproc)} dtbs

    dtb_dir=arch/arm64/boot/dts/qcom
    for f in ${lib.concatStringsSep " " fitBlobs}; do
      test -f "$dtb_dir/$f" || {
        echo "error: missing $dtb_dir/$f after make dtbs" >&2
        ls -la "$dtb_dir"/lemans* >&2 || true
        exit 1
      }
    done

    mkdir -p fit
    cp -a "$dtb_dir"/. fit/
    dtc -I dts -O dtb -o fit/qcom-metadata.dtb ${qcomDtbMetadata}/qcom-metadata.dts

    python3 - ${fitBlobsFile} ${fitConfigsFile} <<'PY'
import json, pathlib, sys
blobs = json.loads(pathlib.Path(sys.argv[1]).read_text())
configs = json.loads(pathlib.Path(sys.argv[2]).read_text())
out = pathlib.Path("fit/qclinux-fit-image.its")
lines = [
    "/dts-v1/;",
    "",
    "/ {",
    '\tdescription = "Kernel fitImage for IQ-9075 EVK (NixOS / meta-qcom MultiDTB)";',
    "\t#address-cells = <1>;",
    "\timages {",
    "\t\tfdt-qcom-metadata.dtb {",
    '\t\t\tdescription = "Flattened Device Tree blob";',
    '\t\t\ttype = "qcom_metadata";',
    '\t\t\tcompression = "none";',
    '\t\t\tdata = /incbin/("./qcom-metadata.dtb");',
    '\t\t\tarch = "arm64";',
    "\t\t};",
]
for name in blobs:
    lines += [
        f"\t\tfdt-{name} {{",
        '\t\t\tdescription = "Flattened Device Tree blob";',
        '\t\t\ttype = "flat_dt";',
        '\t\t\tcompression = "none";',
        f'\t\t\tdata = /incbin/("./{name}");',
        '\t\t\tarch = "arm64";',
        "\t\t};",
    ]
lines += ["\t};", "\tconfigurations {"]
for i, cfg in enumerate(configs, start=1):
    fdt_list = ", ".join(f'"fdt-{n}"' for n in cfg["fdts"])
    lines += [
        f"\t\tconf-{i} {{",
        '\t\t\tdescription = "FDT Blob";',
        f"\t\t\tfdt = {fdt_list};",
        f'\t\t\tcompatible = "{cfg["compatible"]}";',
        "\t\t};",
    ]
lines += ["\t};", "};", ""]
out.write_text("\n".join(lines))
PY

    (
      cd fit
      mkimage -E -B 8 -f qclinux-fit-image.its qclinuxfitImage
    )

    # meta-qcom: DTBBIN_SIZE=4096 (KiB), QCOM_VFAT_SECTOR_SIZE=4096
    mkfs.vfat -S 4096 -C dtb.bin 4096
    mcopy -i dtb.bin -vsmpQ fit/qclinuxfitImage ::/qclinux_fit.img

    # Contract: Non-Gunyah ParseFitDt path used on IQ-9075 EVK.
    dumpimage -l fit/qclinuxfitImage | grep -q 'qcom,qcs9075-iot'
    dumpimage -l fit/qclinuxfitImage | grep -q 'fdt-lemans-el2.dtbo'
    mdir -i dtb.bin :: | grep -qi 'qclinux_fit.img'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 dtb.bin $out/dtb.bin
    install -Dm644 fit/qclinuxfitImage $out/qclinuxfitImage
    install -Dm644 fit/qclinux-fit-image.its $out/qclinux-fit-image.its
    runHook postInstall
  '';

  meta = {
    description = "IQ-9075 EVK MultiDTB FIT VFAT (dtb.bin / qclinux_fit.img)";
    homepage = "https://github.com/qualcomm-linux/qcom-dtb-metadata";
    license = lib.licenses.gpl2Only;
    platforms = [ "aarch64-linux" ];
  };
}
