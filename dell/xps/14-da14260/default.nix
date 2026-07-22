{
  lib,
  pkgs,
  config,
  ...
}:
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
  boot.extraModulePackages = [
    (config.boot.kernelPackages.callPackage ./intel-cvs { })
    config.boot.kernelPackages.v4l2loopback
  ];
  boot.kernelModules = [
    "intel_cvs"
    "v4l2loopback"
  ];
  # Don't let v4l2loopback auto-create a device at load time — an unconfigured
  # device has a degenerate framerate range that breaks GStreamer caps
  # negotiation. The relay service below creates a configured device at runtime.
  boot.extraModprobeConfig = "options v4l2loopback devices=0";

  # Prevent the SVP7500 USB bridge from autosuspending; the bridge firmware
  # has issues with power-state transitions that cause it to wedge on resume.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="06cb", ATTRS{idProduct}=="0701", ATTR{power/autosuspend}="-1"
  '';

  # The IPU7 camera works through libcamera (the `simple` pipeline + soft ISP),
  # but most applications (browsers, video-conferencing, cheese) only speak V4L2
  # and cannot use libcamera directly. v4l2-relayd runs a GStreamer libcamerasrc
  # pipeline and feeds a v4l2loopback device ("Intel IPU7 Camera") that any V4L2
  # app can open.
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
        ++ [ pkgs.libcamera ]
      );
      v4l2loopback-ctl = "${config.boot.kernelPackages.v4l2loopback.bin}/bin/v4l2loopback-ctl";
      deviceFile = "/run/ipu7-camera-relay/device";

      # libcamerasrc emits RGBA at the sensor's native resolution; videoconvert +
      # videoscale adapt it to the loopback format and videoflip fixes orientation
      # (flip placed after the downscale so it operates on the small frame). The
      # panel mounts the sensor upside down (needs rotate-180 = H+V to make it
      # upright); a `vertical-flip` instead gives upright + left-right MIRROR, i.e.
      # the usual selfie view (rotate-180 then a horizontal mirror reduces to V).
      # videobalance boosts saturation because the soft ISP (IPASoft) produces a
      # flat, washed-out image.
      # Do NOT append a bare caps filter (e.g. `! video/x-raw,format=YUY2,...`):
      # v4l2-relayd parses this with the single-string gst_parse_launch, which
      # mis-tokenizes bare caps ("no element video", treats `/x-raw...` as a URI)
      # so the input pipeline fails to build and only the black splash is shown.
      # v4l2-relayd applies the caps (copied from the output appsrc below) to its
      # internal appsink instead.
      input = "libcamerasrc ! videoconvert ! videoscale ! videobalance saturation=1.8 ! videoflip method=vertical-flip";

      # A leaky queue (drops old frames) + sync=false keep latency low so the
      # viewer sees the latest frame instead of a backlog; the -b 4 buffers in
      # preStart are enough to sustain full framerate without adding lag.
      output =
        "appsrc name=appsrc caps=video/x-raw,format=YUY2,width=1280,height=720,framerate=30/1"
        + " ! queue leaky=downstream max-size-buffers=3 ! videoconvert ! v4l2sink name=v4l2sink device=$(cat ${deviceFile}) sync=false";
    in
    {
      description = "Intel IPU7 camera to v4l2loopback relay (libcamera bridge)";
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
