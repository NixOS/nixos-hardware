# QNAP TS-233

See the [TS-x33 family documentation][family] for bootloader, installation,
storage layout, and common hardware support.

The 1 GbE jack uses the RK3568 GMAC with the `dwmac_rk` driver, which loads
automatically.

TS-233 revisions with mainboard PCB 12 or newer and backplane PCB 11 or newer
have per-drive power controls. Linux 7.1 and newer provide the composed
`rockchip/rk3568-qnap-ts233-pcb-12-11.dtb` for these revisions. After confirming
both PCB revisions from the VPD EEPROMs, select it with:

```nix
hardware.deviceTree.name = "rockchip/rk3568-qnap-ts233-pcb-12-11.dtb";
```

Older boards must keep the default DTB.

[family]: ../ts-x33
