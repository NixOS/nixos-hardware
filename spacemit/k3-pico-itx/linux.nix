{
  buildLinux,
  fetchFromGitHub,
  kernelPatches,
  lib,
  ...
}

@args:

let
  modDirVersion = "6.18.3";
in

buildLinux (
  args
  // {
    inherit kernelPatches modDirVersion;
    version = "${modDirVersion}-spacemit-k3";

    src = fetchFromGitHub {
      owner = "liberodark";
      repo = "spacemit-linux-6.18";
      rev = "3709ed51967962fd02d6b4e5a80234719693931f";
      hash = "sha256-itqxXJCogLHbGucVHCDVwGkoqunQjJs0i1ZfvkuUtP4=";
    };

    defconfig = "k3_bianbu_defconfig";

    postPatch = ''
      sed -i '/CONFIG_INITRAMFS_SOURCE=/d' arch/riscv/configs/k3_bianbu_defconfig
    '';

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
        MODULES = yes;
        MODULE_UNLOAD = yes;
        RD_GZIP = yes;
        RD_BZIP2 = yes;
        RD_LZMA = yes;
        RD_XZ = yes;
        RD_LZO = yes;
        RD_LZ4 = yes;
        RD_ZSTD = yes;
        # Disable
        PSTORE_BLK = no;
        PSTORE_BLK_BLKDEV = no;
        RTL8852BS = no;
        CORESIGHT = no;
        ETHERCAT = no;
        HWSPINLOCK_SPACEMIT = no;
        DRM_AMDGPU = no;
        DRM_RADEON = no;
        DRM_NOUVEAU = no;
        SPACEMIT_K1_CCU = no;
        NVMEM_LAYOUT_ONIE_TLV = no;
        DEBUG_VM = no;
        DEBUG_VM_PGFLAGS = no;
        DEBUG_VM_PGTABLE = no;
        DEBUG_PAGEALLOC = no;
        DEBUG_PAGEALLOC_ENABLE_DEFAULT = no;
        PAGE_EXTENSION = lib.mkForce no;
        PAGE_OWNER = no;
        KASAN = no;
        KMEMLEAK = no;
        DEBUG_KMEMLEAK = no;
        SLUB_DEBUG_ON = no;
        MEM_ALLOC_PROFILING = lib.mkForce no;
        MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT = lib.mkForce no;
        NO_HZ_FULL = lib.mkForce no;
        SLAB_FREELIST_HARDENED = lib.mkForce no;
        SLAB_FREELIST_RANDOM = lib.mkForce no;
        KFENCE = lib.mkForce no;
      };

    extraMeta.branch = "k3-br-v1.0.y";
  }
  // (args.argsOverride or { })
)
