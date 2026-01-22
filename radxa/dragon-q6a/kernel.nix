{
  lib,
  pkgs,
  ...
}:
pkgs.buildLinux {
  defconfig = "qcom_module_defconfig";
  version = "6.18.2-1-q6a-radxa";
  modDirVersion = "6.18.2";

  src = pkgs.fetchFromGitHub {
    owner = "radxa";
    repo = "kernel";
    # Use the same kernel commit ID as
    # https://github.com/radxa-pkg/linux-qcom/tree/6.18.2-1
    rev = "ca7680ac08f031ed0a952dbc6174ced3d513bef9";
    hash = "sha256-xCgW/2iaWu9JWz3LLeV/xwzvtx5JComcPZpgH7rnOgw=";
  };

  structuredExtraConfig = with lib.kernel; {
    EFI_ZBOOT = lib.mkForce no;
    NVME_AUTH = lib.mkForce yes;
  };

  extraConfig = ''
    COMPRESSED_INSTALL n
    DRM_NOVA n
    NOVA_CORE n
    WLAN_VENDOR_AIC8800 n
  '';

  ignoreConfigErrors = true;
}
