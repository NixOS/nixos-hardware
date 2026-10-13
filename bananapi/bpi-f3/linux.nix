{
  buildLinux,
  fetchFromGitHub,
  kernelPatches,
  lib,
  ...
}

@args:

let
  modDirVersion = "6.6.63";
in

buildLinux (
  args
  // {
    inherit kernelPatches modDirVersion;
    version = "${modDirVersion}-spacemit-k1";

    src = fetchFromGitHub {
      owner = "liberodark";
      repo = "spacemit-linux-6.6";
      rev = "71d6ab6e6b7c904865dd1ca0f946d6448a02cd2a";
      hash = "sha256-Nun6xWAOcJ5yfcEwddYIj5Qfi4ubLLJIjWsla+Khc6I=";
    };

    defconfig = "k1_defconfig";

    structuredExtraConfig =
      let
        inherit (lib.kernel) yes no;
      in
      {
        CGROUPS = yes;
        MEMCG = yes;
        CGROUP_BPF = yes;
        BPF = yes;
        BPF_SYSCALL = yes;
        BPF_JIT = yes;
        NAMESPACES = yes;
        USER_NS = yes;
        SECCOMP = yes;
        SECCOMP_FILTER = yes;
        DEVTMPFS = yes;
        DEVTMPFS_MOUNT = yes;
        AUTOFS_FS = yes;
        FANOTIFY = yes;
        TMPFS_POSIX_ACL = yes;
        TMPFS_XATTR = yes;
        OVERLAY_FS = yes;
        MODULES = yes;
        MODULE_UNLOAD = yes;
        # Disable
        PSTORE_BLK = no;
        PSTORE_BLK_BLKDEV = no;
        MMC_SDHCI_OF_K1X_PANIC = no;
        ICM42607 = no;
        SPI_DESIGNWARE_EXT = no;
        BCMDHD = no;
        RTL8852BS = no;
        RTL8852BE = no;
        DRM_AMDGPU = no;
        DRM_RADEON = no;
        DRM_NOUVEAU = no;
      };

    extraMeta.branch = "k1-bl-v2.2.y";
  }
  // (args.argsOverride or { })
)
