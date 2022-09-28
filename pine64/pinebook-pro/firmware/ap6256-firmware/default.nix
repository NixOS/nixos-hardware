{ lib
, fetchFromGitHub
, runCommand
}:

let
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rkwifibt";
    rev = "3524d73251fe4d16f0f873e583aa63b12a90ac26";
    sha256 = "0ac7z3m5mnmk1qhf9pq9s3y6ky8jmd3ggn8m29797z1ng40q3cka";
  };
in
runCommand "pinebookpro-ap6256-firmware"
{
  meta = with lib; {
    license = licenses.unfreeRedistributable;
  };
} ''
  (PS4=" $ "; set -x
  cp ${src}/"firmware/broadcom/all/bt/BCM4345C5.hcd"               "BCM4345C5.hcd"
  cp ${src}/"firmware/broadcom/all/wifi/fw_bcm43456c5_ag.bin"      "fw_bcm43456c5_ag.bin"
  cp ${src}/"clm_blob/broadcom/AP6256/brcmfmac43456-sdio.clm_blob" "brcmfmac43456-sdio.clm_blob"
  cp ${src}/"firmware/broadcom/all/wifi/nvram_ap6256.txt"          "nvram_ap6256.txt"
  mkdir -p $out/lib/firmware/brcm
  # Bluetooth firmware
  install -Dm644 "BCM4345C5.hcd" -t "$out/lib/firmware/"
  install -Dm644 "BCM4345C5.hcd"    "$out/lib/firmware/brcm/BCM.hcd"
  install -Dm644 "BCM4345C5.hcd" -t "$out/lib/firmware/brcm/"
  # Wifi firmware
  install -Dm644 "nvram_ap6256.txt" -t         "$out/lib/firmware/"
  install -Dm644 "fw_bcm43456c5_ag.bin"        "$out/lib/firmware/brcm/brcmfmac43456-sdio.bin"
  install -Dm644 "brcmfmac43456-sdio.clm_blob" "$out/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob"
  install -Dm644 "nvram_ap6256.txt"            "$out/lib/firmware/brcm/brcmfmac43456-sdio.radxa,rockpi4b.txt"
  install -Dm644 "nvram_ap6256.txt"            "$out/lib/firmware/brcm/brcmfmac43456-sdio.radxa,rockpi4c.txt"
  install -Dm644 "nvram_ap6256.txt"            "$out/lib/firmware/brcm/brcmfmac43456-sdio.pine64,pinebook-pro.txt"
  install -Dm644 "nvram_ap6256.txt"            "$out/lib/firmware/brcm/brcmfmac43456-sdio.pine64,rockpro64-v2.1.txt"
  )
''
