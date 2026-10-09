{
  buildLinux,
  fetchpatch,
  fetchurl,
  lib,
  ...
}@args:

let
  # buildLinux sets its own postPatch; use preConfigure via overrideAttrs instead.
  imolaDtsRename = ''
    if [ -f arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts ] \
       && [ ! -f arch/arm64/boot/dts/qcom/qrb2210-arduino-imola-base.dts ]; then
      mv arch/arm64/boot/dts/qcom/qrb2210-arduino-imola.dts \
        arch/arm64/boot/dts/qcom/qrb2210-arduino-imola-base.dts
    fi
  '';
in
(buildLinux (
  args
  // rec {
    pname = "qrb2210-linux";
    version = "7.0";
    modDirVersion = "7.0.0";

    src = fetchurl {
      url = "https://cdn.kernel.org/pub/linux/kernel/v7.x/linux-${version}.tar.xz";
      hash = "sha256-u39tgLOHx1e30Uu5MCj8uQ95PFwNNnc27oFaEAs4kfA=";
    };

    kernelPatches = import ./qrb2210-linux-patches.nix { inherit fetchpatch lib; };

    defconfig = "defconfig";
    extraConfig = builtins.readFile ./linux-qrb2210-extra-config;
    ignoreConfigErrors = true;
    autoModules = false;

    meta = {
      description = "Linux kernel for Qualcomm QRB2210/QCM2290 boards";
      homepage = "https://kernel.org";
      license = lib.licenses.gpl2Only;
      platforms = [ "aarch64-linux" ];
    };
  }
)).overrideAttrs
  (prev: {
    preConfigure = (prev.preConfigure or "") + imolaDtsRename;
  })
