{
  description = "Private dev inputs for nixos-hardware";

  inputs = {
    nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixos-unstable-small";
  };

  outputs = inputs: inputs;
}
