{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "ap6275p-firmware";
  version = "2023-11-05";

  src = fetchFromGitHub {
    owner = "Joshua-Riek";
    repo = "firmware";
    rev = "621ac45f5d931522bc08b51b995b938778973d2a";
    hash = "sha256-ksAOxZTnEka9SirHYxroLMbKi+99FY72X2z1pJhgYnY=";
  };

  compressFirmware = false;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/ap6275p
    install -m644 ap6275p/BCM4362A2.hcd $out/lib/firmware/ap6275p/
    install -m644 ap6275p/clm_bcm43752a2_pcie_ag.blob $out/lib/firmware/ap6275p/
    install -m644 ap6275p/fw_bcm43752a2_pcie_ag.bin $out/lib/firmware/ap6275p/
    install -m644 ap6275p/nvram_AP6275P.txt $out/lib/firmware/ap6275p/
    install -m644 ap6275p/config.txt $out/lib/firmware/ap6275p/

    mv $out/lib/firmware/ap6275p/nvram_AP6275P.txt $out/lib/firmware/ap6275p/nvram_ap6275p.txt
    mv $out/lib/firmware/ap6275p/config.txt $out/lib/firmware/ap6275p/config_bcm43752a2_pcie_ag.txt

    runHook postInstall
  '';

  meta = {
    description = "Firmware for the AP6275P WiFi/Bluetooth module";
    homepage = "https://github.com/Joshua-Riek/firmware";
    license = lib.licenses.unfree;
  };
})
