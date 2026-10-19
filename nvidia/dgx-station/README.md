# NVIDIA DGX Station

Create and configure the `flake.nix` file:
``` nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";

  outputs = { nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations.dgx-station = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-hardware.nixosModules.nvidia-dgx-station
        {
          nixpkgs.config = {
            allowUnfree = true;
            cudaSupport = true;
            # Add "12.0" for an RTX PRO Blackwell display card
            cudaCapabilities = [ "10.3" ];
          };

          system.stateVersion = "26.11";
        }
      ];
    };
  };
}
```
