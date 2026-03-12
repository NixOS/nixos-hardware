# quick command for testing:
# nix build -L --impure --no-link --expr \
#   '(import <nixpkgs> {}).linuxPackages_6_18.callPackage ./default.nix {}'

{
  stdenv,
  lib,
  kernel,
  fetchpatch,
  runCommand,
  patch,
}:

let
  patch1_original = fetchpatch {
    url = "https://marc.info/?l=linux-input&m=161847127221531&q=p3";
    name = "goodix-stylus-mastykin-1-pen-support.patch";
    sha256 = "sha256-1oc8OvfhScYvtsMeV9A4hU+09i59tEJ6HZS6jspsJR8=";
  };
  patch1_updated_5_12_12 = runCommand "goodix-stylus-mastykin-1-pen-support-5.12.12.patch" { } ''
    cat ${patch1_original} > $out
    ${patch}/bin/patch $out < ${./5.12.12.patch.patch}
  '';
  patch1_updated_6_1 = runCommand "goodix-stylus-mastykin-1-pen-support-6.1.patch" { } ''
    cat ${patch1_original} > $out
    ${patch}/bin/patch $out < ${./6.1.patch.patch}
  '';
  patch1_updated_6_12 = runCommand "goodix-stylus-mastykin-1-pen-support-6.12.patch" { } ''
    cat ${patch1_original} > $out
    ${patch}/bin/patch $out < ${./6.12.patch.patch}
  '';
  patch1_updated_6_17 = runCommand "goodix-stylus-mastykin-1-pen-support-6.17.patch" { } ''
    cat ${patch1_original} > $out
    ${patch}/bin/patch $out < ${./6.17.patch.patch}
  '';
  patch1_updated_6_18 = runCommand "goodix-stylus-mastykin-1-pen-support-6.18.patch" { } ''
    cat ${patch1_original} > $out
    ${patch}/bin/patch $out < ${./6.18.patch.patch}
  '';
  patch1 =
    if (lib.versionAtLeast kernel.version "6.18.18") then
      patch1_updated_6_18
    else if (lib.versionAtLeast kernel.version "6.17") then
      patch1_updated_6_17
    else if (lib.versionAtLeast kernel.version "6.12") then
      patch1_updated_6_12
    else if (lib.versionAtLeast kernel.version "6.1") then
      patch1_updated_6_1
    else if (lib.versionAtLeast kernel.version "5.12.12") then
      patch1_updated_5_12_12
    else
      patch1_original;
  patch2 = fetchpatch {
    url = "https://marc.info/?l=linux-input&m=161847127221531&q=p4";
    name = "goodix-stylus-mastykin-2-buttons.patch";
    sha256 = "sha256-HxmR8iEgoj4PJopGWJdWsjFxbfISwTMzz+HyG81mRG4=";
  };
in
stdenv.mkDerivation rec {
  name = "hid-multitouch-onenetbook4-${version}";
  inherit (kernel) version;

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  src = ./.;

  # default patchPhase doesn't try hard enough
  patchPhase = ''
    runHook prePatch
    patch -p3 hid-multitouch.c < ${patch1}
    patch -p3 hid-multitouch.c < ${patch2}
    runHook postPatch
  '';

  postUnpack =
    let
      hid = "${kernel.src}/drivers/hid";
    in
    ''
      if [ -d ${kernel.src} ]; then  # -latest kernel
        cp ${hid}/hid-ids.h ${hid}/hid-multitouch.c goodix-stylus-mastykin/
        cp ${hid}/hid-haptic.h goodix-stylus-mastykin/ 2>/dev/null || true
      else  # stable kernels with tarballs
        tar -C goodix-stylus-mastykin \
          --strip-components=3 -xf ${kernel.src} --wildcards \
          '*/drivers/hid/hid-ids.h' '*/drivers/hid/hid-multitouch.c'
        tar -C goodix-stylus-mastykin \
          --strip-components=3 -xf ${kernel.src} --wildcards \
          '*/drivers/hid/hid-haptic.h' 2>/dev/null || true
      fi
    '';
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
