{
  lib,
  stdenv,
  buildUBoot,
  armTrustedFirmwareRK3588,
  rkbin,
  fetchpatch,
  fetchurl,
  fetchFromGitHub,
}:
buildUBoot {
  defconfig = "rk3588s_fydetab_duo_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  BL31 = "${armTrustedFirmwareRK3588}/bl31.elf";
  ROCKCHIP_TPL = rkbin.TPL_RK3588;
  CROSS_COMPILE_ARM64 = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}";
  INI_LOADER = fetchurl {
    url = "https://github.com/rockchip-linux/rkbin/raw/${rkbin.src.rev}/RKBOOT/RK3588MINIALL.ini";
    hash = "sha256-87Vt6nXVt+jRrRatOlwGJXYqSj9nJz1LUfQnviIVb7I=";
  };
  version = "5.10.0";
  filesToInstall = [
    "idbloader.img"
    "u-boot.itb"
    "rk3588_spl_loader_v1.18.113.bin"
    "tools/resource_tool"
  ];
  NIX_CFLAGS_COMPILE = "-Wno-error=enum-int-mismatch -Wno-error=maybe-uninitialized";
  extraMakeFlags = [
    "CROSS_COMPILE_ARM64=${stdenv.cc.targetPrefix}"
  ];
  extraPatches =
    lib.attrValues (
      lib.mapAttrs
        (
          name: hash:
          fetchpatch {
            url = "https://github.com/openFyde/overlay-fydetab_duo-openfyde/raw/fd84c5302908dea6a819c2dcd025a2bf93b5d4e8/sys-boot/rk-uboot/files/rk8/${name}";
            inherit hash;
          }
        )
        {
          "001-add-avdd-avee-in-rockchip_panel.patch" = "sha256-qmBdmSejcDn4ulvOTLjfBsNh6nl12sbobtX4mhTMMKY=";
          "002-add-fydetab-support.patch" = "sha256-QlnhdkoOQcGxRiIOx1jNqDLb/abB/+l+hAQ8vKCpwOw=";
          "003-match-display-config-with-kernel.patch" =
            "sha256-hmICiAgYjjBryJIuNXOffiYTssKSaV1cDeSgRTdq51k=";
          "004-enable-sdcard-for-fydetab.patch" = "sha256-xrZ1kuije6X+huvarDIGFhMy2Puq0XvlKa1ZfgGcwlQ=";
          "005-display-logo-on-loader-mode.patch" = "sha256-NMQHJMl8s1NUrDSnUX8gAmSNaurBU+m0xKd4TtEPmz4=";
          "006-update-deconfig.patch" = "sha256-ZukJEZjEFaN6F4+3VnHfkfdaOTQmkw3fdClk8OeOYRw=";
          "007-add-deinit-after-show-bmp-add-ums-mode.patch" =
            "sha256-4pHV+qiXMNHcIlC1ciFQsejVZvdnEhfs7QBbge9kHoM=";
          "008-add-charging-mode.patch" = "sha256-AToALdx5mwyQ875ZnrpqbuUE9oGonH76RaUq6757U1E=";
          "009-set-lowpower-to-3.patch" = "sha256-CYYmY8vQcOIiA3QPvZt+AgI/BbkykoKGqLECim7kAyw=";
          "010-fix-compiling-issue.patch" = "sha256-hmiFFe0JuxXMPgeQFWI8qZop+VPmldxgs0Wowchswbs=";
          "011-fix-battery-temp.patch" = "sha256-MXe5FGzGETZ3wpW7ur5rBLysdNlDMwiq7/LNxdDpA0E=";
          "012-fix-make.patch" = "sha256-/8ZfhB04R4zIddOXJEx8GcnYoljYsGolbt/oQYsm/Xk=";
          "013-change-exit-charge-level.patch" = "sha256-84zy5yzoHyAutVmbCvvB5t4uJFQGsMt3jTUgVs5SIog=";
          "014-fix-spl-sdcard-issue.patch" = "sha256-jIHybAm9XKDbWF3xG4E9K8x2j5nfpHOp6/2gWDlQ6aU=";
        }
    )
    ++ [
      ./uboot-remove-sig-req.patch
    ];
  src = fetchFromGitHub {
    owner = "rockchip-linux";
    repo = "u-boot";
    rev = "63c55618fbdc36333db4cf12f7d6a28f0a178017";
    hash = "sha256-OZmR6BLwCMK6lq9qmetIdrjSJJWcx7Po1OE9dBWL+Ew=";
  };
  extraConfig = ''
    CONFIG_FIT_SIGNATURE=n
    CONFIG_TPL_BUILD=y
    CONFIG_SPL_FIT_SIGNATURE=n
    CONFIG_SPL_FIT_ROLLBACK_PROTECT=n
    CONFIG_CMD_FDT=y
    CONFIG_DEFAULT_FDT_FILE="rk3588s-fydetab-duo.dtb"
    CONFIG_CMD_PXE=y
  '';
  preBuild = ''
    patchShebangs arch/arm/mach-rockchip/make_fit_atf.sh
    patchShebangs arch/arm/mach-rockchip/decode_bl31.py

    # Needs write access to generate the spl
    cp -r ${rkbin.src} rkbin
    chmod -R u+rw rkbin

    export RKBIN_TOOLS=$(readlink -e rkbin/tools)
    ln -s ${rkbin}/bin bin

    cp ${rkbin.src}/tools/boot_merger tools/
    cp ${rkbin.src}/tools/mkimage tools/
  '';
  postBuild = ''
    sh ./make.sh --spl
    sh ./make.sh --idblock
    sh ./make.sh itb
    mv idblock.bin idbloader.img
  '';
}
