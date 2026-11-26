{
  lib,
  buildLinux,
  fetchFromGitHub,
  applyPatches,
  ...
}@args:

let
  # meta-qcom linux-qcom_6.18.bb @ qcom-6.18.y-20260626
  src' = fetchFromGitHub {
    owner = "qualcomm-linux";
    repo = "kernel";
    rev = "8c49474603c0b1c278b8fe00ac4e735b92d78ce9";
    hash = "sha256-XqX9rLu2+rgFxoOU/eWnQW3AZOVKPsE2eX8HTYi/7is=";
  };

  src = applyPatches {
    name = "linux-qcom-iq9075-evk";
    src = src';
    postPatch = ''
      cp ${./configs/iq9075_evk_defconfig} arch/arm64/configs/iq9075_evk_defconfig
    '';
  };
in
buildLinux (
  args
  // rec {
    inherit src;
    pname = "iq-9075-evk-linux";
    version = "6.18.30";
    # Must match CONFIG_LOCALVERSION="-iq9075" in iq9075_evk_defconfig.
    modDirVersion = "6.18.30-iq9075";

    defconfig = "iq9075_evk_defconfig";

    # Vendor defconfig already carries the board fragment set. Do not layer
    # nixpkgs common-config on top (it re-enables EFI_ZBOOT / wrong preempt
    # and hung after ExitBootServices on this board).
    enableCommonConfig = false;
    ignoreConfigErrors = true;
    autoModules = false;

    extraMeta = {
      description = "Qualcomm Linux kernel for IQ-9075 EVK";
      homepage = "https://github.com/qualcomm-linux/kernel";
      license = lib.licenses.gpl2Only;
      platforms = [ "aarch64-linux" ];
      maintainers = with lib.maintainers; [ govindsi ];
    };
  }
  // (args.argsOverride or { })
)
