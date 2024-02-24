{pkgs}:
with pkgs; let
  inherit buildUBoot;
in
  (buildUBoot {
    pname = "imx8mp-uboot";
    version = "2023.04";

    src = fetchgit {
      url = "https://github.com/nxp-imx/uboot-imx.git";
      # tag: "lf-6.1.55-2.2.0"
      rev = "49b102d98881fc28af6e0a8af5ea2186c1d90a5f";
      sha256 = "sha256-1j6X82DqezEizeWoSS600XKPNwrQ4yT0vZuUImKAVVA=";
    };

    extraConfig = ''
      CONFIG_USE_BOOTCOMMAND=y
      CONFIG_BOOTCOMMAND="setenv ramdisk_addr_r 0x45000000; setenv fdt_addr_r 0x44000000; run distro_bootcmd; "
      CONFIG_CMD_BOOTEFI_SELFTEST=y
      CONFIG_CMD_BOOTEFI=y
      CONFIG_EFI_LOADER=y
      CONFIG_BLK=y
      CONFIG_PARTITIONS=y
      CONFIG_DM_DEVICE_REMOVE=n
      CONFIG_CMD_CACHE=y
    '';

    enableParallelBuilding = true;
    defconfig = "imx8mp_evk_defconfig";
    extraMeta.platforms = ["aarch64-linux"];

    filesToInstall = [
      "./u-boot-nodtb.bin"
      "./spl/u-boot-spl.bin"
      "./arch/arm/dts/imx8mp-evk.dtb"
      ".config"
    ];
  })
  .overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.perl];
  })
