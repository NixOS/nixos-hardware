{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    optionalAttrs
    types
    versionAtLeast
    versionOlder
    ;

  cfg = config.hardware.dell-xps-14-da14260.irCamera;

  kernelVersion = config.boot.kernelPackages.kernel.version;

  # services.howdy landed in nixpkgs only in early 2026; nixos-hardware still
  # evaluates against older channels that lack it, so every reference to the
  # option -- and to ./howdy-ir, which needs pkgs.howdy -- is gated on this.
  hasHowdyModule = options.services ? howdy;
in
{
  # Kept out of the `config` block below so that block stays a verbatim part of
  # the base opt-in; these are the pipeline unit and the optional Howdy wiring.
  imports = [
    (mkIf cfg.enable {
      assertions = [
        {
          assertion = !cfg.howdy.enable || hasHowdyModule;
          message = ''
            hardware.dell-xps-14-da14260.irCamera.howdy is enabled, but this
            nixpkgs has no services.howdy module (added early 2026). Upgrade
            nixpkgs, or set Howdy up by hand against /dev/ir-camera -- ./howdy-ir
            is the recorder it needs.
          '';
        }
      ];

      # Bring the IR capture pipeline up at boot.
      #
      # The IPU7 media graph starts with the CSI2 -> ISYS Capture link DISABLED
      # and every pad at its 4096x3072 default, while the sensor emits
      # SGRBG10_1X10/648x368 -- so a bare VIDIOC_STREAMON on /dev/ir-camera
      # fails link validation (-ENOLINK on a fresh graph, -EPIPE once the link
      # is up but the pads still disagree). libcamera would propagate the format
      # itself, but it also debayers this physically-mono sensor, so the IR path
      # bypasses it.
      #
      # ./howdy-ir's recorder does the same setup from userspace, so this unit
      # is not required when Howdy is the only consumer -- it is here so a plain
      # `v4l2-ctl --stream-mmap -d /dev/ir-camera` or `ffmpeg -f v4l2 ...` works
      # after boot without manual media-ctl, which is also the first thing to
      # try when frames come back dark. Port 2 matches the udev rule above
      # (entity 16 = port 2 by construction on this board); the media device is
      # found by driver name rather than assuming /dev/media0.
      systemd.services.ir-camera-pipeline = {
        description = "Bring up the HM1092 IR camera CSI-2 pipeline";
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-udev-settle.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        path = [
          pkgs.v4l-utils
          pkgs.coreutils
        ];
        script = ''
          set -eu

          # /dev/ir-camera comes from the udev rule below; the media node it
          # rides on can appear a moment after udev settle.
          node=
          for _ in $(seq 1 50); do
            if [ -e /dev/ir-camera ]; then
              node=/dev/ir-camera
              break
            fi
            sleep 0.2
          done
          if [ -z "$node" ]; then
            echo "/dev/ir-camera never appeared; nothing to do"
            exit 0
          fi

          md=
          for m in /dev/media*; do
            [ -e "$m" ] || continue
            if media-ctl -d "$m" -p 2>/dev/null | grep -qE 'driver[[:space:]]+intel-ipu7'; then
              md=$m
              break
            fi
          done
          if [ -z "$md" ]; then
            echo "no intel-ipu7 media device found; nothing to do"
            exit 0
          fi

          if ! media-ctl -d "$md" -p 2>/dev/null | grep -q '"Intel IPU7 CSI2 2"'; then
            echo "CSI-2 port 2 entity absent; nothing to do"
            exit 0
          fi

          media-ctl -d "$md" -V '"Intel IPU7 CSI2 2":0 [fmt:SGRBG10_1X10/648x368]'
          media-ctl -d "$md" -V '"Intel IPU7 CSI2 2":1 [fmt:SGRBG10_1X10/648x368]'

          # Pre-set the capture node so `v4l2-ctl --stream` / `ffmpeg -f v4l2`
          # work with no explicit format. Howdy's recorder sets its own.
          v4l2-ctl -d "$node" --set-fmt-video=width=648,height=368,pixelformat=BA10 || true
        '';
      };
    })

    # Howdy against the HM1092. Everything here is overridable; see the
    # howdy.enable option description and ./howdy-ir. optionalAttrs (not just the
    # assertion) so that on a nixpkgs without services.howdy this contributes no
    # definition at all -- the module system surfaces attr paths through a
    # disabled mkIf, and an unmatched services.howdy would abort evaluation.
    (mkIf (cfg.enable && cfg.howdy.enable) (
      optionalAttrs hasHowdyModule {
        services.howdy = {
          enable = true;
          package = pkgs.callPackage ./howdy-ir { };

          # 'required' would make a face match a hard second factor on every
          # sudo/login and lock you out whenever IR is flaky; keep the password
          # path. mkDefault so a user who wants 2FA can still opt in.
          control = mkDefault "sufficient";

          settings.video = {
            # The custom recorder from ./howdy-ir. Reads the node as raw
            # greyscale rather than letting opencv/ffmpeg mishandle the
            # Bayer-tagged mono frames.
            recording_plugin = "ir";
            device_path = "/dev/ir-camera";
            # Reject a frame only when >90% of it is near-black after CLAHE --
            # lenient, because the scene is lit solely by the flood illuminator.
            dark_threshold = 90;
            timeout = 6;
          };
        };
      }
    ))
  ];
  options = {
    hardware.dell-xps-14-da14260.irCamera = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable the HM1092 infrared camera (the Windows Hello sensor), for use
          with a face-authentication stack such as Howdy.

          This is opt-in because it needs a patched kernel: ipu-bridge only
          learned the sensor's ACPI ID after Linux 7.2, so on anything older the
          profile adds a single-entry kernel patch, and that means building the
          kernel locally rather than substituting it from the binary cache.

          Enabling it also swaps the vendored intel_cvs bridge module for the
          fix pack's fork of it (intel-cvs-ir), which exports the
          cvs_send_mipi_ir_config the sensor driver needs to get CSI-2 port-2
          forwarding configured; the plain intel/vision-drivers build exports
          no symbols and leaves every IR frame dark.

          The sensor shows up as `/dev/ir-camera`, a stable symlink to whichever
          ISYS capture node it lands on for this boot. Point a face-auth
          configuration at that rather than at a `/dev/videoN` number, which is
          not stable across reboots.

          An assertion restricts this to 7.1.x. Below 7.1 int3472 does not
          register the illuminator as a LED device, so there is nothing for the
          udev rule to grant and every frame comes back dark. From 7.2 the
          in-tree cvs driver routes the sensor graph through its own V4L2 subdev
          instead of the out-of-tree intel_cvs this was tested against, which is
          untested rather than known-broken -- see the assertion message.
        '';
      };

      howdy.enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Wire up Howdy (`services.howdy`) to authenticate against this camera.
          Requires `hardware.dell-xps-14-da14260.irCamera.enable`.

          Stock Howdy cannot use the HM1092: its opencv recorder cannot decode
          the raw 10-bit Bayer-tagged frames, its ffmpeg recorder would debayer
          a physically-monochrome sensor, and none of them drive the flood
          illuminator. This installs a `howdy` built with a fourth recorder,
          `recording_plugin = "ir"`, that reads `/dev/ir-camera` directly as
          greyscale, sets up the CSI-2 pipeline, and toggles the illuminator
          around each scan.

          Sets `services.howdy.package` and `.settings.video`, and as a
          `mkDefault` sets `.control = "sufficient"` so a flaky IR scan cannot
          lock you out of the password path. Everything under `services.howdy`
          stays overridable; enrol with `howdy add` after a rebuild.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        # The illuminator LED classdev only exists from 7.1: int3472's
        # discrete.c gained the INT3472_GPIO_TYPE_STROBE -> "ir_flood" mapping
        # and skl_int3472_register_led() there (absent at 7.0). Below that the
        # udev rule matches nothing and every frame comes back dark, which
        # looks exactly like broken hardware.
        assertion = versionAtLeast kernelVersion "7.1" && versionOlder kernelVersion "7.2";
        message = ''
          hardware.dell-xps-14-da14260.irCamera is enabled, but the configured
          kernel is ${kernelVersion}. The supported window is 7.1.x.

          Below 7.1: int3472 has no INT3472_GPIO_TYPE_STROBE -> "ir_flood"
          mapping and does not call skl_int3472_register_led(), so the
          illuminator is never exposed as a LED device. The udev rule below then
          matches nothing, the illuminator never fires, and every frame comes
          back too dark to find a face in.

          From 7.2: the in-tree drivers/media/i2c/cvs driver replaces the
          out-of-tree intel_cvs this was verified against, and routes the sensor
          graph through its own V4L2 subdev -- the same topology change that
          broke the RGB camera HAL until it was made CVS-aware.

          This is untested, not known-broken: the in-tree driver sends
          HOST_SET_MIPI_CONFIG itself from csi_set_link_cfg(), taking the link
          frequency from the sensor's own control, and 06CB:0701 is not quirked
          out of that path -- so the bridge configuration hm1092 used to request
          via cvs_send_mipi_ir_config may simply happen anyway.

          The one mechanism that might genuinely block it: ipu-bridge finishes
          ipu_bridge_instantiate_ivsc() with set_secondary_fwnode() on the
          shared csi_dev, once per sensor and overwriting unconditionally, while
          the in-tree cvs models exactly one remote. Both sensors sit behind the
          same INTC10E1:00, so only one can own that fwnode. Whether that
          affects the IR sensor depends on its ACPI _DEP, which has not been
          read off a DSDT yet.

          Pin a kernel older than 7.2, or disable this option. If you want to
          help settle it, say so upstream rather than editing this assertion out
          blind -- the failure mode to watch for is the RGB camera regressing.
        '';
      }
    ];

    # ipu-bridge only walks ipu_supported_sensors[], so an unlisted ACPI HID
    # never gets a software node built for it. The i2c client itself still
    # enumerates -- that comes from ACPI I2cSerialBus, independently -- but
    # without the fwnode graph the IPU7 ISYS async notifier has no port to match
    # it against, so it probes and then never joins the media graph. The entry
    # is in mainline master but landed after 7.2, so it has to be backported on
    # anything older, including 7.2 itself. This rebuilds the kernel, which is
    # why the whole option is opt-in.
    boot.kernelPatches = [
      {
        name = "ipu-bridge-himx1092";
        patch = ./himx1092-ipu-bridge.patch;
      }
    ];

    # The sensor driver. It has no in-tree counterpart, so unlike the packages
    # vendored from nixpkgs #542085 this one has no upstream to defer to.
    #
    # intel-cvs-ir REPLACES the base profile's intel-cvs (default.nix drops
    # its entry when this option is enabled -- same intel_cvs.ko name, only
    # one may be in the tree). It is the fix-pack fork of the same driver,
    # and it is what makes this option functional: hm1092 requests port-2
    # forwarding through a weak reference to cvs_send_mipi_ir_config, which
    # only the fork exports -- the plain intel/vision-drivers rev exports
    # nothing, the reference resolves NULL, and every frame stays dark. This
    # is also why the base profile's `< 7.2` intel-cvs gate genuinely bounds
    # this option: the IR path needs an out-of-tree intel_cvs, and from 7.2
    # the in-tree cvs driver owns the device instead (see the assertion).
    boot.extraModulePackages = [
      (config.boot.kernelPackages.callPackage ./hm1092 { })
      (config.boot.kernelPackages.callPackage ./hm1092/intel-cvs-ir { })
    ];

    # hm1092 autoloads off the i2c adapter via its ACPI modalias, on a different
    # trigger from the softdep in default.nix -- which orders the bridge stack
    # only ahead of intel_ipu7, not ahead of the sensor. That matters because
    # hm1092's probe is deliberately one-shot: hm1092_check_chip_id() returns
    # -ENODEV for any I2C failure rather than -EPROBE_DEFER (retries were found
    # to wedge the USB bus), and its regulator/clock lookups are "optional", so
    # they fall back to NULL instead of deferring. Probe before INT3472 has
    # registered dvdd and the 19.2 MHz clock and the sensor is simply dead until
    # someone re-binds it by hand. Order it explicitly.
    boot.extraModprobeConfig = ''
      softdep hm1092 pre: intel_skl_int3472_discrete intel_cvs
    '';

    # The IR flood illuminator is exposed by INT3472 as a LED class device, so
    # it has no /dev node and udev's GROUP=/MODE= cannot reach it -- only the
    # `brightness` sysfs attribute matters, and it is root-only by default.
    # (The upstream fix-pack rule calls /bin/chgrp and /bin/chmod, which do not
    # exist on NixOS and make the rule a silent no-op, hence the store paths.)
    #
    # This grant is no longer load-bearing: ./hm1092 now resolves the same LED
    # through int3472's lookup and drives it around streaming itself, in kernel
    # context, so an unmodified consumer gets lit frames without touching sysfs.
    # It is kept because the emitter is otherwise invisible to a user debugging
    # a dark-frames report -- being able to run
    #   echo 1 > /sys/class/leds/HIMX1092_00::ir_flood_led/brightness
    # and see whether the scene lights up separates a sensor problem from an
    # illuminator problem in one step. Measured on a DA14260: 100% near-black
    # pixels unlit versus 0.4% lit.
    #
    # The second rule hands out a stable path for the IR capture node itself.
    # ISYS registers one capture node per CSI-2 stream (~32 on this machine) and
    # /dev/videoN numbering follows registration order, so the IR node's number
    # is not stable across boots and there is nothing safe to write into a
    # face-auth config. Worse, the numeric default such configs usually ship,
    # /dev/video2, is a real but unrelated ISYS node here -- so getting it wrong
    # opens the wrong camera rather than failing to open one.
    #
    # The V4L2 card name is stable, and it names the capture entity rather than
    # the node: the sensor's link into "Intel IPU7 CSI2 2" is IMMUTABLE, that
    # port's first pad is the only ENABLED link out of it, and ISYS allocates
    # capture entities eight per CSI-2 port -- so port 2 is entity 16 by
    # construction, whatever /dev/videoN it happens to get. udev exposes that
    # name as ATTR{name}.
    #
    # Do not switch this to the sensor's i2c name ("hm1092 16-0024"): the 16
    # there is the usbio-tunnelled bus number, which genuinely does vary.
    services.udev.extraRules = ''
      SUBSYSTEM=="leds", KERNEL=="*ir_flood_led*", ACTION=="add|change", RUN+="${pkgs.coreutils}/bin/chgrp video /sys%p/brightness", RUN+="${pkgs.coreutils}/bin/chmod 0664 /sys%p/brightness"
      SUBSYSTEM=="video4linux", ATTR{name}=="Intel IPU7 ISYS Capture 16", SYMLINK+="ir-camera"
    '';
  };
}
