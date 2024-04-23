{ fetchFromGitHub, lib, linuxManualConfig, stdenv, ... }:

linuxManualConfig rec {
  inherit lib stdenv;
  modDirVersion = "6.6.20";
  version = "${modDirVersion}-milkv-pioneer";
  src = fetchFromGitHub {
    owner = "sophgo";
    repo = "linux-riscv";
    rev = "caa949e3690fe8a4656313b2b56f52666fa880db";
    hash = "sha256-qJpR3KMgvP4tfPfBfQ/MiEWg/uuuxHYuACK8taKKK3E=";
  };
  configfile = "${src}/arch/riscv/configs/sophgo_mango_normal_defconfig";
  extraMeta.branch = "sg2042-dev-6.6";
}
