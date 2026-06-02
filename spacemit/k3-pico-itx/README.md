# SpacemiT K3 Pico-ITX

NixOS support for the [SpacemiT K3 Pico-ITX](https://www.spacemit.com/community/document/info?nodepath=hardware%2Feco%2Fk3_pico%2Fpico_user_guide.md&lang=en) single-board
computer, built around the SpacemiT K3 SoC (RVA23 RISC-V).

## Hardware

| Component | Detail |
| --------- | ------ |
| SoC | SpacemiT K3 (RVA23, 64-bit RISC-V) |
| CPU | 16 cores: 8× X100 @ 2.4 GHz + 8× A100 @ 2.0 GHz |
| Memory | LPDDR5, up to 32 GB |
| Storage | PCIe Gen3 ×4 (NVMe), internal UFS, microSD |
| Network | RTL8211F 1GbE (`end0`), RTL8127 10GbE (PCIe), RTL8852BE Wi-Fi 6 (PCIe) |
| Firmware | EDK2 UEFI + U-Boot + OpenSBI |

## Usage

Add the module to your configuration:

```nix
{
  imports = [
    "${nixos-hardware}/spacemit/k3-pico-itx"
  ];
}
```

This gives you the base setup with the vendor `linux-6.18` kernel and
EDK2/U-Boot/OpenSBI. I plan to move to the mainline kernel.

### Building an SD-image

```nix
{
  imports = [
    "${nixos-hardware}/spacemit/k3-pico-itx/sd-image.nix"
  ];

  # Set a password or add an SSH key so you can log in
  # users.users.nixos.password = "changeme";
  # users.users.nixos.openssh.authorizedKeys.keys = [ "ssh-ed25519 ..." ];
}
```

```sh
nix build .#sd-image
```

## Cache

To install and update your system I set up a binary cache:
`build05.ynh.ovh`
This saves you from compiling everything locally.
Here is how to add it to your configuration:

```nix
nix.settings = {
  substituters = [ "https://build05.ynh.ovh" ];
  trusted-public-keys = [
    "build05.ynh.ovh:bLxWKPjbKYOFxqrjOxv+cdwS3kFLuHEf1k6j8fAxbzM="
  ];
};
```

Here is how to use it without adding it to your configuration:

```sh
sudo nix-channel --add https://channels.nixos.org/nixos-26.05 nixos
sudo nix-channel --update

nix build \
  --substituters https://build05.ynh.ovh \
  --trusted-public-keys "build05.ynh.ovh:bLxWKPjbKYOFxqrjOxv+cdwS3kFLuHEf1k6j8fAxbzM="
```

PS: This is a cache maintained on a voluntary basis for the K3 and riscv64
hardware. I can't guarantee its availability, nor that everything is already
built on it. The Hydra infrastructure is still being deployed, so please be
lenient in that regard.

## HMP configuration

The X100 and A100 clusters have different vector widths (`VLENB=32` vs `VLENB=128`).

You can configure HMP at runtime:

`echo strict > /sys/kernel/spacemit_hmp/mode` (default)

or

`echo permissive > /sys/kernel/spacemit_hmp/mode`

Permissive mode lets you use the 8 A100 cores in addition to the X100 cores.
However, I deliberately apply a segmentation between the two clusters because of a
VLEN issue.

If you force tasks across both clusters anyway (e.g. via `taskset`), it will cause
crypto corruption.

I also made a small module for this:

```nix
hardware.spacemit.hmp = {
  enable = true;
  mode = "permissive"; # or "strict"
};
```

- **`strict`** (default): uses the X100 cores only.
- **`permissive`**: uses both the X100 and A100 cores, but with a segmentation
  between the clusters.

An alternative is still available to use all 16 cores without segmentation, with
this:

```nix
environment.variables.OPENSSL_riscvcap = "RV64GC";
```

## UEFI

To get UEFI I made a small script, to be run from Bianbu:

https://github.com/liberodark/k3-uefi-flash

## Status

Working:

- Boot to NixOS, SSH reachable
- NVMe root (PCIe Gen3 ×4), 1GbE (`end0`)
- All 16 cores usable (see HMP notes above)

Known issues:

- I noticed a reboot issue, so I force it with `reboot -ff`.

## Upstream status

- [Kernel](https://github.com/spacemit-com/linux/wiki)
- [OpenSBI](https://github.com/spacemit-com/opensbi-upstream/wiki)
- [U-Boot](https://github.com/spacemit-com/u-boot/wiki)
- [LLVM/GCC](https://github.com/spacemit-com/.github/blob/main/upstream-status/toolchain.md)
- [llama.cpp](https://github.com/spacemit-com/llama.cpp/wiki)
