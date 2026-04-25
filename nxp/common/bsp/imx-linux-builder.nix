# Parameterized Linux kernel builder for i.MX platforms
# This builder is used across i.MX93, i.MX8MP, i.MX8MQ and similar platforms
{ lib, pkgs, ... }@args:
let
  inherit (pkgs) buildLinux;

  # Import common kernel configuration
  kernelConfig = import ../lib/kernel-config.nix;
in
# Platform-specific parameters
{
  pname,
  version,
  src,
  defconfig ? "imx_v8_defconfig",
  # Optional parameters
  extraConfig ? "",
  kernelPatches ? [ ],
  autoModules ? false,
  ignoreConfigErrors ? true,
  extraMeta ? { },
}:
let
  # Combine common i.MX kernel config with platform-specific config
  finalExtraConfig = kernelConfig.imxCommonKernelConfig + extraConfig;
in
buildLinux (
  args
  // rec {
    inherit
      version
      defconfig
      kernelPatches
      autoModules
      ignoreConfigErrors
      ;
    name = pname;

    # modDirVersion needs to be x.y.z, will automatically add .0 if needed
    modDirVersion = version;

    extraConfig = finalExtraConfig;

    inherit src;

    meta =
      with lib;
      {
        homepage = "https://github.com/nxp-imx/linux-imx";
        license = [ licenses.gpl2Only ];
        platforms = [ "aarch64-linux" ];
      }
      // extraMeta;
  }
  // (args.argsOverride or { })
)
