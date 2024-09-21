# Contributing a Device Profile

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

## 2. Adding Entry

Link the profile in the table in README.md and in flake.nix.

## 3. Testing

Run `nix run ./tests#run .` to evaluate all hardware profiles.
Because profiles can only be tested with the appropriate hardware, quality
assurance is up to *you*.

# For reviewers:

This repository has bors enabled for easier merging after a successfull build:

* `bors try` - check if the PR builds.
* `bors merge` - same as `bors try` but will also merge the PR if it builds successfully.
* https://bors.tech/documentation/
