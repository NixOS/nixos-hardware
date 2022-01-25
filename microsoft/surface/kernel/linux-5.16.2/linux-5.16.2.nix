{ lib, stdenv, buildPackages, fetchurl, perl, buildLinux
, modDirVersionArg ? null, ... }@args:

with lib;

buildLinux (args // rec {
  version = "5.16.2";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then
    concatStringsSep "." (take 3 (splitVersion "${version}.0"))
  else
    modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "ra51jkdlpp33svjjv5cfibh6xr1ljji3dhz2g2lfn12rl2hmg0z";
  };
} // (args.argsOverride or { }))
