# NixOS support for Radxa devices

Radxa provides the NixOS implementation in the form of `nixos-hardware` modules
for advanced users.

Our goals are:

* Only use `nixpkgs` provided packages.
* Provide a consistent and simple experience to use our NixOS module.
* Targetted audiences are advanced users who care mostly about CPU compute, storage, and network.
* No support guarantee. We are not here to teach people how to use NixOS.

We explicitly want to avoid packaging the entire vendor SDK bootloader and kernel
in Nix. Those are not going to be accepted in `nixpkgs`, and our targetted audiences
like homelabbers generally ignore the additional hardware features.

This also aligns with [NixOS on ARM](https://wiki.nixos.org/wiki/NixOS_on_ARM)'s
definition of "support":

> Support for those board assumes as much is supported as Mainline Linux supports.

## Characteristic of the default profiles

* Using `linuxPackages_latest`
* `bcachefs` rootfs with zstd compression and password-less encryption enabled
* EFI boot chain provided by `systemd-boot`
* Default serial console enabled with baud rate matches the platform firmware
* No automatic partition expansion, as the module is only focusing on hardware

## Common Nix flake pattern

Below is an annoated flake example to create the initial boot image.

```
{
  description = "Example NixOS configurations for Radxa product";
  # To build, run `nix build .#nixosConfigurations.radxa.config.system.build.diskoImages`

  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unfree.url = "github:numtide/nixpkgs-unfree/nixos-unstable";
  };

  outputs = inputs@{
    self,
    disko,
    nixos-hardware,
    nixpkgs,
    nixpkgs-unfree,
  }: {
    nixosConfigurations = {
      radxa = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.rock-4c-plus  # Update the system according to your device.
          disko.nixosModules.disko                  # disko usage is optional in the running system, but we need it to generate the initial boot image.
          "${nixos-hardware}/radxa/disko.nix"       # Common Radxa Disko profile. it is system-agnostic.
          {
            disko = {
              imageBuilder = {
                # Avoid double emulation to significantly speed up image building process.
                # Update the system according to your host system.
                # See https://github.com/nix-community/disko/issues/856
                qemu = nixpkgs.legacyPackages.x86_64-linux.qemu + "/bin/qemu-system-aarch64 -M virt -cpu cortex-a57";
              };
              # Default image size is 2G for a small basic CLI system.
              # devices.disk.main.imageSize = "2G";
            };

            # Override the default bootloader with a cross built one.
            # Use this if you do not have binfmt configured on your system.
            # For NixOS, please add `boot.binfmt.emulatedSystems = [ "aarch64-linux" ];` to your system configuration.
            # Update the system and the firmware package according to your device.
            # hardware.radxa.rock-4c-plus.platformFirmware = nixpkgs-unfree.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform.ubootRock4CPlus;

            users.users.radxa = {
              isNormalUser = true;
              initialPassword = "radxa";
              extraGroups = [ "wheel" ];
            };
            services.openssh.enable = true;
            networking.hostName = "radxa";
            system.stateVersion = "24.11";
          }
        ];
      };
    };
  };
}
```
