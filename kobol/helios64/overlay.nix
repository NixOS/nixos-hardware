self: super: {
  linux_5_10_helios64 = self.linux_5_10.override {

    kernelPatches = [
      {
        name = "helios64-patch-set.patch";
        patch = self.fetchurl {
          # v5.10.68..v5.10-helios64-2021-10-10 @ https://github.com/samueldr/linux
          # Hosted as a pre-rendered patch because `fetchpatch` strips added files.
          url = "https://gist.githubusercontent.com/samueldr/1a409f88f2107054c87a70403686b871/raw/abee3d5d5415c466f8111371b63f759f614547c6/helios64.patch";
          sha256 = "1gx2z345vb4r2mdfmydbzc5baj58rrn416rzb2fz7azxpyib5ym4";
        };
      }
    ];

    # Configuration mainly to remove unused platforms and things.
    structuredExtraConfig = with self.lib.kernel; {
      ARCH_ROCKCHIP = yes;

      ARCH_ACTIONS = no;
      ARCH_AGILEX = no;
      ARCH_SUNXI = no;
      ARCH_ALPINE = no;
      ARCH_BCM2835 = no;
      ARCH_BERLIN = no;
      ARCH_BRCMSTB = no;
      ARCH_EXYNOS = no;
      ARCH_K3 = no;
      ARCH_LAYERSCAPE = no;
      ARCH_LG1K = no;
      ARCH_HISI = no;
      ARCH_MEDIATEK = no;
      ARCH_MESON = no;
      ARCH_MVEBU = no;
      ARCH_MXC = no;
      ARCH_QCOM = no;
      ARCH_RENESAS = no;
      ARCH_S32 = no;
      ARCH_SEATTLE = no;
      ARCH_STRATIX10 = no;
      ARCH_SYNQUACER = no;
      ARCH_TEGRA = no;
      ARCH_SPRD = no;
      ARCH_THUNDER = no;
      ARCH_THUNDER2 = no;
      ARCH_UNIPHIER = no;
      ARCH_VEXPRESS = no;
      ARCH_VISCONTI = no;
      ARCH_XGENE = no;
      ARCH_ZX = no;
      ARCH_ZYNQMP = no;
      ARCH_RANDOM = no;
      ARCH_R8A77995 = no;
      ARCH_R8A77990 = no;
      ARCH_R8A77950 = no;
      ARCH_R8A77951 = no;
      ARCH_R8A77965 = no;
      ARCH_R8A77960 = no;
      ARCH_R8A77961 = no;
      ARCH_R8A77980 = no;
      ARCH_R8A77970 = no;
      ARCH_R8A774C0 = no;
      ARCH_R8A774E1 = no;
      ARCH_R8A774A1 = no;
      ARCH_R8A774B1 = no;
      ARCH_STACKWALK = no;
    };
  };

  # Force modules closure to be built even if some modules are missing
  # (Workaround for a NixOS change in strictness)
  makeModulesClosure = x:
    super.makeModulesClosure (x // { allowMissing = true; });
}
