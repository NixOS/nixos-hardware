{ buildLinux, fetchFromGitLab, ... }@args:
buildLinux (args // rec {
  defconfig = "librem5_defconfig";
  version = "6.1.10-librem5";
  modDirVersion = version;
  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "linux";
    rev = "pureos/6.1.10pureos1";
    hash = "sha256-Cc16vMUcJ/a2k3zMynqZ99t1LyTSs7EXKdNGF6OTS1s=";
  };
  kernelPatches = [ ];
} // args.argsOverride or { })
