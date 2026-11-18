# Banana Pi BPI-R4 Pro (MediaTek MT7988A)

NixOS support for the [Banana Pi BPI-R4 Pro](https://www.banana-pi.org/) router
board, built around the MediaTek MT7988A SoC (4× Cortex-A73, aarch64).

> **Note on the kernel pin.** This module builds nixpkgs' `linux_6_18` pinned
> to a specific point release (see `linux.nix`, `patchBase`), because the
> OpenWrt MT7988 networking delta in `patches/` is rebased onto that exact
> kernel. It is deliberately NOT a tracking kernel: following nixpkgs' 6.18.x
> bumps would rebase the patch set on every unrelated nixpkgs update. Moving
> the pin forward is a single unit of work together with rebasing the patches.

## Hardware (4E variant)

| Component | Detail |
| --------- | ------ |
| SoC | MediaTek MT7988A (4× Cortex-A73, aarch64) |
| Switch | MT7988 internal GSW + MaxLinear MxL86252 (10G) |
| Network | 1× 1G RJ45 (internal switch port 0), 4× 2.5G RJ45 (MxL86252), 1× 10G SFP+ LAN, 1× 2.5G RJ45 / 10G SFP+ WAN combo |
| Wi-Fi | MT7996 (optional, host AP) |
| Storage | microSD (boot chain), optional NVMe (root) |
| Firmware | built from source: BL2 + ARM-TF FIP + U-Boot with `CONFIG_EFI_LOADER` |

## Why a patched kernel

Mainline `mtk_eth_soc` has **no USXGMII/SerDes support**, so the on-board 10G
switch (MxL86252) CPU conduit and the SFP+ cages cannot come up: the 10G
WAN/LAN is simply unsupported on mainline. The module therefore builds
nixpkgs' `linux_6_18` with the OpenWrt MT7988 networking delta (mtk_eth_soc
USXGMII + DSA mxl862xx + PCS mtk-usxgmii/lynxi), plus the AS21010 10G PHY and
TX-timeout recovery fixes (see `patches/`, GPL-2.0, via the
`ly4096x/BananaPi-R4-Pro-8X-OS` tree).

The board DTS itself only landed upstream in Linux 6.19, and its dtsi does not
compile against the 6.18 `mt7988a.dtsi`. This module therefore ships a
self-contained, resolved DTS (`dtb/mt7988a-bananapi-bpi-r4-pro-4e-sd.dts`) and
compiles it with `dtc` instead of building it from the kernel source.

## Usage

```nix
{
  imports = [
    # Pulls in ./efi.nix itself: systemd-boot on an ESP is the default.
    nixos-hardware.nixosModules.bananapi-bpi-r4-pro
    # Writes the U-Boot env (`bootcmd=bootflow scan -lb` + fallback cmdline).
    # The per-generation command line lives in systemd-boot's loader entries.
    (nixos-hardware + "/bananapi/bpi-r4-pro/uboot-env.nix")
  ];

  hardware.bananapi.bpi-r4-pro.enable = true;
  # NixOS owns the bootloader: ./efi.nix installs systemd-boot (with
  # --no-variables) and keeps 20 generations selectable on the serial console.
}
```

The module exposes:

- `hardware.bananapi.bpi-r4-pro.enable` — board support (this is the only
  mandatory switch).
- `hardware.bananapi.bpi-r4-pro.extraKernelParams` — extra kernel parameters
  appended to the board bootargs.
- `hardware.bananapi.bpi-r4-pro.efiBoot` (default `true`) — boot via U-Boot's
  EFI loader + systemd-boot on an ESP. Setting it `false` is only meaningful
  with `buildFirmware = false`; see the assertion in `./efi.nix`.
- `hardware.bananapi.bpi-r4-pro.buildFirmware` (default `true`) — build BL2 and
  the FIP from source instead of using the signed vendor OpenWrt firmware.
  Required by `efiBoot`: the vendor U-Boot has no `bootefi`, so an ESP would be
  unbootable.
- `hardware.bananapi.bpi-r4-pro.atfPackage` / `ubootPackage` — override the ATF
  and U-Boot derivations.
- `hardware.bananapi.bpi-r4-pro.kernelCheck` (default `true`) — build-time
  guard that fails if the kernel loses the MT7988 ethernet + DSA drivers.

Build artifacts: `config.system.build.bpiR4ProBl2`,
`config.system.build.bpiR4ProFip` and `config.system.build.bpiR4ProUbootEnv`.

The module does **not** assemble the SD card or the root filesystem. That is
host policy (partition sizes, which generations go on the ESP), so it lives
outside the module — see the `mk-sd-image.sh` in the consuming repo for a
worked example.

## Boot chain

The MT7988 boot chain finds its pieces **by name at fixed offsets** on the
microSD, so this layout is not a free choice:

```
cold power-on (or a reset, which re-enters at BL2)
  -> MTK BootROM -> BL2 (SD sector 34, raw — not a partition)
  -> BL2 reads the GPT and loads the ARM-TF FIP from the partition NAMED "fip"
     (if absent: "Partition 'fip' not found" -> "System halt!")
  -> BL31 + BL33 / our U-Boot (CONFIG_EFI_LOADER)
  -> bootcmd = run bootflow scan -lb   (U-Boot EFI boot manager)
  -> EFI/BOOT/BOOTAA64.EFI on the ESP -> systemd-boot
  -> loader/entries/nixos-generation-<N>.conf  (each carries its own init=)
  -> NixOS (console ttyS0)
```

