{
  lib,
  pkgs,
  config,
  ...
}:
let
  # IPU7 hardware-ISP userspace stack (Intel camera HAL + proprietary AIQ
  # tuning blobs + icamerasrc GStreamer element), vendored from nixpkgs PR
  # #542085 until it merges. Once `hardware.ipu7` exists in nixpkgs, replace
  # all of this (and the vendored packages) with:
  #   hardware.ipu7 = { enable = true; platform = "ipu75xa"; };
  # Note: ipu7-camera-bins is unfree — see README.md.
  ipu7-camera-bins = pkgs.callPackage ./ipu7-camera-bins { };
  ipu7-camera-hal = pkgs.callPackage ./ipu7-camera-hal { inherit ipu7-camera-bins; };
  icamerasrc = pkgs.callPackage ./icamerasrc { inherit ipu7-camera-hal; };
in
{
  imports = [
    ../../../common/cpu/intel/panther-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # We need at least 7.0 to have a working mic
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "7.0") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  # Intel CVS driver for Synaptics SVP7500 camera bridge (06CB:0701).
  # Without this the IPU7 camera stack does not enumerate even though the
  # kernel-side intel_ipu7 driver detects the sensor (OVTI08F4 / OV08F4).
  # The patch removes a spurious IRQF_ONESHOT flag from a non-threaded IRQ
  # handler that causes the bridge to wedge after brief idle periods.
  # See: https://github.com/intel/vision-drivers/issues/37
  #
  # Kernel >= 7.2 ships an in-tree intel_cvs (drivers/media/i2c/cvs) that
  # registers the V4L2 subdev which the 7.2 ipu-bridge now routes the sensor
  # graph through (INTC10E1 is in its IVSC/CVS companion list). The
  # out-of-tree module registers no subdev and would shadow the in-tree one
  # (same module name, depmod updates/ priority), leaving the ISYS async
  # notifier waiting forever — so only vendor it for older kernels.
  boot.extraModulePackages = [
    # PSys module for the hardware ISP; the in-tree staging driver only has
    # the core + ISys (raw capture), which forces the untuned software ISP.
    (config.boot.kernelPackages.callPackage ./ipu7-drivers { })
    config.boot.kernelPackages.v4l2loopback
  ]
  ++ lib.optional (lib.versionOlder config.boot.kernelPackages.kernel.version "7.2") (
    config.boot.kernelPackages.callPackage ./intel-cvs { }
  );
  boot.kernelModules = [
    "intel_cvs"
    "v4l2loopback"
  ];
  # Don't let v4l2loopback auto-create a device at load time — an unconfigured
  # device has a degenerate framerate range that breaks GStreamer caps
  # negotiation. The relay service below creates a configured device at runtime.
  boot.extraModprobeConfig = "options v4l2loopback devices=0";

  # IPU firmware + AIQ blobs for the hardware ISP. ivsc-firmware is kept for
  # parity with the tested `hardware.ipu7` config from nixpkgs #542085, though
  # this machine bridges the sensor through a Synaptics SVP7500 (intel_cvs)
  # rather than Intel IVSC — it may turn out to be droppable.
  hardware.firmware = [
    ipu7-camera-bins
    pkgs.ivsc-firmware
  ];

  # Prevent the SVP7500 USB bridge from autosuspending; the bridge firmware
  # has issues with power-state transitions that cause it to wedge on resume.
  # The intel-ipu7-psys rule lets the camera HAL (running as the relay/user)
  # open the PSys device node.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="06cb", ATTRS{idProduct}=="0701", ATTR{power/autosuspend}="-1"
    SUBSYSTEM=="intel-ipu7-psys", MODE="0660", GROUP="video"
  '';

  # The IPU7 camera is driven through the Intel camera HAL (hardware ISP with
  # per-sensor AIQ tuning — proper colours, low CPU), but applications only
  # speak V4L2 and cannot use the HAL directly. v4l2-relayd runs a GStreamer
  # icamerasrc pipeline and feeds a v4l2loopback device ("Intel IPU7 Camera")
  # that any V4L2 app can open.
  #
  # This is a hand-rolled service rather than `services.v4l2-relayd` because that
  # module creates the loopback with the default 2 buffers (which throttles the
  # stream to ~3 fps) and only inserts a `queue` before its v4l2sink when the
  # input/output formats differ. Full framerate needs BOTH more buffers (-b 4)
  # and a `queue` (+ sync=false) on the output, which the module cannot express.
  systemd.services.ipu7-camera-relay =
    let
      gstPluginPath = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
        (with pkgs.gst_all_1; [
          gstreamer.out
          gst-plugins-base
          gst-plugins-good
          gst-plugins-bad
        ])
        ++ [ icamerasrc ]
      );
      v4l2loopback-ctl = "${config.boot.kernelPackages.v4l2loopback.bin}/bin/v4l2loopback-ctl";
      deviceFile = "/run/ipu7-camera-relay/device";

      # icamerasrc emits NV12 from the hardware ISP (already colour-corrected by
      # the AIQ tuning, so no videobalance hack is needed); videoconvert +
      # videoscale adapt it to the loopback format (both are passthrough when the
      # output caps match icamerasrc's native NV12) and videoflip fixes
      # orientation — benchmarked as free even on full 4K frames. The panel
      # mounts the sensor upside down (needs rotate-180 = H+V to make it
      # upright); a `vertical-flip` instead gives upright + left-right MIRROR, i.e.
      # the usual selfie view (rotate-180 then a horizontal mirror reduces to V).
      # Do NOT append a bare caps filter (e.g. `! video/x-raw,format=YUY2,...`):
      # v4l2-relayd parses this with the single-string gst_parse_launch, which
      # mis-tokenizes bare caps ("no element video", treats `/x-raw...` as a URI)
      # so the input pipeline fails to build and only the black splash is shown.
      # v4l2-relayd applies the caps (copied from the output appsrc below) to its
      # internal appsink instead.
      input = "icamerasrc ! videoconvert ! videoscale ! videoflip method=vertical-flip";

      # A leaky queue (drops old frames) + sync=false keep latency low so the
      # viewer sees the latest frame instead of a backlog; the -b 4 buffers in
      # preStart are enough to sustain full framerate without adding lag.
      #
      # 3840x2160 NV12: the sensor has a single native mode (3856x2176 @
      # 28.57 fps) and the hardware ISP scales, so 4K costs nothing over 720p —
      # benchmarked ~28.6 fps with zero drops at 720p/1080p/4K, flip included
      # (higher framerates are not possible: the sensor ignores 60/1 caps and
      # keeps its native cadence). NV12 is icamerasrc's native output, so the
      # videoconvert stages are passthrough instead of per-frame conversions.
      # Lower width/height here if a consumer struggles with 4K input.
      output =
        "appsrc name=appsrc caps=video/x-raw,format=NV12,width=3840,height=2160,framerate=30/1"
        + " ! queue leaky=downstream max-size-buffers=3 ! videoconvert ! v4l2sink name=v4l2sink device=$(cat ${deviceFile}) sync=false";
    in
    {
      description = "Intel IPU7 camera to v4l2loopback relay (hardware ISP via camera HAL)";
      after = [ "modprobe@v4l2loopback.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        GST_PLUGIN_PATH = gstPluginPath;
        V4L2_DEVICE_FILE = deviceFile;
      };
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 2;
        RuntimeDirectory = "ipu7-camera-relay";
      };
      preStart = ''
        ${v4l2loopback-ctl} add -b 4 -x 1 -n "Intel IPU7 Camera" > ${deviceFile}
      '';
      script = ''
        exec ${pkgs.v4l2-relayd}/bin/v4l2-relayd -i "${input}" -o "${output}"
      '';
      postStop = ''
        ${v4l2loopback-ctl} delete "$(cat ${deviceFile})" || true
      '';
    };

  # See https://github.com/NixOS/nixos-hardware/pull/127
  services.thermald.enable = true;

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = true;
}
