{ pkgs, ... }@args:
(pkgs.callPackage ../../common/bsp/imx-linux-builder.nix args) {
  pname = "imx8mq-linux";
  version = "6.1.55";

  src = pkgs.fetchFromGitHub {
    owner = "nxp-imx";
    repo = "linux-imx";
    # tag: lf-6.1.55-2.2.0
    rev = "770c5fe2c1d1529fae21b7043911cd50c6cf087e";
    sha256 = "sha256-tIWt75RUrjB6KmUuAYBVyAC1dmVGSUAgqV5ROJh3xU0=";
  };

  # Platform-specific configuration (if any)
  extraConfig = "";

  # https://github.com/NixOS/nixpkgs/pull/366004
  # introduced a breaking change that if a module is declared but it is not being used it will faill.
  ignoreConfigErrors = true;
}
