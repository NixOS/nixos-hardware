{
  description = "Private dev inputs for nixos-hardware";

  inputs = {
    nixos-unstable-small.url = "https://channels.nixos.org/nixos-unstable-small/nixexprs.tar.zst";
    nixos-stable.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixos-unstable-small";
  };

  outputs = inputs: inputs;
}
