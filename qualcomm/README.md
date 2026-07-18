# Qualcomm boards

## IQ-9075 EVK

BSP aligned with opensource Qualcomm Linux [meta-qcom](https://github.com/qualcomm-linux/meta-qcom) `iq-9075-evk` and [qcom-deb-images](https://github.com/qualcomm-linux/qcom-deb-images) `lemans-evk`:

- Kernel: [qualcomm-linux/kernel](https://github.com/qualcomm-linux/kernel) `qcom-6.18.y`
- U-Boot: [qualcomm-linux/u-boot](https://github.com/qualcomm-linux/u-boot) `qcom_lemans_defconfig`
- Partitions: [qcom-ptool](https://github.com/qualcomm-linux/qcom-ptool) `iq-9075-evk/ufs`
- NHLOS: QCS9100 boot binaries **00130** (BOOT.MXF …-**00508**, Non-Gunyah) + RB8 CDT

### Module

```
{ nixos-hardware, }: {
  system = "aarch64-linux";
  modules = [
    nixos-hardware.nixosModules.qualcomm-iq-9075-evk
  ];
}
```

Serial: `ttyMSM0` @ 115200. Loader: systemd-boot on ESP (Type2 UKI). Rootfs: UFS `PARTLABEL=rootfs` via NixOS fstab.

### Build

NHLOS blobs are unfree; allow them when building the boot package:

```bash
NIXPKGS_ALLOW_UNFREE=1 nix build --impure .#packages.aarch64-linux.iq-9075-evk-boot
# → result/image/                  (U-Boot, Image, lemans-evk.dtb)
# → result/flash_lemans-evk_ufs/   (QDL flash dir: firehose, XBL, CDT, ptool XMLs, …)
# → result/deploy/                 (partition sources + firmware mirror)
```

Full NixOS rootfs images: [nixos-edge-platforms](https://github.com/NixOS/nixos-edge-platforms) `iq-9075-evk-rootfs-image` (provides ordered `flash.sh`).

### Boot binary sources

| Artifact | Source |
| -------- | ------ |
| Boot bins | `…/QCS9100_bootbinaries.1.0/…/`**`00130`**`/QCS9100_bootbinaries.zip` (meta-qcom `firmware-qcom-boot-qcs9100_00130`) |
| CDT | Codelinaro `…/QCS9100/cdt/rb8_core_kit.zip` → `cdt_rb8_core_kit.bin` |

Do **not** use Meta_Build_ID **00123** (BOOT …-00479 / Gunyah path).

### Flashing

IQ-9075 uses **QDL** on UFS (not `dd` to SD). Prefer the ordered `flash.sh` from the edge-platforms rootfs image. Do **not** pass alphabetical `rawprogram*.xml` (that programs LUN0 first).

Optional SAIL NOR (if `sail_nor/` is present):

```bash
cd result/flash_lemans-evk_ufs/sail_nor
qdl --storage spinor prog_firehose_ddr.elf rawprogram0.xml patch0.xml
```

See [Qualcomm IQ-9075 EVK user guide](https://docs.qualcomm.com/doc/80-80020-261/topic/iq9-ug-update-the-sw.html).
