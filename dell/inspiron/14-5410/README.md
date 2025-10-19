# Dell Inpsiron 14 5410

### Hardware
- CPU: Intel® Core™ i7-1195G7
- GPU: Intel® Iris® Xe Graphics

### Module Info
- Enables `services.fwupd` to receive firmware updates from vendors.
- Enables `services.thermald` to achieve better thermal behaviour.

### Other Info
- Use `services.power-profiles-daemon` to enable power savings, other services like `services.tlp` and `services.auto-cpufreq` are not as good and can cause performance issues.
- The new `xe` kernel module causes a flickering effect on bootup, but is otherwise stable enough for minimal use. Enable it with `hardware.intelgpu.driver = "xe"` and configure your kernel parameters (see: <https://wiki.archlinux.org/title/Intel_graphics#Testing_the_new_experimental_Xe_driver>).
