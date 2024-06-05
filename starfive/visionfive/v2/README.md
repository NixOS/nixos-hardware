# Creating a SD-Image

Create and configure the `flake.nix` file:
``` nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";

  # Some dependencies of this flake are not yet available on non linux systems
  inputs.systems.url = "github:nix-systems/x86_64-linux";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.systems.follows = "systems";

  outputs = { self, nixpkgs, nixos-hardware, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        packages.default = packages.sd-image;
        packages.sd-image = (import "${nixpkgs}/nixos" {
          configuration =
            { config, ... }: {
              imports = [
                "${nixos-hardware}/starfive/visionfive/v2/sd-image-installer.nix"
              ];

              # If you want to use ssh set a password
              # users.users.nixos.password = "super secure password";
              # OR add your public ssh key
              # users.users.nixos.openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];

              # AND configure networking
              # networking.interfaces.end0.useDHCP = true;
              # networking.interfaces.end1.useDHCP = true;

              # Additional configuration goes here

              sdImage.compressImage = false;

              nixpkgs.crossSystem = {
                config = "riscv64-unknown-linux-gnu";
                system = "riscv64-linux";
              };

              system.stateVersion = "23.05";
            };
          inherit system;
        }).config.system.build.sdImage;
      });
}
```

Build the sd image.

``` sh
nix build .#
```

# Updating the bootloader
## SD-Card
Install the firmware update script
``` nix
environment.systemPackages = [
  (pkgs.callPackage
    "${nixos-hardware}/starfive/visionfive/v2/firmware.nix"
    { }).updater-sd
];
```
Then run as root
``` sh
visionfive2-firmware-update-sd
```
## SPI Flash
Install the firmware update script
``` nix
environment.systemPackages = [
  (pkgs.callPackage
    "${nixos-hardware}/starfive/visionfive/v2/firmware.nix"
    { }).updater-flash
];
```
Then run as root
``` sh
visionfive2-firmware-update-flash
```

