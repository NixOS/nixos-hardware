{
  lib,
  fetchFromGitLab,
  fetchurl,
  kernelPatches,
  callPackage,
  buildLinux,
  ...
}@args:
let
  pver = "6.16.8";

  src_pine64 = fetchFromGitLab {
    owner = "pine64-org";
    repo = "linux";
    rev = "ppp-6.16-20250922-1910";
    hash = "sha256-LaEp5KuCbK1dcOYgbuMLv1Eqnsij0s/W0zYwUmSq4HE=";
  };
  #apply mainline fixver patches
  upstream_patch = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/patch-${pver}.xz";
    hash = "sha256-sng1x9aF78Ordw7q19aGodjK5MLOwabB7+s8bRi7x7M=";
  };

  ksrc = import ./source.nix;

  apply_patch = (
    path: {
      name = builtins.baseNameOf path;
      patch = path;
    }
  );
  patches = [ ];
in
buildLinux (
  args
  // {
    version = pver;
    src = callPackage ksrc {
      inherit pver upstream_patch;
      src = src_pine64;
    };
    features = { };
    structuredExtraConfig = import ./config.nix {
      inherit lib;
      version = pver;
    };

    kernelPatches = kernelPatches ++ map apply_patch patches;
    extraMeta = {
      platforms = lib.platforms.aarch64;
      hydraPlatforms = [ "aarch64-linux" ];
    };
  }
  // args.argsOverride or { }
)