So the card must carry a GPT with `fip` (for BL2) and `ESP` (for U-Boot). A
representative geometry:

| # | name | start (sector) | size (sectors) | note |
| - | ---- | -------------- | -------------- | ---- |
| 1 | bl2 | 34 | 8158 | BootROM/BL2 preloader (raw, outside the GPT) |
| 2 | ubootenv | 8192 | 1024 | U-Boot env (`bootcmd` + fallback cmdline) |
| 3 | factory | 9216 | 4096 | vendor calibration |
| 4 | fip | 13312 | 8192 | ARM-TF FIP + U-Boot (BL2 loads by name) |
| 5 | ESP | 102400 | 2097152 (1 GiB) | FAT32: `BOOTAA64.EFI` + kernel+initrd per generation |
| 6 | root | after ESP | fills | root filesystem |

The ESP needs roughly 1 GiB, not 256 MiB: `systemd-boot.configurationLimit`
keeps 20 generations and each carries its own kernel and initrd, so a small ESP
fills on the second generation with `ENOSPC`.

Because the firmware is built here rather than taken from a vendor image, a
fresh card is self-sufficient — no "flash a stock OpenWrt card first" step.
Signing is deliberately off: `TRUSTED_BOARD_BOOT` gates only verification of the
FIP and retail boards ship with eFuses unblown, so BL2 loads an unsigned FIP.

### Why EFI and not a FIT

The board used to boot a raw FIT out of a `production` partition. A FIT carries
its command line *inside* the image, and that cmdline contains an absolute
`init=/nix/var/nix/profiles/system/init` — a pointer to whatever generation
existed when the FIT was built. U-Boot overwrites `/chosen/bootargs` from its
env, so the FIT had to be reflashed on every generation change. When it lagged,
the board booted an old kernel against new `kernel-modules`, came up with no
network, and needed the serial console to recover; flashing a trial generation
pinned every reboot to the trial.

An ESP removes that class of failure: `nixos-rebuild boot` writes a new loader
entry, old ones stay selectable, and nothing is reflashed. The FIT path was
functional, not broken — it was retired because it made bootloader state an
image concern.

## `init=` and `root=`

Two details are load-bearing on this board and are already handled by
`uboot-env.nix`:

- `init=/nix/var/nix/profiles/system/init` is **mandatory** — NixOS's systemd
  initrd discovers the system closure only from `init=` on the kernel command
  line.
- `root=fstab` (not a `root=` device) — with a systemd initrd, `fileSystems."/"`
  already carries `x-initrd.mount`, so `systemd-fstab-generator` creates
  `sysroot.mount` from it. Passing a device as well makes it try to create
  `sysroot.mount` twice and bail out of generating the rest, so any
  `fsNeededForBoot` mount (e.g. `/persist`) never mounts.

`pci=pcie_bus_perf` is required for the NVMe to enumerate (mtk-pcie-gen3 fails
link training without it), and `clk_ignore_unused` / `pd_ignore_unused` keep the
MT7988 net driver's clock/power blocks from being gated before it probes.

## Status

Validated on the 4E board:

- the full boot chain through our own BL2 + FIP + U-Boot: BL2 -> BL31 ->
  U-Boot -> EFI -> systemd-boot -> NixOS, over the serial console (`ttyS0`).
  This holds for both a **cold power-on** and a **hot reboot** (no intervening
  power cycle) -- each handoff's console marker is present in both cases
- selecting a generation interactively from the systemd-boot menu on the serial
  console: non-default entries boot
- internal-switch 1G jack, MxL86252 2.5G jacks, 10G SFP+ via the patched kernel
- NVMe root (with `pci=pcie_bus_perf`)
- reboot resets (watchdog `SWSYSRST_EN` before `SWRST`, `efi=no_runtime` so
  PSCI owns reset/poweroff, plus the `dev_reboot`/`dev_smc` userspace tools)
- Wi-Fi AP: the MT7996 runs hostapd on all three bands (2.4/5/6 GHz), with the
  VAPs bridged onto the tenant VLAN planes and real clients passing traffic
  through them

Not yet validated — do not assume these work:

- **Poweroff.** Reset is proven; shutdown to a fully powered-off state is not.
  Treat it as unproven rather than broken until tested.

Known issues:

- The `-iphy` overlay config is mapped to the resolved DTB; per-port 10G PHY
  tuning is out of scope here.
- 10G SFP+ link behaviour depends on the module in the cage.
- The shipped `dtb/mt7988a-bananapi-bpi-r4-pro-4e-sd.dts` is a resolved
  (decompiled) DTS. Mainline now carries
  `arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-4e.dts` and its
  `-r4-pro.dtsi`; they do not currently compile against the 6.18
  `mt7988a.dtsi` (symbol drift, e.g. `ssusb0`), which is why the resolved DTS
  exists. Revisit when the board kernel moves forward.
