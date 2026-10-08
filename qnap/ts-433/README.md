# QNAP TS-433

See the [TS-x33 family documentation][family] for bootloader, installation,
storage layout, and common hardware support.

The 1 GbE jack uses the RK3568 GMAC with the `dwmac_rk` driver. The upper 2.5
GbE jack uses a PCIe RTL8125B with the in-tree `r8169` driver. Both drivers load
automatically; the profile enables redistributable firmware for the RTL8125B.

TS-433 revisions with mainboard PCB 12 or newer and backplane PCB 10 or newer
have per-drive power controls. Linux 7.1 and newer provide the composed
`rockchip/rk3568-qnap-ts433-pcb-12-10.dtb` for these revisions. After confirming
both PCB revisions from the VPD EEPROMs, select it with:

```nix
hardware.deviceTree.name = "rockchip/rk3568-qnap-ts433-pcb-12-10.dtb";
```

Older boards must keep the default DTB.

[family]: ../ts-x33
