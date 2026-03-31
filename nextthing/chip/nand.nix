{ pkgs, ... }:

let
  dtsText = ''
    &nfc {
      pinctrl-names = "default";
      pinctrl-0 = <&nand_pins &nand_cs0_pin &nand_rb0_pin>;
      status = "okay";
      #address-cells = <1>;
      #size-cells = <0>;
      nand@0 {
        reg = <0>;
        allwinner,rb = <0>;
        nand-ecc-mode = "hw";
        nand-ecc-maximize;
        nand-on-flash-bbt;
      };
    };
  '';
  dtsiFile = pkgs.writeText "enable-nand.dtsi" dtsText;

  mtdparts = "4m(spl),4m(spl-backup),4m(uboot),4m(env),-(UBI)";
in

{
  nixpkgs.overlays = [
    (_final: prev: {
      ubootCHIP = prev.ubootCHIP.override (old: {
        filesToInstall = old.filesToInstall ++ [
          "spl/sunxi-spl-with-ecc.bin"
          "u-boot-dtb.bin"
          "spl/sunxi-spl.bin"
        ];
        extraConfig = (old.extraConfig or "") + ''
          CONFIG_CMD_MTD=y
          CONFIG_CMD_MTDPARTS=y
          CONFIG_MTDIDS_DEFAULT="nand0=sunxi-nand.0"
          CONFIG_MTDPARTS_DEFAULT="mtdparts=sunxi-nand.0:${mtdparts}"

          CONFIG_MTD=y
          CONFIG_DM_MTD=y
          CONFIG_MTD_RAW_NAND=y
          CONFIG_SYS_NAND_USE_FLASH_BBT=y
          CONFIG_SYS_NAND_BLOCK_SIZE=0x400000
          CONFIG_SYS_NAND_PAGE_SIZE=0x4000
          CONFIG_SYS_NAND_OOBSIZE=0x500
        '';
        prePatch = (old.prePatch or "") + ''
          cat ${dtsiFile} >> ./dts/upstream/src/arm/allwinner/sun5i-r8-chip.dts
        '';
      });
    })
  ];

  hardware.deviceTree.overlays = [
    {
      name = "enable-nand";
      dtsText = ''
        /dts-v1/;
        /plugin/;
        / {
          compatible = "nextthing,chip";
        };
        ${dtsText}
      '';
    }
  ];

  boot.kernelParams = [
    "mtdparts=1c03000.nand-controller:${mtdparts}"
  ];

  environment.systemPackages = [
    pkgs.mtdutils
  ];
}
