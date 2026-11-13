{
  lib,
  howdy,
  fetchFromGitHub,
  v4l-utils,
}:

# Howdy, with the fix pack's raw-V4L2 recorder for the HM1092 spliced in.
#
# Stock Howdy 3.0.0 ships three recorders and none can use this sensor:
#   - opencv  (cv2.VideoCapture): cannot decode the raw 10-bit Bayer-tagged
#     frames the ISYS node hands out ('BA10'); read() just returns False.
#   - ffmpeg: would debayer a physically-monochrome sensor.
#   - pyv4l2: hard-codes a 352x352 mono geometry.
# All three also leave the flood illuminator dark -- INT3472 owns that GPIO, so
# the sensor driver exposes it as a LED classdev and something in userspace has
# to toggle it around each scan.
#
# recorders/ir_reader.py (recording_plugin = "ir") reads the node directly as
# greyscale at its native 648x368, configures the CSI-2 pipeline by walking the
# media graph, and drives the illuminator with a signal/atexit failsafe. It is
# taken verbatim from the fix pack, pinned to the same revision as
# ../hm1092/intel-cvs-ir so the two move together.
let
  fixPack = fetchFromGitHub {
    owner = "HritwikSinghal";
    repo = "svp7500-camera-fix-pack";
    tag = "nixos-pin-2026-08-27";
    hash = "sha256-+vWsihrgfU0AXi2PFRmM6AYjVyDCTQcTfa0Gv+TkSso=";
  };
in
howdy.overrideAttrs (old: {
  patches = (old.patches or [ ]) ++ [ ./video-capture-ir-dispatch.patch ];

  postPatch = (old.postPatch or "") + ''
    cp ${fixPack}/howdy/ir_reader.py howdy/src/recorders/ir_reader.py

    # ir_reader shells out to media-ctl by bare name; the PATH pam_howdy runs
    # under has no such entry.
    substituteInPlace howdy/src/recorders/ir_reader.py \
      --replace-fail '"media-ctl"' '"${lib.getExe' v4l-utils "media-ctl"}"'

    # meson installs an explicit source list, so the new file has to be added
    # to it or it is silently dropped from $out.
    substituteInPlace howdy/src/meson.build \
      --replace-fail "'recorders/__init__.py'," \
                     "'recorders/__init__.py', 'recorders/ir_reader.py',"
  '';
})
