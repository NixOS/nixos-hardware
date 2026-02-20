# ODroid M1

Hardware support for the Hardkernel ODroid M1: https://www.hardkernel.com/shop/odroid-m1-with-8gbyte-ram/

## Building an SD Card Image

To create an initial SD card image for installation:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };
  outputs = { self, nixpkgs, nixos-hardware }: rec {
    nixosConfigurations.m1 = nixpkgs.lib.nixosSystem {
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        nixos-hardware.nixosModules.hardkernel-odroid-m1
        ./sdimage.nix
        {
          nixpkgs.hostPlatform.system = "aarch64-linux";
          # Uncomment if cross-compiling from x86_64:
          # nixpkgs.buildPlatform.system = "x86_64-linux";
        }
      ];
    };
    images.m1 = nixosConfigurations.m1.config.system.build.sdImage;
  };
}
```

```nix
# sdimage.nix
{ config, ... }:
{
  imports = [ ./common.nix ];

  sdImage = {
    compressImage = false;
    # Required for the system to boot
    populateRootCommands = ''
      ${config.boot.loader.petitboot.populateCmd} -c ${config.system.build.toplevel} -d ./files/kboot.conf
    '';
  };
}
```

```nix
# common.nix
{ pkgs, ... }:
{
  services.openssh.enable = true;

  environment.systemPackages = [ pkgs.git ];

  users.users.odroid = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "odroid";
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAA..." ];
  };
}
```

Build with:

```sh
nix build .#images.m1
```

## Ongoing Configuration

After booting the SD card image, run `nixos-generate-config` to generate
`hardware-configuration.nix` for your system. Then set up your configuration
flake:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };
  outputs = { nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.m1 = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-hardware.nixosModules.hardkernel-odroid-m1
        ./common.nix
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
```

The module configures petitboot as the boot loader, so `nixos-rebuild switch`
works as usual.
