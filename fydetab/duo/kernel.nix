{
  lib,
  linuxPackagesFor,
  buildLinux,
  fetchFromGitHub,
}:
linuxPackagesFor (buildLinux rec {
  version = "6.12.43";
  modDirVersion = version;
  src = fetchFromGitHub {
    owner = "NixOnFyde";
    repo = "linux-fydetabduo";
    rev = "141bc9b36bc35738c4ea90f4c90d39d2e9cd5f0c";
    hash = "sha256-YnQT5FLv2PbaoYdVOElnUvIlIjOeXpN/htKQ2Gmc5u8=";
  };

  defconfig = "fydetabduo_defconfig";
  enableCommonConfig = false;

  structuredExtraConfig = with lib.kernel; {
    # The defconfig comes from ChromeOS, these block module and firmware loading on NixOS.
    STATIC_USERMODEHELPER = no;
    SECURITY_LOADPIN = no;
    # SELinux has a duplicate Kconfig entry in this tree.
    SECURITY_SELINUX = no;
    DPM_WATCHDOG = no;
    WERROR = no;

    # Vendor drivers that do not build in this tree.
    ROCKCHIP_DW_HDCP2 = no;
    ROCKCHIP_DP_MST_AUX_CLIENT = no;
    ROCKCHIP_MMC_VENDOR_STORAGE = no;

    MALI = no;
    DRM_PANTHOR = module;

    EFI = yes;
    EFI_STUB = yes;
    DMI = yes;
    DMIID = yes;
    AUTOFS_FS = yes;
    SECCOMP = yes;
    TMPFS_XATTR = yes;
    CRYPTO_HMAC = yes;
    CRYPTO_SHA256 = yes;
    IP_NF_MATCH_RPFILTER = module;
    IP6_NF_MATCH_RPFILTER = module;
  };

  extraMeta.platforms = [ "aarch64-linux" ];
})
