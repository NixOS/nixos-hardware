nixpkgs:
let
  pkgs = nixpkgs.legacyPackages.x86_64-linux.callPackages ./. { };
in
{
  kernel-stable.x86_64-linux = nixpkgs.lib.hydraJob pkgs.kernel-stable.kernel;
  kernel-longterm.x86_64-linux = nixpkgs.lib.hydraJob pkgs.kernel-longterm.kernel;
}
