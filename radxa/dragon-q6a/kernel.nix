{
  lib,
  pkgs,
  ...
}:
pkgs.buildLinux {
  defconfig = "qcom_module_defconfig";
  version = "6.17.1-4-q6a-radxa";
  modDirVersion = "6.17.1";

  src = pkgs.fetchFromGitHub {
    owner = "radxa";
    repo = "kernel";
    # Fixed in https://github.com/radxa-pkg/linux-qcom/tree/6.17.1-4
    rev = "996b43f72835d22c2f79e1f476dd34f90f9e69bb";
    hash = "sha256-5nWveVNY5GevkBws1CjKf6WOGLFakBgiNzBsf6B2rrQ=";
  };

  structuredExtraConfig = with lib.kernel; {
    EFI_ZBOOT = lib.mkForce no;
    NVME_AUTH = lib.mkForce yes;
  };

  extraConfig = ''
    NOVA_CORE n
    COMPRESSED_INSTALL n
    WLAN_VENDOR_AIC8800 n
  '';

  ignoreConfigErrors = true;
}
