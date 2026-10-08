{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gst_all_1,
  ipu7-camera-hal,
  libdrm,
  libva,
}:

# GStreamer source element for MIPI cameras behind the Intel camera HAL
# (hardware ISP). Replaces libcamerasrc (software ISP) in the relay pipeline.
#
# Vendored from nixpkgs PR #542085; drop once that merges and use
# pkgs.gst_all_1.icamerasrc-ipu75xa instead.
stdenv.mkDerivation {
  pname = "icamerasrc-${ipu7-camera-hal.ipuVersion}";
  version = "0-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "icamerasrc";
    # tag 20251226_1140_191_PTL_PV_IoT on the icamerasrc_slim_api branch
    rev = "20251226_1140_191_PTL_PV_IoT";
    hash = "sha256-BYURJfNz4D8bXbSeuWyUYnoifozFOq6rSfG9GBKVoHo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  preConfigure = ''
    export CHROME_SLIM_CAMHAL=ON
  '';

  __structuredAttrs = true;
  strictDeps = true;

  configureFlags = [
    "--enable-gstdrmformat=yes"
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    ipu7-camera-hal
    libdrm
    libva
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error"
    # gstcameradeinterlace.cpp:55:10: fatal error: gst/video/video.h: No such file or directory
    "-I${gst_all_1.gst-plugins-base.dev}/include/gstreamer-1.0"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "GStreamer Plugin for MIPI camera support through the IPU6/IPU7 on Intel platforms";
    homepage = "https://github.com/intel/icamerasrc/tree/icamerasrc_slim_api";
    license = lib.licenses.lgpl21Plus;
    platforms = [ "x86_64-linux" ];
  };
}
