{
  lib,
  stdenv,
  fetchFromGitHub,

  # build
  cmake,
  pkg-config,

  # runtime
  expat,
  ipu7-camera-bins,
  jsoncpp,
  libtool,
  gst_all_1,
  libdrm,

  # Pick one of
  # - ipu7x (Lunar Lake)
  # - ipu75xa (Panther Lake)
  ipuVersion ? "ipu75xa",
}:

# Intel camera HAL: userspace image processing on the IPU7 hardware ISP
# (PSys), loaded by the icamerasrc GStreamer element.
#
# Vendored from nixpkgs PR #542085; drop once that merges and use
# pkgs.ipu75xa-camera-hal instead.
let
  ipuTarget =
    {
      "ipu7x" = "ipu_lnl";
      "ipu75xa" = "ipu_lnl";
    }
    .${ipuVersion};
in
stdenv.mkDerivation {
  pname = "${ipuVersion}-camera-hal";
  # Master rather than the 20260629_1 release: kernel >= 7.2 inserts the
  # in-tree intel_cvs V4L2 subdev ("Intel CVS") between the sensor and the
  # CSI-2 receiver, and only HAL master (>= 2026-08-12, intel/ipu7-camera-hal
  # PR #59) knows how to resolve the I2C bus and set up media links through
  # it. The release HAL misparses the graph ("I2CBus:S") and STREAMON fails
  # with EPIPE.
  version = "0-unstable-2026-08-12";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu7-camera-hal";
    rev = "11d8aff0d1ddc16aef56c8e6518e08e2f936a95b";
    hash = "sha256-NSZVVOZKa3xhwitdKw4EZpukf5B/ObQC4GEDwHMmZ6s=";
  };

  # PR #59 only converted the ipu8 sensor config to the CVS-routed topology;
  # apply the same change (Intel CVS pad formats + sensor->CVS->CSI2 links)
  # to the ipu75xa ov08x40 config this laptop uses.
  patches = [ ./ipu75xa-ov08x40-cvs.patch ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DBUILD_CAMHAL_ADAPTOR=ON"
    "-DBUILD_CAMHAL_PLUGIN=ON"
    "-DIPU_VERSIONS=${ipuVersion}"
    "-DUSE_STATIC_GRAPH=ON"
    "-DUSE_STATIC_GRAPH_AUTOGEN=ON"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  enableParallelBuilding = true;

  buildInputs = [
    expat
    ipu7-camera-bins
    jsoncpp
    libtool
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libdrm
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set (CMAKE_CXX_STANDARD 11)' \
                     'set (CMAKE_CXX_STANDARD 17)'
    substituteInPlace src/platformdata/JsonParserBase.h \
      --replace-fail '<jsoncpp/json/json.h>' '<json/json.h>'
  '';

  postInstall = ''
    mkdir -p $out/include/${ipuTarget}/
    cp -r $src/include $out/include/${ipuTarget}/libcamhal
  '';

  postFixup = ''
    for lib in $out/lib/*.so; do
      patchelf --add-rpath "${ipu7-camera-bins}/lib" $lib
    done
  '';

  passthru = {
    inherit ipuVersion ipuTarget;
  };

  meta = {
    description = "HAL for processing of images in userspace";
    homepage = "https://github.com/intel/ipu7-camera-hal";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
