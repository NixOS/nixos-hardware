{ fetchFromGitHub
, lib
, linuxManualConfig
, stdenv
, ubootTools
, ...
}:
(linuxManualConfig rec {
  inherit lib stdenv;
  modDirVersion = "6.1.75";
  version = "${modDirVersion}-rk3588";
  src = fetchFromGitHub {
    owner = "armbian";
    repo = "linux-rockchip";
    rev = "v24.11.1";
    hash = "sha256-ZqEKQyFeE0UXN+tY8uAGrKgi9mXEp6s5WGyjVuxmuyM=";
  };
  # fetched from https://github.com/armbian/build/blob/v24.11.1/config/kernel/linux-rk35xx-vendor.config
  configfile = ./linux-rk35xx-vendor.config;
  # converted to nix using https://github.com/NixOS/nixpkgs/blob/79aaddff29307748c351a13d66f9d1fba4218624/pkgs/os-specific/linux/kernel/manual-config.nix#L11-L19
  config = import ./linux-rk35xx-vendor.nix;
  extraMeta.branch = "rk-6.1-rkr3";
}).overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ ubootTools ];
})
