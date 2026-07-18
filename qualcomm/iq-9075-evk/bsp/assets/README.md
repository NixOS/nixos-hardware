# IQ-9075 NHLOS / GPT assets (QLI-aligned)

Vendored from the QLI reference qcomflash
(`qcom-multimedia-image-iq-9075-evk…qcomflash`) so LUN GPT GUIDs and NHLOS
QDL maps do not drift vs a known-good flash.

| Path | Role |
|------|------|
| `cdt.bin` | CDT for QLI `rawprogram3` (`filename="cdt.bin"`) |
| `gpt/` | Stable GPT binaries (`gpt_main*` / `gpt_backup*`, LUN0–5) matching QLI GUIDs |
| `qdl/` | QLI `rawprogram1–5.xml` + `patch1–5.xml` (LUN0 stays NixOS ptool) |

`dtb.bin` (MultiDTB FIT VFAT) is built by `iq-9075-evk-dtb-bin.nix` from the
board kernel DTBs + `qcom-dtb-metadata` (meta-qcom `dtb-fit-image` /
`linux-qcom-dtbbin` flow), not vendored here.

NHLOS ELF/MBN still come from `QCS9100_bootbinaries_00130` (BOOT …-00508).
