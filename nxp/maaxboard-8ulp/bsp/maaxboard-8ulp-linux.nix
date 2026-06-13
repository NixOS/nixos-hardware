{ pkgs, ... }@args:
let
  base = (pkgs.callPackage ../../common/bsp/imx-linux-builder.nix args) {
    pname = "maaxboard-8ulp-linux";
    version = "6.1.22";

    src = pkgs.fetchFromGitHub {
      owner = "Avnet";
      repo = "linux-imx";
      rev = "78ce688d5a792c053827e1edd4a347807c63c06c";
      sha256 = "sha256-Glm4Rcm+G8mEBF9ELQiD6IjwWAlCN12EoOttJIWwzBY=";
    };

    extraConfig = "";

    ignoreConfigErrors = true;

    extraMeta = {
      maintainers = with pkgs.lib.maintainers; [ govindsi ];
    };
  };
in
base.overrideAttrs (prev: {
  # Avnet linux-imx 6.1.22 Vivante driver vs GCC 15 -Werror=enum-int-mismatch
  NIX_CFLAGS_COMPILE = (prev.NIX_CFLAGS_COMPILE or "") + " -Wno-error=enum-int-mismatch";
})
