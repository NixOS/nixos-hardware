# MNT Reform Laptop with RK3588 CPU module

## Creating an installer SD-Image

Create and configure the `flake.nix` file:
``` nix
{
  inputs.nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
  inputs.nixos-hardware = {
    url = "github:NixOS/nixos-hardware";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, nixos-hardware, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      rec {
        packages.default = packages.installer;
        packages.installer = (import "${nixpkgs}/nixos" {
          configuration =
            { config, ... }: {
              imports = [
                "${nixos-hardware}/mnt/reform/rk3588/installer.nix"
              ];

              # If you want to use ssh set a password
              # users.users.nixos.password = "super secure password";
              # OR add your public ssh key
              # users.users.nixos.openssh.authorizedKeys.keys = [ "ssh-rsa ..." ];

              # Additional configuration goes here

              # Only used when cross compiling
              nixpkgs.crossSystem = {
                config = "aarch64-unknown-linux-gnu";
                system = "aarch64-linux";
              };

              system.stateVersion = "23.05";
            };
          inherit system;
        }).config.system.build.image;;
      });
}
```

Build the installer image.

``` sh
nix build .#
```
