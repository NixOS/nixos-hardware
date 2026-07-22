{
  buildLinux,
  fetchFromGitHub,
  lib,
  ...
}@args:

let
  modDirVersion = "7.2.0-rc4";
in
buildLinux (
  args
  // {
    inherit modDirVersion;
    version = "7.2-rc4-spacemit-k3";

    src = fetchFromGitHub {
      owner = "torvalds";
      repo = "linux";
      tag = "v7.2-rc4";
      hash = "sha256-eGD54IjYKtOjQ2NWSytQris56WbqUp8b5u73U81YCgs=";
    };

    defconfig = "defconfig";

    kernelPatches = [
      {
        name = "k3-pcie-01-phy-dt-bindings";
        patch = ./patches/0001-phy-dt-bindings-k3-comb-phy.patch;
      }
      {
        name = "k3-pcie-02-phy-combphy-driver";
        patch = ./patches/0002-phy-k3-combphy-driver.patch;
      }
      {
        name = "k3-pcie-03-pci-k1-device-data";
        patch = ./patches/0003-pci-k1-device-data.patch;
      }
      {
        name = "k3-pcie-04-pci-k1-multiple-phy-handles";
        patch = ./patches/0004-pci-k1-multiple-phy-handles.patch;
      }
      {
        name = "k3-pcie-05-dt-bindings-dw-pcie-msi-parent";
        patch = ./patches/0005-dt-bindings-dw-pcie-msi-parent.patch;
      }
      {
        name = "k3-pcie-06-dt-bindings-k3-pcie-host";
        patch = ./patches/0006-dt-bindings-k3-pcie-host.patch;
      }
      {
        name = "k3-pcie-07-pci-k3-host-controller";
        patch = ./patches/0007-pci-k3-host-controller.patch;
      }
      {
        name = "k3-08-serial-8250-gate-clock";
        patch = ./patches/0008-serial-8250_of-gate-clock.patch;
      }
      {
        name = "k3-09-dts-uart0-gate-clock";
        patch = ./patches/0009-dts-k3-uart0-gate-clock.patch;
      }
      {
        name = "k3-09-dts-k3-add-pcie-combphy";
        patch = ./patches/0010-dts-k3-add-pcie-combphy.patch;
      }
      {
        name = "k3-11-dts-reserved-memory";
        patch = ./patches/0011-dts-k3-reserved-memory.patch;
      }
      {
        name = "k3-12-thermal-spacemit-k3";
        patch = ./patches/0012-thermal-spacemit-k3.patch;
      }
      {
        name = "k3-13-riscv-cpuinfo-model-name";
        patch = ./patches/0013-riscv-cpuinfo-model-name.patch;
      }
      {
        name = "k3-14-cpufreq-spacemit-k3";
        patch = ./patches/0014-cpufreq-spacemit-k3.patch;
      }
      # SM10 Support
      #{
      #  name = "k3-15-dts-com260-pcie";
      #  patch = ./patches/0015-dts-k3-com260-pcie.patch;
      #}
      #{
      #  name = "k3-16-remoteproc-rcpu";
      #  patch = ./patches/0016-remoteproc-spacemit-k3-rcpu.patch;
      #}
    ];

    structuredExtraConfig = with lib.kernel; {
      ARCH_SPACEMIT = option yes;
      CPU_FREQ = option yes;
      CPU_FREQ_GOV_PERFORMANCE = option yes;
      CPU_FREQ_GOV_SCHEDUTIL = option yes;
      CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = option yes;
      CPUFREQ_DT = option yes;
      CPUFREQ_DT_PLATDEV = option yes;
      SPACEMIT_K3_CPUFREQ = option yes;
      PM_OPP = option yes;
      SPACEMIT_K3_THERMAL = option yes;
      THERMAL = option yes;
      THERMAL_HWMON = option yes;
      HWMON = option yes;
      # SM10
      #MAILBOX = option yes;
      #SPACEMIT_K3_MAILBOX = option yes;
      #REMOTEPROC = option yes;
      #SPACEMIT_K3_RPROC = option yes;
      #RPMSG = option yes;
      #RPMSG_VIRTIO = option yes;
      SMP = option yes;
      SPACEMIT_K3_CCU = option yes;
      GPIO_SPACEMIT_K1 = option yes;
      CMA = option yes;
      DMA_CMA = option yes;
      SPARSEMEM_MANUAL = option yes;
      PCI = option yes;
      PCIE_DW = option yes;
      PCIE_DW_HOST = option yes;
      PCIE_SPACEMIT_K1 = option yes;
      PHY_SPACEMIT_K3_COMBO_PHY = option yes;
      PHY_SPACEMIT_K3_COMMON_OPS = option yes;
      # SM10
      #PWM = option yes;
      #PWM_PXA = option yes;
      NVME_CORE = option yes;
      BLK_DEV_NVME = option yes;
      MMC = option yes;
      MMC_SDHCI = option yes;
      MMC_SDHCI_PLTFM = option yes;
      MMC_SDHCI_OF_K1 = option yes;
      SCSI = option yes;
      STMMAC_ETH = option module;
      USB = option yes;
      USB_XHCI_HCD = option yes;
      USB_EHCI_HCD = option yes;
      SERIAL_8250 = option yes;
      SERIAL_8250_CONSOLE = option yes;
      SERIAL_OF_PLATFORM = option yes;
      EFI = option yes;
      EFI_STUB = option yes;
      EFIVAR_FS = option yes;
      CGROUPS = option yes;
      MEMCG = option yes;
      CGROUP_BPF = option yes;
      BPF = option yes;
      BPF_SYSCALL = option yes;
      BPF_JIT = option yes;
      NAMESPACES = option yes;
      USER_NS = option yes;
      SECCOMP = option yes;
      SECCOMP_FILTER = option yes;
      DEVTMPFS = option yes;
      DEVTMPFS_MOUNT = option yes;
      AUTOFS_FS = option yes;
      FANOTIFY = option yes;
      TMPFS_POSIX_ACL = option yes;
      TMPFS_XATTR = option yes;
      MODULES = option yes;
      MODULE_UNLOAD = option yes;
      RD_GZIP = option yes;
      RD_BZIP2 = option yes;
      RD_LZMA = option yes;
      RD_XZ = option yes;
      RD_LZO = option yes;
      RD_LZ4 = option yes;
      RD_ZSTD = option yes;
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
      DEBUG_INFO_BTF = lib.mkForce no;
      DEBUG_INFO_BTF_MODULES = lib.mkForce no;
    };

    extraMeta.branch = "7.2";
  }
  // (args.argsOverride or { })
)
