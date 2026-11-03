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

  kernelPatches = [
    {
      # From fyde-nix. Without it, USB-C role negotiation fails with some chargers and hubs.
      name = "husb311-drp-role-negotiation";
      patch = ./husb311-drp-role-negotiation.patch;
    }
    {
      name = "bq25700-charge-thresholds";
      patch = ./bq25700-charge-thresholds.patch;
    }
    {
      # Backport of upstream fda1e0af7c28.
      name = "sdhci-dwcmshc-cqe";
      patch = ./sdhci-dwcmshc-cqe.patch;
    }
  ];

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

    # NixOS compresses firmware with zstd on kernels 5.19 and newer.
    FW_LOADER_COMPRESS = yes;
    FW_LOADER_COMPRESS_ZSTD = yes;

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
    CGROUP_PIDS = yes;

    # The NixOS firewall and Docker use iptables-nft, which needs the nftables families.
    NF_TABLES_INET = yes;
    NF_TABLES_IPV4 = yes;
    NF_TABLES_IPV6 = yes;
    NFT_NAT = module;
    NFT_FIB_INET = module;
    NFT_FIB_IPV4 = module;
    NFT_FIB_IPV6 = module;
  };

  extraMeta.platforms = [ "aarch64-linux" ];
})
