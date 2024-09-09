{
  pkgs,
  stdenv,
  pver,
  src,
  upstream_patch,
  ...
}@args:
# Applies the full patch since last mainline which contains some previous patches causing it to fail
# which will work here as the builder doesn't use "set -e"
stdenv.mkDerivation {
  name = "kernel-source";
  version = pver;
  src = src;
  patches = upstream_patch;
  buildInputs = [
    pkgs.patch
    pkgs.xz
  ];
  builder = ./builder.sh;
}
