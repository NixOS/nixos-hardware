# Creating an installation SD card image

Create and customize a `flake.nix` file:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, nixos-hardware, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "riscv64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSupportedSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSupportedSystems (system: rec {
        default = sd-image;
        sd-image = (import "${nixpkgs}/nixos" {
          configuration = {
            imports = [
              "${nixos-hardware}/milkv/pioneer/sd-image-installer.nix"
            ];

            nixpkgs.buildPlatform.system = system;
            nixpkgs.hostPlatform.system = "riscv64-linux";

            system.stateVersion = "24.05";
          };
          inherit system;
        }).config.system.build.sdImage;
      });
    };
}
```

Then build the image by running `nix build .#` in the same folder.

# Known issues

LinuxBoot will not output the boot menu on the serial console, only on the graphical console.
Unfortuately, it might also pick up boot options from other devices, e.g. an nvme or sata drive.
It might end up booting by default from those instead of booting from the SD card.
