{ pkgs, ... }@args:
let
  base = (pkgs.callPackage ../../common/bsp/imx-linux-builder.nix args) {
    pname = "maaxboard-8ulp-linux";
    version = "6.1.22";

    # maaxboard-build-tools kernel/build.sh: make ${BOARD}_defconfig with board=maaxboard-8ulp
    defconfig = "maaxboard-8ulp_defconfig";

    # Avnet/linux-imx @ maaxboard_lf-6.1.22-2.0.0
    src = pkgs.fetchFromGitHub {
      owner = "Avnet";
      repo = "linux-imx";
      rev = "78ce688d5a792c053827e1edd4a347807c63c06c";
      sha256 = "sha256-Glm4Rcm+G8mEBF9ELQiD6IjwWAlCN12EoOttJIWwzBY=";
    };

    extraConfig = ''
      # Avnet linux-imx 6.1.22: DEVICE_THERMAL duplicates devfreq_cooling symbols
      DEVICE_THERMAL n
    '';

    ignoreConfigErrors = true;

    extraMeta = {
      maintainers = with pkgs.lib.maintainers; [ govindsi ];
    };
  };
in
base.overrideAttrs (prev: {
  # Avnet linux-imx 6.1.22 Vivante driver vs GCC 15 -Werror=enum-int-mismatch.
  # NIX_CFLAGS_COMPILE is ignored by Kbuild; pass via KCFLAGS in makeFlags.
  makeFlags = prev.makeFlags ++ [
    "KCFLAGS=-Wno-error=enum-int-mismatch -Wno-enum-int-mismatch"
  ];
})
