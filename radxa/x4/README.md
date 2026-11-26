# Radxa X4

The [Radxa X4](https://radxa.com/products/x/x4/) is a credit-card-sized x86
SBC based on the Intel N100 (Alder Lake-N), with an Intel I226-V 2.5 GbE NIC,
a Realtek RTL8852BE WiFi 6 / Bluetooth 5.2 module, an M.2 2230 slot for NVMe
storage, optional onboard eMMC, and a Raspberry Pi RP2040 microcontroller
wired to the GPIO header.

The board boots mainline kernels via UEFI; no out-of-tree drivers are
required. This profile does not choose a bootloader — both systemd-boot and
GRUB (EFI) work.

## Ethernet (Intel I226-V)

The I226-V has a widely reported firmware/hardware bug where the link stalls
or flaps (repeated `Link Down` / `Link is Up` cycles in dmesg) when the NIC
enters PCIe ASPM low-power states or Energy-Efficient Ethernet idle. This
profile applies the two standard mitigations:

- `pcie_aspm=off` on the kernel command line
- a udev rule that disables EEE on `igc` interfaces via ethtool

If you need ASPM for the rest of the system, override `boot.kernelParams`
and disable ASPM for the NIC's root port only (e.g. via `setpci`).

References:

- https://bugzilla.kernel.org/show_bug.cgi?id=216045
- https://lore.kernel.org/intel-wired-lan/

## Known issues

- **ACPI errors at boot** (`\_SB.PC00.TXHC.RHUB...` / `\_SB.UBTC.RUCC`
  `AE_NOT_FOUND`): bugs in the stock BIOS tables; harmless.
- **`intel_ish_ipc ... Timed out waiting for FW-initiated reset`**: the
  Integrated Sensor Hub has no firmware on this board. Harmless; silence it
  with `boot.blacklistedKernelModules = [ "intel_ish_ipc" ];` if desired.
- The RP2040 enumerates on USB and is flashed with `picotool`; nothing
  NixOS-specific is required.
