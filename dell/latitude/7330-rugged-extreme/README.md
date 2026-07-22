# Dell Latitude 7330 Rugged Extreme

## Hardware

Collected from `dmidecode`, `lscpu`, `lspci -nn`, and `lsusb` on this machine with specific details added from Dell Specifications list:

- CPU: 11th Gen Intel Core i7-1185G7 (Tiger Lake, 4C/8T, 12 MB cache, 28 W, 3.0-4.3 GHz)
- GPU: Intel Iris Xe (integrated, TigerLake-LP GT2)
- RAM: 32 GiB LPDDR4 @ 4267 MT/s (soldered/integrated)
- Storage: Samsung SSD 990 PRO 2TB (NVMe PCIe)
- Wi-Fi: Intel Wi-Fi 6E AX210/AX1675 (802.11ax, PCIe)
- Bluetooth: Intel AX210 Bluetooth (USB)
- Ethernet: Intel I219-LM (PCIe)
- Secondary Ethernet: Realtek RTL8153 (USB, 1 GbE)
- microSD card reader: Realtek RTS525A (PCIe)
- Webcam: Sunplus Integrated_Webcam_FHD (USB, 1080p)
- Security: Broadcom BCM58200 ControlVault 3 (fingerprint + smartcard, USB)
- Speakers: stereo, 2 W x 2 (Realtek ALC3254)
- Thunderbolt: Intel Thunderbolt 4 controllers (2 ports, left + right; one port supports USB 3.2 Gen 2 Type-C with PowerDelivery 3.0)
- Display: 13.3" 1920x1080 internal panel (eDP, Sharp LQ133M1, 59.99 Hz preferred; anti-glare/anti-reflection/anti-smudge, touch, 100% sRGB, up to 1400 nits)
- Battery: dual BAT0/BAT1 Li-poly packs (DELL 6JRCP41, 11.4V, 4.6Ah design; 3-cell 53.5 Wh, hot-swappable)
- BIOS: Dell 1.40.0 (2025-10-28)

## Ports (Not mentioned above)

- 2 x USB-A (USB 3.2 Gen 1, 5 Gbps; one port supports PowerShare)
- 1 x HDMI 2.0
- 1 x RS-232 serial (Part of I/O Expansion Bay installation; combined with Secondary RJ-45 Ethernet)
- 1 x 3.5mm headset (headphone and microphone combo) jack

## Notes (opinionated settings)

- A few of these settings were taken from the OEM Ubuntu image and therefore not prefixed with lib.mkDefault ([blacklisted] kernel modules, TLP settings)
- Sets kernel params for deep sleep, watchdog disabling (to enable sleep without immediate wake), and i915 (graphics)
- Enforces a minimum kernel of 6.1 and enables redistributable firmware to avoid Wi-Fi/BT reliability issues.
- Restarts UPower after resume to refresh dual-battery readings.
- Enables `fprintd` with the Broadcom TOD driver (`fprintd-tod` + `libfprint-2-tod1-broadcom`).
