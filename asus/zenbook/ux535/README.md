# Asus Zenbook Pro UX535

Tested on a slightly modified device - the Intel Optane combination SSD was replaced with a higher capacity Sabrent Drive. From Using the Optane Drive without Optane Mode in Windows, I hypothesise that the drive should work assuming the BIOS Settings are Correct - I believe there was a RAID mode I turned off? In Windows, the Optane blocks appeared as a separate drive, I'd suggest maybe use this as Swap?

## ScreenPad:

Configuration for the ScreenPad is unable to be provided here at this time, due to reliance on Additional Modules not included in Nixpkgs. If you want to install the [ScreenPad Kernel Module](https://github.com/Plippo/asus-wmi-screenpad), I recommend using the packaging of it for nix created by [MatthewCash](https://github.com/MatthewCash/asus-wmi-screenpad-module). It can be installed as below:

```nix
# flake.nix
{
  inputs = {

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    screenpad-driver={
        url = "github:MatthewCash/asus-wmi-screenpad-module";
        inputs.nixpkgs.follows="nixpkgs";
      };

  };
  outputs = inputs@{nixpkgs, screenpad-driver, ...}:{

    # Replace hostname with your hostname
    nixosConfigurations.hostname=inputs.nixpkgs.lib.nixosSystem{
      modules = [
        ./configuration.nix
        {
          boot.extraModulePackages = let
            screenpad-driver-package = (kernelPackage:
              let
              asus-wmi-screenpad = screenpad-driver.defaultPackage.${system}.override{kernel=kernelPackage;};
              in [
                asus-wmi-screenpad
              ]
            );
            in (screenpad-driver-package ${yourKernelPackages}.kernel); # Replace ${yourKernelPackages} with the value of your config.boot.kernelPackages, for me, this would be pkgs.kernelPackages_latest
          boot.kernelModules = [
            "asus-wmi-screenpad"
          ];
        }
      ];
    };

  };
}

```

I also recommend writing some kind of script to be able to turn the screenpad On and Off with the correct positioning. If you're using KDE Plasma, feel free to use [mine](https://github.com/Green-D-683/Asus-ScreenPad-Linux). You may also want a script to be able to turn on the main display, as it has an irritating habit of turning itself off, making the screenpad the primary display whenever you plug in a new monitor configuration.

## Battery charging limit:

Due to the common module for ASUS batteries, you can make your battery only charge up to a certain percentage to improve its life. You can place something similar to the following in your configuration to enable it.

```nix
hardware.asus.battery =
{
  chargeUpto = 90;   # Maximum level of charge for your battery, as a percentage.
  enableChargeUptoScript = true; # Whether to add charge-upto to environment.systemPackages. `charge-upto 100` temporarily sets the charge limit to 100%, useful if you're going to need the extra battery on a longer journey.
};
```

## Thunderbolt:

I don't own any Thunderbolt devices to be able to test transfer speeds or PCIe Tunnelling, but I've tested both USB Monitors and Display-Out though the Thunderbolt 3 port and both seem to work well.

## Hardware Lists:

```bash
$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 10th Gen Core Processor Host Bridge/DRAM Registers [8086:9b44] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) [8086:1901] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation CometLake-H GT2 [UHD Graphics] [8086:9bc4] (rev 05)
00:04.0 Signal processing controller [1180]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Thermal Subsystem [8086:1903] (rev 02)
00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th/8th Gen Core Processor Gaussian Mixture Model [8086:1911]
00:12.0 Signal processing controller [1180]: Intel Corporation Comet Lake PCH Thermal Controller [8086:06f9]
00:14.0 USB controller [0c03]: Intel Corporation Comet Lake USB 3.1 xHCI Host Controller [8086:06ed]
00:14.2 RAM memory [0500]: Intel Corporation Comet Lake PCH Shared SRAM [8086:06ef]
00:14.3 Network controller [0280]: Intel Corporation Comet Lake PCH CNVi WiFi [8086:06f0]
00:15.0 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH Serial IO I2C Controller #0 [8086:06e8]
00:15.1 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH Serial IO I2C Controller #1 [8086:06e9]
00:15.2 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH Serial IO I2C Controller #2 [8086:06ea]
00:16.0 Communication controller [0780]: Intel Corporation Comet Lake HECI Controller [8086:06e0]
00:17.0 SATA controller [0106]: Intel Corporation Device [8086:06d3]
00:1b.0 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #21 [8086:06ac] (rev f0)
00:1d.0 PCI bridge [0604]: Intel Corporation Comet Lake PCI Express Root Port #9 [8086:06b0] (rev f0)
00:1d.5 PCI bridge [0604]: Intel Corporation Device [8086:06b5] (rev f0)
00:1f.0 ISA bridge [0601]: Intel Corporation Comet Lake LPC Controller [8086:068d]
00:1f.3 Audio device [0403]: Intel Corporation Comet Lake PCH cAVS [8086:06c8]
00:1f.4 SMBus [0c05]: Intel Corporation Comet Lake PCH SMBus Controller [8086:06a3]
00:1f.5 Serial bus controller [0c80]: Intel Corporation Comet Lake PCH SPI Controller [8086:06a4]
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation TU117M [GeForce GTX 1650 Ti Mobile] [10de:1f95] (rev a1)
01:00.1 Audio device [0403]: NVIDIA Corporation Device [10de:10fa] (rev a1)
02:00.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
03:00.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
03:01.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
03:02.0 PCI bridge [0604]: Intel Corporation JHL7540 Thunderbolt 3 Bridge [Titan Ridge 2C 2018] [8086:15e7] (rev 06)
04:00.0 System peripheral [0880]: Intel Corporation JHL7540 Thunderbolt 3 NHI [Titan Ridge 2C 2018] [8086:15e8] (rev 06)
6c:00.0 USB controller [0c03]: Intel Corporation JHL7540 Thunderbolt 3 USB Controller [Titan Ridge 2C 2018] [8086:15e9] (rev 06)
6d:00.0 Non-Volatile memory controller [0108]: Phison Electronics Corporation E18 PCIe4 NVMe Controller [1987:5018] (rev 01)
6e:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd. RTS522A PCI Express Card Reader [10ec:522a] (rev 01)
```
