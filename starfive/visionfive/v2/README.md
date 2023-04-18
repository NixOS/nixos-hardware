# Creating a SD-Image

Create and configure the `flake.nix` file:
``` nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, nixos-hardware, flake-utils }:
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

              # If you have the 2A variant uncomment the following line
              # hardware.deviceTree.name =
              #   lib.mkDefault "starfive/jh7110-starfive-visionfive-2-v1.2a.dtb";

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
