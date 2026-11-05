{
  lib,
  runCommand,
  fetchurl,
  platformFirmware,
}:
let
  bitmaps =
    lib.mapAttrsToList
      (
        name: hash:
        fetchurl {
          url = "https://github.com/openFyde/overlay-fydetab_duo-openfyde/raw/fd84c5302908dea6a819c2dcd025a2bf93b5d4e8/sys-boot/rk-uboot-resource/files/${name}";
          inherit name hash;
        }
      )
      {
        "fydetab_batt1.bmp" = "sha256-I4JqZLLdSOxfC6TvOwdRrhvdrPXVNpTHJyae+Sq73wE=";
        "fydetab_batt2.bmp" = "sha256-psRUFJaove7dDv57y7YGM8f57q4kLgKdXaTtAHMAD6M=";
        "fydetab_batt_fail.bmp" = "sha256-ZvKjc6ycMHkXy301CdDfTixp+cpccDU5eJlkoAtdu34=";
        "fydetab_recovery.bmp" = "sha256-9M2ms4GRVQogAD+OGZRTJMqGjM4AhhKhhLCopsiqu2s=";
        "fydetab_usb.bmp" = "sha256-jvegjta7Sg9eWF8v6NCXG6o/Bv8T6rk0naq92IoFYcw=";
      };
in
# U-Boot reads this image from a GPT partition named "resource".
runCommand "u-boot-resource.img" { } ''
  ${lib.concatMapStrings (bmp: "cp ${bmp} ${bmp.name}\n") bitmaps}
  ${platformFirmware}/resource_tool *.bmp
  mv resource.img $out
''
