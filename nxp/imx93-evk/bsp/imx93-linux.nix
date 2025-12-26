{ pkgs, ... }@args:
(pkgs.callPackage ../../common/bsp/imx-linux-builder.nix args) {
  pname = "imx93-linux";
  version = "6.12.3";

  src = pkgs.fetchFromGitHub {
    owner = "nxp-imx";
    repo = "linux-imx";
    # tag: lf-6.12.3
    rev = "37d02f4dcbbe6677dc9f5fc17f386c05d6a7bd7a";
    sha256 = "sha256-1oJMbHR8Ho0zNritEJ+TMOAyYHCW0vwhPkDfLctrZa8=";
  };

  # Platform-specific configuration (if any)
  extraConfig = "";

  # https://github.com/NixOS/nixpkgs/pull/366004
  # introduced a breaking change that if a module is declared but it is not being used it will faill.
  ignoreConfigErrors = true;

  extraMeta = {
    maintainers = with pkgs.lib.maintainers; [ govindsi ];
  };
}
