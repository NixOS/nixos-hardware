{
  pkgs,
  targetBoard,
}:

let

  imxurl = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO";

  fwHdmiVersion = "8.16";
  fwScVersion = "1.13.0";
  fwSecoVersion = "3.8.6";

  firmwareHdmi = pkgs.fetchurl rec {
    url = "${imxurl}/firmware-imx-${fwHdmiVersion}.bin";
    sha256 = "Bun+uxE5z7zvxnlRwI0vjowKFqY4CgKyiGjbZuilER0=";
    executable = true;
  };

  firmwareSc = pkgs.fetchurl rec {
    url = "${imxurl}/imx-sc-firmware-${fwScVersion}.bin";
    sha256 = "YUaBIVCeOOTvifhiEIbKgyGsLZYufv5rs2isdSrw4dc=";
    executable = true;
  };

  firmwareSeco = pkgs.fetchurl rec {
    url = "${imxurl}/imx-seco-${fwSecoVersion}.bin";
    sha256 = "eoG19xn283fsP2jP49hD4dIBRwEQqFQ9k3yVWOM8uKQ=";
    executable = true;
  };

in
pkgs.stdenv.mkDerivation rec {

  pname = "imx-firmware";
  version = "5.15.X_1.0.0-Yocto";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  sourceRoot = ".";

  unpackPhase = ''
    ${firmwareHdmi} --auto-accept --force
    ${firmwareSc} --auto-accept --force
    ${firmwareSeco} --auto-accept --force
  '';

  filesToInstall =
    [
      "firmware-imx-${fwHdmiVersion}/firmware/hdmi/cadence/dpfw.bin"
      "firmware-imx-${fwHdmiVersion}/firmware/hdmi/cadence/hdmi?xfw.bin"
    ]
    ++ pkgs.lib.optional (targetBoard == "imx8qm") (
      "imx-sc-firmware-${fwScVersion}/mx8qm-mek-scfw-tcm.bin"
      + " "
      + "imx-seco-${fwSecoVersion}/firmware/seco/mx8qmb0-ahab-container.img"
    )
    ++ pkgs.lib.optional (targetBoard == "imx8qxp") (
      "imx-sc-firmware-${fwScVersion}/mx8qx-mek-scfw-tcm.bin"
      + " "
      + "imx-seco-${fwSecoVersion}/firmware/seco/mx8qxc0-ahab-container.img"
    );

  installPhase = ''
    mkdir -p $out
    cp ${pkgs.lib.concatStringsSep " " filesToInstall} $out
  '';

  meta = with pkgs.lib; {
    license = licenses.unfree;
  };
}
