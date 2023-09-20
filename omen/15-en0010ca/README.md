# HP Omen 15-en0001ca 

## ACPI platform profiles
This config enables `hp-wmi`, which allows switch between cool, balanced, and performance modes on the platform EC, used by power management tools like `power-profile-daemon` and `tlp`.

Note - this is not yet compiled on Nixpkgs provided Kernels as of September 2023. See [the relevant PR](https://github.com/NixOS/nixpkgs/pull/255846).