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
  pver = "6.6.44";

  src_pine64 = fetchFromGitLab {
    owner = "pine64-org";
    repo = "linux";
    rev = "ppp-6.6-20231104-22589";
    sha256 = "sha256-wz2g+wE1DmhQQoldeiWEju3PaxSTIcqLSwamjzry+nc=";
  };
  #apply mainline fixver patches
  upstream_patch = fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v6.x/patch-${pver}.xz";
    hash = "sha256-SSDqB/mqUmEWcf7fhZ3RRvGc2wvauORBuVl2ovJjX5M=";
  };

  ksrc = import ./source.nix;

  apply_patch = (
    path: {
      name = builtins.baseNameOf path;
      patch = path;
    }
  );
  # patches = [ ./pinephonepro_defconfig.patch ];
  patches = [ ];
in
buildLinux (
  args
  // {
    version = pver;
    # todo: find out why builder complains about patch-version
    modDirVersion = "${lib.versions.majorMinor pver}.0";
    src = callPackage ksrc {
      inherit pver upstream_patch;
      src = src_pine64;
    };
    features = {
      debug = true; # needed for BTF generation
    };
    structuredExtraConfig = import ./config.nix {
      inherit lib;
      version = pver;
    };
    # autoModules = false;

    kernelPatches = kernelPatches ++ map apply_patch patches;
    extraMeta = {
      platforms = lib.platforms.aarch64;
      hydraPlatforms = [ "aarch64-linux" ];
    };
  }
  // args.argsOverride or { }
)
