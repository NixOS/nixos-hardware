{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs = {
    deadnix = {
      enable = true;
      no-lambda-pattern-names = true;
    };
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };
  };

  settings = {
    on-unmatched = "info";
  };
}
