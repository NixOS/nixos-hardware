# Qualcomm QRB2210 / QCM2290 SOC family support

## 1. Supported devices

- [Arduino UNO Q](https://docs.arduino.cc/hardware/uno-q) (**arduino-uno-q**, board codename **Imola**) — device tree `qcom/qrb2210-arduino-imola.dtb`, Arduino U-Boot fork, Linux kernel with Armbian `qrb2210-edge` patches, Qualcomm firmware and qcombin flash assets. Flashing uses [arduino-flasher-cli](https://github.com/arduino/arduino-flasher-cli) and an `arduino-images/` bundle (see below).

## 2. NixOS modules

| Flake module | Purpose |
|--------------|---------|
| `qualcomm-qrb2210` | BSP overlay, kernel, firmware, extlinux defaults for any QRB2210 board |
| `arduino-uno-q` | Imola device tree; imports `qualcomm-qrb2210` |
| `arduino-uno-q-sd-image` | Full NixOS image + `arduino-image-output.nix` (`arduino-images/` for flasher-cli) |

### 2.1 Base profile (`qualcomm-qrb2210`)

```
{ nixos-hardware, ... }: {
  system = "aarch64-linux";
  specialArgs.buildSystem = "x86_64-linux"; # optional cross-build on x86_64
  modules = [
    nixos-hardware.nixosModules.qualcomm-qrb2210
  ];
}
```

Cross-compiling from x86_64 is enabled when `specialArgs.buildSystem` is set (see `cross.nix`).

### 2.2 Arduino UNO Q (`arduino-uno-q`)

Board-specific device tree on top of the base profile:

```
{ nixos-hardware, ... }: {
  system = "aarch64-linux";
  specialArgs.buildSystem = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.arduino-uno-q
  ];
}
```

Do not list `qualcomm-qrb2210` separately; `arduino-uno-q` already imports it.

### 2.3 Full system image (`arduino-uno-q-sd-image`)

Use in a consumer flake when you need a complete NixOS rootfs plus an `arduino-images/` tree (ESP + root partition slices and `flash/` payloads):

```
{ nixos-hardware, ... }: {
  system = "aarch64-linux";
  specialArgs.buildSystem = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.arduino-uno-q-sd-image
    ({ ... }: {
      system.stateVersion = "25.05";
      fileSystems."/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
      networking.hostName = "arduino-uno-q";
    })
  ];
}
```

```bash
nix build .#nixosConfigurations.<name>.config.system.build.sdImage
mkdir -p ./flash-out && tar xf result/*-arduino-flash.tar -C ./flash-out
arduino-flasher-cli flash ./flash-out/arduino-images/
```

On first boot from eMMC, use a consumer-side resize module (GPT root on partition 68) and set `sdImage.expandOnBoot = false`.

## 3. Building boot images

Boot-only bundles (no NixOS rootfs) can be built directly from this flake:

```bash
nix build github:NixOS/nixos-hardware#packages.aarch64-linux.arduino-uno-q-boot
# or
nix build .#packages.aarch64-linux.arduino-uno-q-boot
```

Output layout: `./result/arduino-images/flash/` (qcombin tree + `boot.img`).

**Note:** Targets `aarch64-linux`. On `x86_64-linux`, use remote builders for `aarch64-linux` (same as NXP i.MX boot packages).

## 4. Flashing

Install [arduino-flasher-cli](https://github.com/arduino/arduino-flasher-cli), put the board in the appropriate download mode, then:

```bash
# Boot / EDL payloads only (§3)
arduino-flasher-cli flash ./result/arduino-images/

# Full NixOS (§2.3) after extracting the flash tarball
arduino-flasher-cli flash ./flash-out/arduino-images/
```

See [Arduino UNO Q — update image](https://docs.arduino.cc/tutorials/uno-q/update-image/) for board-specific steps.

## 5. Upstream documentation

### Board and tooling

- [Arduino UNO Q documentation](https://docs.arduino.cc/hardware/uno-q)
- [Arduino U-Boot fork](https://github.com/arduino/u-boot) (Imola `DEVICE_TREE`)
- [arduino-flasher-cli](https://github.com/arduino/arduino-flasher-cli)

### Kernel and BSP references

- [Armbian QRB2210 kernel patches](https://github.com/armbian/build/tree/main/patch/kernel/qrb2210-edge)
- [Armbian Arduino image output](https://github.com/armbian/build/blob/main/extensions/image-output-arduino.sh)
