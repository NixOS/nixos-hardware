{
  stdenv,
  lib,
  kernel,
  kernelModuleMakeFlags,
  fetchFromGitHub,
}:

# Himax HM1092 IR sensor driver, for the Windows-Hello camera on the same
# SVP7500 bridge as the RGB sensor. There is no in-tree counterpart:
# drivers/media/i2c/hm1092.c does not exist in mainline, so this stays vendored
# indefinitely rather than carrying a "drop once upstream" note like the
# packages from nixpkgs #542085.
#
# The driver publishes V4L2_CID_LINK_FREQ = 180480000, the DDR clock. Earlier
# revisions published 360960000, which is the correct per-lane MIPI bit rate but
# twice the value V4L2 asks for; ISys then programmed the CSI-2 D-PHY at
# ~721 Mbps against a sensor transmitting ~361, so the clock lane came up and no
# data packet ever framed. That produced zero SOF indefinitely and was long
# mistaken for a bridge firmware block (intel/vision-drivers#37, retracted
# 2026-07-25).
#
# hm1092 reaches cvs_send_mipi_ir_config through a weak reference, to ask the
# bridge to configure port-2 forwarding. Only the fix pack's fork of intel_cvs
# exports it, which is why ir-camera.nix ships ./intel-cvs-ir in place of the
# base profile's plain intel-cvs; the reference being weak means the module
# still loads without it, logging "intel_cvs symbol unavailable; port-2
# forwarding NOT configured". Note that per the fix pack's own IR-FINDINGS.md
# that payload was tested both ways and is NOT what made IR work -- the
# LINK_FREQ correction was -- so treat the pairing as "how this was verified",
# not a proven requirement.
#
# depmod does record weak undefined symbols (unlike modpost, which omits them
# from the modinfo `depends` string), so modprobe pulls intel_cvs in first when
# both live in one tree. NixOS aggregates all of boot.extraModulePackages into a
# single tree, so that holds by construction.
stdenv.mkDerivation (finalAttrs: {
  pname = "hm1092";
  # dkms.conf declares PACKAGE_VERSION="1.0"; the rev is tag
  # nixos-pin-2026-08-27 on the fork.
  version = "1.0-unstable-2026-08-27";

  # Pinned to a fork, like ./intel-cvs-ir, for one commit on top of upstream:
  # the driver looked the IR illuminator up as a GPIO named "ir-led", but for
  # INT3472_GPIO_TYPE_STROBE int3472 sets con_id "ir_flood" and consumes the
  # descriptor into skl_int3472_register_led() rather than publishing it in the
  # GPIO lookup table -- so the lookup could never match and every boot logged
  # "ir_led=none". The fork also calls devm_led_get(dev, "ir_flood") and drives
  # whichever handle resolved.
  #
  # This is what makes the sensor usable by an unmodified consumer. Left to
  # userspace, every client had to drive the emitter itself, and the ones that
  # do not -- Howdy's stock opencv recorder, ffmpeg, v4l2-ctl -- got frames lit
  # only by ambient IR, which reads as broken hardware. It also removes a latch
  # hazard: a killed capture used to be able to leave the emitter lit, whereas
  # the kernel douses it on stream stop and on remove.
  #
  # Verified on the target hardware (DA14260, 7.1.8) before pinning:
  # ir_led=found, and the illuminator reads 0/1/0 before/during/after
  # `v4l2-ctl --stream-mmap` at 29.1 fps with no userspace LED writes.
  # Offered upstream as well; re-point this at jibsta210 if it is merged there.
  src = fetchFromGitHub {
    owner = "HritwikSinghal";
    repo = "svp7500-camera-fix-pack";
    tag = "nixos-pin-2026-08-27";
    hash = "sha256-+vWsihrgfU0AXi2PFRmM6AYjVyDCTQcTfa0Gv+TkSso=";
  };

  # The repo ships several DKMS trees; this one is self-contained (three files,
  # only mainline kernel headers, no shared includes with its siblings).
  sourceRoot = "${finalAttrs.src.name}/dkms/hm1092-1.0";

  hardeningDisable = [
    "pic"
    "format"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # Drive kbuild directly rather than through the bundled Makefile's targets:
  # its `all` recipe passes CC=clang LLVM=1 to the sub-make, which beats
  # anything given on the command line and fails against a gcc-built kernel,
  # and it has no install target at all. Passing -C here is the same shape
  # nixpkgs' gasket module uses, and keeps the stdenv phases (and their
  # flag-array handling) intact instead of overriding them.
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  buildFlags = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = {
    description = "Himax HM1092 infrared camera sensor driver";
    homepage = "https://github.com/HritwikSinghal/svp7500-camera-fix-pack";
    license = lib.licenses.gpl2Only;
    # The driver carries no LINUX_VERSION_CODE fallbacks at all, so an older
    # kernel fails to compile rather than degrading. The floor comes from
    # v4l2_subdev_state_get_format and .init_state in v4l2_subdev_internal_ops,
    # both 6.8; the void-returning i2c .remove it also uses is older still
    # (6.1). Built here against 6.12, 6.18 and 7.1.
    broken = kernel.kernelOlder "6.8";
    platforms = [ "x86_64-linux" ];
  };
})
