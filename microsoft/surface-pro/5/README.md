The Surface Pro 5 utilizes the common Surface Pro Intel configuration.

# Physical Volume Buttons
The `pinctrl_sunrisepoint` module needs to load before `soc_button_array` (See discussion [here](https://github.com/NixOS/nixos-hardware/issues/886#issuecomment-2395967278)) to allow the physical volume buttons to work consistently every boot. This is believed to be a race condition between the two modules. The `initrd` setting enforces a load order that consistently yields working buttons.

pinctrl_* seems to be device or board revision specific.


*This module is assuming that all Surface Pro 5's use the same pinctrl_*
The following console command will show what pinctrl_* is present in the system.
```
lsmod | grep pinctrl
```

Then set the following option to the listed `pinctrl_*` type.
```nix
  boot.initrd.kernelModules = [ "pinctrl_*" ];
```
