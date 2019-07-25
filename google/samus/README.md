#Google Samus (aka Google Chromebook Pixel 2015)

##Prerequisites

To be able to properly install, you must first replace the bios firmware. To do so, following steps must be executed

1 - Enable developer mode on your chromebook.
2 - Remove write protect screw on the device
2 - Flash custom bios (highly recommended)

For step 1, https://mrchromebox.tech/#devmode has the needed instructions.

For step 2,  You must then remove the write protect screw in order to flash a custom bios firmware. Video instructions at https://www.youtube.com/watch?v=wOsezY7znZ8.

For step 3, https://mrchromebox.tech/#fwscript, has the needed instructions.

##Install

Currently, only the touchpad driver made for Samus is included. Will later include hidpi settings and such.

The touchpad driver included here is configured specifically for Samus and is much better than the synaptics driver that the NixOS manual recommends.

Move pkgs/ and modules/ to /mnt/etc/nixos/ (or /etc/nixos/ if you're rebuilding). In your configuration.nix file, you must import modules. You'll see that the auto generated configuration.nix file will have written imports like such:

imports = 
  [ # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ];

Add ./modules like such:

imports = 
  [ # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ./modules
  ];

DO NOT include "services.xserver.libinput.enable = true;" in your configuration.nix file. Doing so will let libinput override cmt.

##Current issues

Desktop Environments don't recognize xinput so you will have to manually edit the config file if you want to adjust acceleration, etc.
