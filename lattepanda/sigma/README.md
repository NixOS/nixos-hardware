# LattePanda Sigma

The [LattePanda Sigma](https://www.lattepanda.com/lattepanda-sigma) is a
high-performance x86 SBC built around the Intel Core i5-1340P (Raptor
Lake-P) with Iris Xe graphics, dual Intel I225-V 2.5 GbE NICs, two
Thunderbolt 4 ports, M.2 NVMe storage, and an M.2 E-key slot for WiFi
(ships with an Intel AX210/AX211).

Everything works with mainline kernels via UEFI; no out-of-tree drivers are
required. This profile does not choose a bootloader — both systemd-boot and
GRUB (EFI) work.

## Known issues

- **Goodix touchscreen probe errors at boot**
  (`Goodix-TS i2c-GDIX1001:00 ... I2C communication failure: -121`): the
  BIOS exposes a touch controller for an optional eDP touch display; when no
  display is attached the probe fails. Harmless.
- **`intel-hid INTC1078:00: failed to enable HID power button`**: harmless
  BIOS quirk.
- The dual I225-V NICs use the `igc` driver. If you see link flapping under
  low-power idle (a known issue on some igc parts), disable PCIe ASPM
  (`boot.kernelParams = [ "pcie_aspm=off" ];`) and Energy-Efficient Ethernet
  (`ethtool --set-eee <iface> eee off`).
