{ stdenv, lib, kernel, fetchpatch, runCommand, patch }:

let
  patch1_original = fetchpatch {
    url = "https://marc.info/?l=linux-input&m=161847127221531&q=p3";
    name = "goodix-stylus-mastykin-1-pen-support.patch";
    sha256 = "sha256-1oc8OvfhScYvtsMeV9A4hU+09i59tEJ6HZS6jspsJR8=";
  };
  patch1_updated_5_12_12 = runCommand
    "goodix-stylus-mastykin-1-pen-support-5.12.12.patch" {}
    ''
      cat ${patch1_original} > $out
      ${patch}/bin/patch $out < ${./5.12.12.patch.patch}
    '';
  patch1_updated_6_1 = runCommand
    "goodix-stylus-mastykin-1-pen-support-6.1.patch" {}
    ''
      cat ${patch1_original} > $out
      ${patch}/bin/patch $out < ${./6.1.patch.patch}
    '';
  patch1_updated_6_12 = runCommand
    "goodix-stylus-mastykin-1-pen-support-6.12.patch" {}
    ''
      cat ${patch1_original} > $out
      ${patch}/bin/patch $out < ${./6.12.patch.patch}
    '';
  patch1 =
    if (lib.versionAtLeast kernel.version "6.12") then
      patch1_updated_6_12
    else if (lib.versionAtLeast kernel.version "6.1") then
      patch1_updated_6_1
    else if (lib.versionAtLeast kernel.version "5.12.12") then
      patch1_updated_5_12_12
    else patch1_original;
  patch2 = fetchpatch {
    url = "https://marc.info/?l=linux-input&m=161847127221531&q=p4";
    name = "goodix-stylus-mastykin-2-buttons.patch";
    sha256 = "sha256-HxmR8iEgoj4PJopGWJdWsjFxbfISwTMzz+HyG81mRG4=";
  };
in
stdenv.mkDerivation rec {
  name = "hid-multitouch-onenetbook4-${version}";
  inherit (kernel) version;

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  src = ./.;
  patches = [ patch1 patch2 ];

  postUnpack = ''
    tar -C goodix-stylus-mastykin \
      --strip-components=3 -xf ${kernel.src} --wildcards \
      '*/drivers/hid/hid-ids.h' '*/drivers/hid/hid-multitouch.c'
  '';
  patchFlags = "-p3";
  postPatch = ''
    mv hid-multitouch.c hid-multitouch-onenetbook4.c
    substituteInPlace hid-multitouch-onenetbook4.c --replace \
      '.name = "hid-multitouch",' \
      '.name = "hid-multitouch-onenetbook4",'
    substituteInPlace hid-multitouch-onenetbook4.c --replace \
      I2C_DEVICE_ID_GOODIX_0113 \
      0x011A
  '';

  makeFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    description = "hid-multitouch module patched for OneNetbook 4";
    platforms = platforms.linux;
  };
}
