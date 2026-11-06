# Contributing a Device Profile

Please submit your contributions from a feature branch, not from your master branch:

```bash
git checkout -b my-new-hardware-profile
```

## 1. Writing profiles

Create an appropriate directory and start writing your expression.

When setting an option, use `lib.mkDefault` unless:
- The option *must* be set and the user should get an error if they try to
  override it.
- The setting should merge with the user's settings (typical for list or set
  options).

For example:

```nix
{ lib }: {
  # Using mkDefault, because the user might want to disable tlp
  services.tlp.enable = lib.mkDefault true;
  # No need to use mkDefault, because the setting will merge with the user's setting
  boot.kernelModules = [ "tmp_smapi" ];
}
```

Where possible, use module imports to share code between similar hardware
variants. In most cases, import:
- a cpu module;
- a gpu module;
- either the pc or the laptop module;
- either the HDD or the SSD module.

Try to avoid "opinionated" settings relating to optional features like sound,
bluetooth, choice of bootloader etc. You can mention these in the readme.

Profiles should favor usability and stability, so performance improvements
should either be conservative or be guarded behind additional NixOS module
options. If it makes sense to have a performance-focussed config, it can be
declared in a separate profile.

## 2. Optional: Add a README

Profiles can include a `README.md` with device-specific documentation such as:
- Firmware update instructions
- BIOS settings
- Known issues and workarounds
- Links to external resources

See [framework/13-inch/7040-amd/README.md](framework/13-inch/7040-amd/README.md)
for a good example.

## 3. Adding Entry

Add your profile to both `README.md` and `flake.nix`.

**README.md**: Add a row to the table in alphabetical order by manufacturer:

```markdown
| [Manufacturer Model](manufacturer/model)    | `<nixos-hardware/manufacturer/model>`    | `manufacturer-model`    |
```

The columns are:
1. Model name linking to the profile directory
2. Channel path (for `imports = [ <nixos-hardware/...> ]`)
3. Flake module name (for `nixos-hardware.nixosModules.<name>`)

**flake.nix**: Add an entry to the `nixosModules` attribute set:

```nix
manufacturer-model = import ./manufacturer/model;
```

The flake module name should use hyphens (e.g., `dell-xps-15-9500`).

## 4. Multiple Variants

For devices with multiple configurations (e.g., different GPU options), create
subdirectories with a shared base module. For example:

```
dell/xps/15-9560/
├── default.nix          # Base profile (or one default variant)
├── intel/default.nix    # Intel-only variant
├── nvidia/default.nix   # Nvidia variant
└── xps-common.nix       # Shared configuration
```

Each variant needs its own entry in README.md and flake.nix:

```nix
dell-xps-15-9560 = import ./dell/xps/15-9560;
dell-xps-15-9560-intel = import ./dell/xps/15-9560/intel;
dell-xps-15-9560-nvidia = import ./dell/xps/15-9560/nvidia;
```

## 5. Testing

Before opening a pull request, test your profile by pointing to your fork.

**Using channels:**

```bash
sudo nix-channel --add https://github.com/<github-user>/nixos-hardware/archive/<branch>.tar.gz nixos-hardware
sudo nix-channel --update
sudo nixos-rebuild test
```

**Using flakes:**

Update your `flake.nix` input temporarily:

```nix
inputs.nixos-hardware.url = "github:<github-user>/nixos-hardware/<branch>";
```

Then run:

```bash
sudo nixos-rebuild test --flake .
```

You can also run `nix run .#run-tests` to evaluate all hardware profiles.
Because profiles can only be tested with the appropriate hardware, quality
assurance is up to *you*.

## Compatibility

Profiles should work with both NixOS unstable and the current stable release.

## Deprecating Modules

When renaming or removing a module, add deprecation warnings for both flake and
channel users.

**For flake users**, use the `deprecated` helper in `flake.nix`:

```nix
old-module-name = deprecated "issue-number" "old-module-name" (import ./new/path);
```

**For channel users**, add an assertion in the old module's `default.nix`:

```nix
{ ... }:

{
  assertions = [
    {
      assertion = false;
      message = "Importing path/to/old/module (default.nix) directly is deprecated! See https://github.com/NixOS/nixos-hardware/blob/master/path/to/DEPRECATION.md for more details";
    }
  ];
}
```

Include a markdown file explaining the migration path. See
[asus/zephyrus/ga402x/ATTR-SET-DEPRECATION.md](asus/zephyrus/ga402x/ATTR-SET-DEPRECATION.md)
for an example.

## Getting Help

For questions and discussions, join us in the
[#nixos-hardware:nixos.org](https://matrix.to/#/#nixos-hardware:nixos.org)
Matrix channel.

# For reviewers:

Any nixpkgs committer can review and approve pull requests in this repository.

This repository uses GitHub merge queues for merging pull requests.

## Review checklist

1. **README.md entry**: Verify the contribution adds the device to the table in README.md
2. **flake.nix entry**: Verify the profile is exposed in flake.nix
3. **Common profiles**: Since testing on real hardware isn't always possible,
   check that the profile re-uses appropriate common profiles (e.g., cpu, gpu,
   laptop/pc, ssd/hdd modules)
4. **Previous contributors**: For changes to existing profiles, consider
   requesting feedback from previous contributors who may have access to the
   hardware
