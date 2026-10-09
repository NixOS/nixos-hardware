# Lenovo IdeaPad Gaming 3 15IAH7

This profile provides configuration for the Lenovo IdeaPad Gaming 3 15IAH7 (82S9).

## Features
- **CPU:** Intel 12th Gen (Alder Lake) support.
- **GPU:** Hybrid graphics support via NVIDIA Prime (Ampere).
- **Battery & Hardware Control:** Specialized group and permissions for IdeaPad-specific ACPI features.

## Hardware Control
This profile creates a Unix group called `ideapad_laptop`. Users in this group can modify hardware settings in `/sys/bus/platform/drivers/ideapad_acpi/` without root privileges.

To enable this for your user:
```nix
users.users.yourusername.extraGroups = [ "ideapad_laptop" ];
```

Once added, you can toggle features like **Conservation Mode** (limits charge to 60% to extend battery lifespan) via the command line:
```bash
# Enable Conservation Mode
echo 1 > /sys/bus/platform/drivers/ideapad_acpi/pnp*/conservation_mode
```

## NVIDIA Prime
This laptop uses a hybrid GPU setup. While this profile enables the driver pattern, you must define the exact PCI Bus IDs in your `configuration.nix` if they differ from the defaults:

```nix
hardware.nvidia.prime = {
  intelBusId = "PCI:0:2:0";
  nvidiaBusId = "PCI:1:0:0";
};
```
*Note: You can find these IDs by running `lspci | grep -E "VGA|3D"`.*
