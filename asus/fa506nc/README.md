# ASUS TUF A15 FA506NC

- GPU switching to the nvidia card works fine through supergfxd.
- Power profiles autoswitch through asusctl in tandem with power-profiles-daemon.
- The batter charge limit configuration through ../battery.nix did not work,
  setting a limit through asusd works.

## Configuring AsusCTL

To declaratively configure asusd you can control the whole config file through
the asusd service (same for fan curves and keyboard leds):

```nix
services.asusd.asusdConfig.text = ''
  (
      charge_control_end_threshold: 80,
      base_charge_control_end_threshold: 80,
      disable_nvidia_powerd_on_battery: true,
      ac_command: "",
      bat_command: "",
      platform_profile_linked_epp: true,
      platform_profile_on_battery: Quiet,
      change_platform_profile_on_battery: true,
      platform_profile_on_ac: Performance,
      change_platform_profile_on_ac: true,
      profile_quiet_epp: Power,
      profile_balanced_epp: BalancePower,
      profile_custom_epp: Performance,
      profile_performance_epp: Performance,
      ac_profile_tunings: {
          Performance: (
              enabled: false,
              group: {},
          ),
          Quiet: (
              enabled: false,
              group: {},
          ),
          Balanced: (
              enabled: false,
              group: {},
          ),
      },
      dc_profile_tunings: {
          Quiet: (
              enabled: false,
              group: {},
          ),
          Balanced: (
              enabled: false,
              group: {},
          ),
          Performance: (
              enabled: false,
              group: {},
          ),
      },
      armoury_settings: {},
  )
'';
```

Here you can set the battery charge limit and other settings like which profile to
use on batter and which on power.

## More optimizations

You may also want to enable thermald and powertop for the optimizations mentioned in
https://nixos.wiki/wiki/Laptop.

```nix
services.thermald.enable = true;
powerManagement.powertop.enable = true;
```
