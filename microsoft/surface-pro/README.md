# Common issue with Physical Volume Buttons
The System-On-Chip (SOC) specific module, `pinctrl_sunrisepoint` on the Surface Pro 5 for example, needs to load before the `soc_button_array` (See discussion [here](https://github.com/NixOS/nixos-hardware/issues/886#issuecomment-2395967278)) module to allow the physical volume buttons to work consistently every boot. This _may_ not be required on all MS Pro models, but has been observed on at least two of the models. This is believed to be a race condition between the two modules. The `initrd` setting enforces a load order that consistently yields working buttons.

the needed `pinctrl_*`` seems to be device or board revision specific.

The following console command will show what pinctrl_* is present in the system.
```
lsmod | grep pinctrl
```

Then set the following option to the listed `pinctrl_*` type.
```nix
  boot.initrd.kernelModules = [ "pinctrl_*" ];
```

The following table shows known SOC modules

| Surface Pro Model | SOC Modules            |
| ----------------- | ---------------------- |
| 5                 | `pinctrl_sunrisepoint` |
| 7                 | `pinctrl_icelake`      |
