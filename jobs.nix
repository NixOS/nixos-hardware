nixpkgs:
import ./toplevel.nix {
  fn = p: import "${builtins.toString p}/jobs.nix";
  args = nixpkgs;
  inherit (nixpkgs) lib;
}
