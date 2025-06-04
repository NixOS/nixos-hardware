{
  pkgs,
  targetBoard,
}:

with pkgs;
let
  inherit buildUBoot;

  imx8qxp-attrs = {
    atf = "imx8qx";
    ahab = "mx8qxc0-ahab-container.img";
    scfw = "mx8qx-mek-scfw-tcm.bin";
    soc = "QX";
    patches = [ ../patches/0001-Add-UEFI-boot-for-imx8qxp.patch ];
  };

  imx8qm-attrs = {
    atf = "imx8qm";
    ahab = "mx8qmb0-ahab-container.img";
    scfw = "mx8qm-mek-scfw-tcm.bin";
    soc = "QM";
    patches = [ ../patches/0001-Add-UEFI-boot-for-imx8qm.patch ];
  };

  imx8-attrs =
    if (targetBoard == "imx8qxp") then
      imx8qxp-attrs
    else if (targetBoard == "imx8qm") then
      imx8qm-attrs
    else
      { };

  inherit
    (callPackage ./imx-atf.nix {
      inherit buildArmTrustedFirmware;
      targetBoard = imx8-attrs.atf;
    })
    armTrustedFirmwareiMX8
    ;
  imx-firmware = callPackage ./imx-firmware.nix { inherit pkgs targetBoard; };
  imx-mkimage = buildPackages.callPackage ./imx-mkimage.nix { inherit pkgs; };
in
{
  ubootImx8 = buildUBoot {
    version = "2022.04";
    src = fetchgit {
      url = "https://github.com/nxp-imx/uboot-imx.git";
      # tag: "lf_v2022.04"
      rev = "1c881f4da83cc05bee50f352fa183263d7e2622b";
      sha256 = "sha256-0TS6VH6wq6PwZUq6ekbuLaisZ9LrE0/haU9nseGdiE0=";
    };
    BL31 = "${armTrustedFirmwareiMX8}/bl31.bin";
    patches = imx8-attrs.patches;
    enableParallelBuilding = true;
    defconfig = "${targetBoard}_mek_defconfig";
    extraMeta.platforms = [ "aarch64-linux" ];
    preBuildPhases = [ "copyBinaries" ];

    copyBinaries = ''
      install -m 0644 ${imx-firmware}/${imx8-attrs.ahab} ./ahab-container.img
      install -m 0644 ${imx-firmware}/${imx8-attrs.scfw} ./${imx8-attrs.scfw}
      install -m 0644 $BL31 ./u-boot-atf.bin
    '';
    postBuild = ''
      ${imx-mkimage} -commit > head.hash
      cat u-boot.bin head.hash > u-boot-hash.bin
      dd if=u-boot-hash.bin of=u-boot-atf.bin bs=1K seek=128
      ${imx-mkimage} -soc ${imx8-attrs.soc} -rev B0 -append ahab-container.img -c -scfw ${imx8-attrs.scfw} -ap u-boot-atf.bin a35 0x80000000 -out flash.bin
    '';
    filesToInstall = [ "flash.bin" ];
  };

  inherit imx-firmware;
}
