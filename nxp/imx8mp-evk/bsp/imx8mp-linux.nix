{ pkgs, ... }@args:
(pkgs.callPackage ../../common/bsp/imx-linux-builder.nix args) {
  pname = "imx8mp-linux";
  version = "6.12.20";

  src = pkgs.fetchFromGitHub {
    owner = "nxp-imx";
    repo = "linux-imx";
    # tag: lf-6.12.20-2.0.0
    rev = "dfaf2136deb2af2e60b994421281ba42f1c087e0";
    sha256 = "sha256-ITrmj3a5YfXh/PSRTi+Rlto5uEBIAWFWtkTsO1ATXIo=";
  };

  # Platform-specific configuration (if any)
  extraConfig = "";

  # https://github.com/NixOS/nixpkgs/pull/366004
  # introduced a breaking change that if a module is declared but it is not being used it will faill.
  ignoreConfigErrors = true;
}
