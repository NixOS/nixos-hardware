# Asus Zenbook S UX393

## Maximium Battery Charge

If you're primarily using your laptop plugged in, you may want to limit how much the battery charges to preerve the life of the battery.
This laptop is not yet supported by TLP, so you must set the attribute at boot yourself.

``` nix
{
  systemd.services."bat0-charge" = {
    description = "Set BAT0 charge threshold";
    after = [ "systemdudevd.service" ];
    wants = [ "systemd-udevd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        "${pkgs.runtimeShell} -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
    };
  };
}
```

Asus does not support setting `charge_control_begin_threshold`.

## Hardware

### lspci

``` 
00:00.0 Host bridge [0600]: Intel Corporation Device [8086:8a12] (rev 03)
00:02.0 VGA compatible controller [0300]: Intel Corporation Iris Plus Graphics G7 [8086:8a52] (rev 07)
00:04.0 Signal processing controller [1180]: Intel Corporation Device [8086:8a03] (rev 03)
00:07.0 PCI bridge [0604]: Intel Corporation Ice Lake Thunderbolt 3 PCI Express Root Port #0 [8086:8a1d] (rev 03)
00:07.1 PCI bridge [0604]: Intel Corporation Ice Lake Thunderbolt 3 PCI Express Root Port #1 [8086:8a1f] (rev 03)
00:0d.0 USB controller [0c03]: Intel Corporation Ice Lake Thunderbolt 3 USB Controller [8086:8a13] (rev 03)
00:0d.2 System peripheral [0880]: Intel Corporation Ice Lake Thunderbolt 3 NHI #0 [8086:8a17] (rev 03)
00:14.0 USB controller [0c03]: Intel Corporation Ice Lake-LP USB 3.1 xHCI Host Controller [8086:34ed] (rev 30)
00:14.2 RAM memory [0500]: Intel Corporation Device [8086:34ef] (rev 30)
00:14.3 Network controller [0280]: Intel Corporation Killer Wi-Fi 6 AX1650i 160MHz Wireless Network Adapter (201NGW) [8086:34f0] (rev 30)
00:15.0 Serial bus controller [0c80]: Intel Corporation Ice Lake-LP Serial IO I2C Controller #0 [8086:34e8] (rev 30)
00:15.1 Serial bus controller [0c80]: Intel Corporation Ice Lake-LP Serial IO I2C Controller #1 [8086:34e9] (rev 30)
00:16.0 Communication controller [0780]: Intel Corporation Management Engine Interface [8086:34e0] (rev 30)
00:1d.0 PCI bridge [0604]: Intel Corporation Device [8086:34b4] (rev 30)
00:1f.0 ISA bridge [0601]: Intel Corporation Ice Lake-LP LPC Controller [8086:3482] (rev 30)
00:1f.3 Multimedia audio controller [0401]: Intel Corporation Smart Sound Technology Audio Controller [8086:34c8] (rev 30)
00:1f.4 SMBus [0c05]: Intel Corporation Ice Lake-LP SMBus Controller [8086:34a3] (rev 30)
00:1f.5 Serial bus controller [0c80]: Intel Corporation Ice Lake-LP SPI Controller [8086:34a4] (rev 30)
57:00.0 Non-Volatile memory controller [0108]: Intel Corporation SSD 660P Series [8086:f1a8] (rev 03)
```

### lsusb

```
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 003 Device 003: ID 13d3:56cb IMC Networks USB2.0 HD IR UVC WebCam
Bus 003 Device 004: ID 8087:0026 Intel Corp.
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

### Unsupported Hardware

* **Internal microphone input**. This is supported by the Ubuntu Live CD, so supported by Linux, but seems to be incorrectly mapped by PulseAudio.
* **NumberPad 2**. Likely would need entirely new Linux drivers.

## Additional Resources

* Arch Linux Wiki: <none, yet>
